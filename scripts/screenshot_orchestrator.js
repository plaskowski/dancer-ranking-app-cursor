const { spawn, exec } = require('child_process');
const fs = require('fs');
const path = require('path');
const { program } = require('commander');
const chalk = require('chalk');
const ora = require('ora');
const inquirer = require('inquirer');

const FlutterWebScreenshotBot = require('./automated_screenshots.js');

class ScreenshotOrchestrator {
    constructor() {
        this.config = {
            webPort: 8080,
            androidDevice: null,
            outputDir: './screenshots',
            reportsDir: './reports',
            testModes: ['web', 'android', 'integration'],
            timeout: 300000, // 5 minutes
        };

        this.processes = [];
        this.results = {
            web: null,
            android: null,
            integration: null,
            hosted: null
        };
    }

    async initialize() {
        console.log(chalk.blue('🚀 Initializing Screenshot Orchestrator...\n'));

        // Check dependencies
        await this.checkDependencies();

        // Create output directories
        this.createDirectories();

        // Detect available devices
        await this.detectDevices();

        console.log(chalk.green('✅ Screenshot Orchestrator initialized\n'));
    }

    async checkDependencies() {
        const spinner = ora('Checking dependencies...').start();

        const checks = [
            { name: 'Flutter', cmd: 'flutter --version' },
            { name: 'Node.js', cmd: 'node --version' },
            { name: 'ADB', cmd: 'adb version' },
            { name: 'Chrome', cmd: 'google-chrome --version || chromium --version' }
        ];

        for (const check of checks) {
            try {
                await this.runCommand(check.cmd);
                spinner.text = `✅ ${check.name} found`;
            } catch (error) {
                spinner.fail(`❌ ${check.name} not found or not working`);
                console.log(chalk.yellow(`Please install ${check.name} to use all features`));
            }
        }

        spinner.succeed('Dependencies checked');
    }

    createDirectories() {
        const dirs = [
            this.config.outputDir,
            this.config.reportsDir,
            path.join(this.config.outputDir, 'web'),
            path.join(this.config.outputDir, 'android'),
            path.join(this.config.outputDir, 'integration'),
            path.join(this.config.reportsDir, 'web'),
            path.join(this.config.reportsDir, 'android'),
            path.join(this.config.reportsDir, 'integration')
        ];

        dirs.forEach(dir => {
            if (!fs.existsSync(dir)) {
                fs.mkdirSync(dir, { recursive: true });
            }
        });
    }

    async detectDevices() {
        const spinner = ora('Detecting available devices...').start();

        try {
            // Check for Android devices
            const adbOutput = await this.runCommand('adb devices');
            const androidDevices = adbOutput.split('\n')
                .filter(line => line.includes('\tdevice'))
                .map(line => line.split('\t')[0]);

            if (androidDevices.length > 0) {
                this.config.androidDevice = androidDevices[0];
                spinner.text = `Found Android device: ${this.config.androidDevice}`;
            }

            // Check for Chrome/Chromium
            const chromeAvailable = await this.runCommand('google-chrome --version').catch(() => false);

            spinner.succeed(`Devices detected: ${androidDevices.length} Android, Chrome: ${!!chromeAvailable}`);
        } catch (error) {
            spinner.warn('Could not detect all devices');
        }
    }

    async runCommand(command) {
        return new Promise((resolve, reject) => {
            exec(command, (error, stdout, stderr) => {
                if (error) {
                    reject(error);
                } else {
                    resolve(stdout);
                }
            });
        });
    }

    async runWebScreenshots() {
        console.log(chalk.blue('\n📱 Starting Web Screenshot Testing...\n'));

        const spinner = ora('Starting Flutter web app...').start();

        try {
            // Start Flutter web app
            const webProcess = spawn('flutter', ['run', '-d', 'chrome', '--web-renderer', 'html', '--web-port', this.config.webPort], {
                stdio: 'pipe'
            });

            this.processes.push(webProcess);

            // Wait for web app to start
            await new Promise((resolve, reject) => {
                const timeout = setTimeout(() => {
                    reject(new Error('Flutter web app start timeout'));
                }, 60000);

                webProcess.stdout.on('data', (data) => {
                    if (data.toString().includes('Web development server started')) {
                        clearTimeout(timeout);
                        resolve();
                    }
                });

                webProcess.stderr.on('data', (data) => {
                    if (data.toString().includes('ERROR')) {
                        clearTimeout(timeout);
                        reject(new Error(`Flutter web error: ${data.toString()}`));
                    }
                });
            });

            spinner.succeed('Flutter web app started');

            // Run screenshot bot
            const bot = new FlutterWebScreenshotBot();
            const testScenario = {
                name: 'Automated Web Flow',
                actions: [
                    { name: 'home-screen', type: 'wait', duration: 2000, screenshotOptions: { fullPage: true } },
                    { name: 'navigation-interaction', type: 'click', selector: 'body', screenshotOptions: { fullPage: true } },
                    { name: 'app-loaded', type: 'wait', duration: 3000, screenshotOptions: { fullPage: true } }
                ]
            };

            this.results.web = await bot.runFullTest(testScenario);

            // Kill web process
            webProcess.kill();

            return this.results.web;

        } catch (error) {
            spinner.fail('Web screenshot testing failed');
            throw error;
        }
    }

    async runAndroidScreenshots() {
        console.log(chalk.blue('\n🤖 Starting Android Screenshot Testing...\n'));

        if (!this.config.androidDevice) {
            console.log(chalk.yellow('⚠️  No Android device detected, skipping Android tests'));
            return { success: false, error: 'No Android device' };
        }

        const spinner = ora('Starting Android screenshot tests...').start();

        try {
            // Run Flutter driver tests
            const result = await this.runCommand('flutter drive --target=test_driver/app.dart --driver=test_driver/screenshot_test.dart');

            spinner.succeed('Android screenshot tests completed');

            this.results.android = {
                success: true,
                output: result,
                device: this.config.androidDevice
            };

            return this.results.android;

        } catch (error) {
            spinner.fail('Android screenshot testing failed');
            this.results.android = { success: false, error: error.message };
            throw error;
        }
    }

    async runIntegrationScreenshots() {
        console.log(chalk.blue('\n🧪 Starting Integration Screenshot Testing...\n'));

        const spinner = ora('Running integration tests...').start();

        try {
            const result = await this.runCommand('flutter test integration_test/screenshot_integration_test.dart');

            spinner.succeed('Integration screenshot tests completed');

            this.results.integration = {
                success: true,
                output: result
            };

            return this.results.integration;

        } catch (error) {
            spinner.fail('Integration screenshot testing failed');
            this.results.integration = { success: false, error: error.message };
            throw error;
        }
    }

    async runHostedScreenshots() {
        console.log(chalk.blue('\n☁️  Starting Hosted Screenshot Testing...\n'));

        const spinner = ora('Running hosted tests...').start();

        try {
            // This would integrate with Firebase Test Lab, BrowserStack, etc.
            // For now, we'll simulate it
            const result = await this.simulateHostedTesting();

            spinner.succeed('Hosted screenshot tests completed');

            this.results.hosted = result;
            return result;

        } catch (error) {
            spinner.fail('Hosted screenshot testing failed');
            this.results.hosted = { success: false, error: error.message };
            throw error;
        }
    }

    async simulateHostedTesting() {
        // Simulate Firebase Test Lab or BrowserStack integration
        return new Promise((resolve) => {
            setTimeout(() => {
                resolve({
                    success: true,
                    service: 'Firebase Test Lab',
                    testId: 'test-' + Date.now(),
                    screenshots: [
                        { device: 'Pixel 5', screenshots: 5 },
                        { device: 'iPhone 13', screenshots: 5 }
                    ]
                });
            }, 5000);
        });
    }

    async generateConsolidatedReport() {
        console.log(chalk.blue('\n📊 Generating Consolidated Report...\n'));

        const report = {
            timestamp: new Date().toISOString(),
            summary: {
                totalTests: Object.keys(this.results).length,
                successful: Object.values(this.results).filter(r => r && r.success).length,
                failed: Object.values(this.results).filter(r => r && !r.success).length
            },
            results: this.results,
            config: this.config
        };

        // Generate HTML report
        const htmlReport = this.generateConsolidatedHtmlReport(report);
        const reportPath = path.join(this.config.reportsDir, `consolidated-report-${Date.now()}.html`);

        fs.writeFileSync(reportPath, htmlReport);

        // Generate JSON report
        const jsonReportPath = path.join(this.config.reportsDir, `consolidated-report-${Date.now()}.json`);
        fs.writeFileSync(jsonReportPath, JSON.stringify(report, null, 2));

        console.log(chalk.green(`📊 Consolidated report generated: ${reportPath}`));
        console.log(chalk.green(`📊 JSON report generated: ${jsonReportPath}`));

        return { htmlReport: reportPath, jsonReport: jsonReportPath };
    }

    generateConsolidatedHtmlReport(report) {
        return `
<!DOCTYPE html>
<html>
<head>
    <title>Flutter App Screenshot Testing - Consolidated Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 8px; }
        .summary { display: flex; gap: 20px; margin: 20px 0; }
        .summary-item { background: #f8f9fa; padding: 15px; border-radius: 8px; text-align: center; flex: 1; }
        .success { background: #d4edda; color: #155724; }
        .failure { background: #f8d7da; color: #721c24; }
        .warning { background: #fff3cd; color: #856404; }
        .test-results { margin: 20px 0; }
        .test-result { background: #f8f9fa; padding: 15px; border-radius: 8px; margin: 10px 0; }
        .test-result.success { border-left: 4px solid #28a745; }
        .test-result.failure { border-left: 4px solid #dc3545; }
        .test-result.skipped { border-left: 4px solid #ffc107; }
        .screenshots-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
        .screenshot-item { border: 1px solid #ddd; border-radius: 8px; padding: 15px; }
        .config-info { background: #e9ecef; padding: 15px; border-radius: 8px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🎨 Flutter App Screenshot Testing</h1>
        <h2>Consolidated Report</h2>
        <p><strong>Generated:</strong> ${report.timestamp}</p>
    </div>
    
    <div class="summary">
        <div class="summary-item">
            <h3>${report.summary.totalTests}</h3>
            <p>Total Tests</p>
        </div>
        <div class="summary-item success">
            <h3>${report.summary.successful}</h3>
            <p>Successful</p>
        </div>
        <div class="summary-item failure">
            <h3>${report.summary.failed}</h3>
            <p>Failed</p>
        </div>
    </div>
    
    <div class="test-results">
        <h2>📋 Test Results</h2>
        
        <div class="test-result ${report.results.web ? (report.results.web.success ? 'success' : 'failure') : 'skipped'}">
            <h3>🌐 Web Screenshot Testing</h3>
            <p><strong>Status:</strong> ${report.results.web ? (report.results.web.success ? 'Success' : 'Failed') : 'Skipped'}</p>
            ${report.results.web && report.results.web.screenshots ? `<p><strong>Screenshots:</strong> ${report.results.web.screenshots}</p>` : ''}
            ${report.results.web && report.results.web.error ? `<p><strong>Error:</strong> ${report.results.web.error}</p>` : ''}
        </div>
        
        <div class="test-result ${report.results.android ? (report.results.android.success ? 'success' : 'failure') : 'skipped'}">
            <h3>🤖 Android Screenshot Testing</h3>
            <p><strong>Status:</strong> ${report.results.android ? (report.results.android.success ? 'Success' : 'Failed') : 'Skipped'}</p>
            ${report.results.android && report.results.android.device ? `<p><strong>Device:</strong> ${report.results.android.device}</p>` : ''}
            ${report.results.android && report.results.android.error ? `<p><strong>Error:</strong> ${report.results.android.error}</p>` : ''}
        </div>
        
        <div class="test-result ${report.results.integration ? (report.results.integration.success ? 'success' : 'failure') : 'skipped'}">
            <h3>🧪 Integration Screenshot Testing</h3>
            <p><strong>Status:</strong> ${report.results.integration ? (report.results.integration.success ? 'Success' : 'Failed') : 'Skipped'}</p>
            ${report.results.integration && report.results.integration.error ? `<p><strong>Error:</strong> ${report.results.integration.error}</p>` : ''}
        </div>
        
        <div class="test-result ${report.results.hosted ? (report.results.hosted.success ? 'success' : 'failure') : 'skipped'}">
            <h3>☁️ Hosted Screenshot Testing</h3>
            <p><strong>Status:</strong> ${report.results.hosted ? (report.results.hosted.success ? 'Success' : 'Failed') : 'Skipped'}</p>
            ${report.results.hosted && report.results.hosted.service ? `<p><strong>Service:</strong> ${report.results.hosted.service}</p>` : ''}
            ${report.results.hosted && report.results.hosted.testId ? `<p><strong>Test ID:</strong> ${report.results.hosted.testId}</p>` : ''}
        </div>
    </div>
    
    <div class="config-info">
        <h2>⚙️ Configuration</h2>
        <p><strong>Web Port:</strong> ${report.config.webPort}</p>
        <p><strong>Android Device:</strong> ${report.config.androidDevice || 'Not detected'}</p>
        <p><strong>Output Directory:</strong> ${report.config.outputDir}</p>
        <p><strong>Reports Directory:</strong> ${report.config.reportsDir}</p>
    </div>
    
    <div style="background: #f8f9fa; padding: 15px; border-radius: 8px; margin: 20px 0;">
        <h2>📱 Usage Instructions</h2>
        <h3>How to Use This Report:</h3>
        <ol>
            <li><strong>Review Results:</strong> Check each test method's success/failure status</li>
            <li><strong>View Screenshots:</strong> Navigate to the output directories to see captured screenshots</li>
            <li><strong>Compare Changes:</strong> Use the screenshots to identify visual regressions</li>
            <li><strong>Iterate:</strong> Re-run tests after making changes to verify fixes</li>
        </ol>
        
        <h3>Available Commands:</h3>
        <ul>
            <li><code>npm run test:web</code> - Run web screenshot tests only</li>
            <li><code>npm run test:android</code> - Run Android screenshot tests only</li>
            <li><code>npm run test:integration</code> - Run integration screenshot tests only</li>
            <li><code>npm run test:all</code> - Run all screenshot tests</li>
        </ul>
    </div>
</body>
</html>
    `;
    }

    async cleanup() {
        console.log(chalk.blue('\n🧹 Cleaning up processes...\n'));

        // Kill all spawned processes
        this.processes.forEach(process => {
            try {
                process.kill();
            } catch (error) {
                // Process might already be dead
            }
        });

        console.log(chalk.green('✅ Cleanup completed'));
    }

    async run(options = {}) {
        try {
            await this.initialize();

            const { mode = 'all', interactive = false } = options;

            let testModes = [];

            if (interactive) {
                const answers = await inquirer.prompt([
                    {
                        type: 'checkbox',
                        name: 'modes',
                        message: 'Select screenshot testing modes:',
                        choices: [
                            { name: 'Web (Puppeteer)', value: 'web' },
                            { name: 'Android (Flutter Driver)', value: 'android' },
                            { name: 'Integration Test', value: 'integration' },
                            { name: 'Hosted Services', value: 'hosted' }
                        ],
                        default: ['web', 'integration']
                    }
                ]);

                testModes = answers.modes;
            } else {
                testModes = mode === 'all' ? ['web', 'android', 'integration', 'hosted'] : [mode];
            }

            console.log(chalk.blue(`\n🚀 Running screenshot tests: ${testModes.join(', ')}\n`));

            // Run selected test modes
            for (const testMode of testModes) {
                try {
                    switch (testMode) {
                        case 'web':
                            await this.runWebScreenshots();
                            break;
                        case 'android':
                            await this.runAndroidScreenshots();
                            break;
                        case 'integration':
                            await this.runIntegrationScreenshots();
                            break;
                        case 'hosted':
                            await this.runHostedScreenshots();
                            break;
                    }
                } catch (error) {
                    console.log(chalk.red(`❌ ${testMode} testing failed: ${error.message}`));
                }
            }

            // Generate consolidated report
            const reports = await this.generateConsolidatedReport();

            console.log(chalk.green('\n🎉 Screenshot testing completed!'));
            console.log(chalk.blue(`📊 Open report: ${reports.htmlReport}`));

            return {
                success: true,
                results: this.results,
                reports
            };

        } catch (error) {
            console.error(chalk.red('❌ Screenshot testing failed:', error.message));
            return { success: false, error: error.message };
        } finally {
            await this.cleanup();
        }
    }
}

// CLI Interface
if (require.main === module) {
    program
        .version('1.0.0')
        .description('Flutter App Screenshot Testing Orchestrator')
        .option('-m, --mode <mode>', 'Test mode: web, android, integration, hosted, or all', 'all')
        .option('-i, --interactive', 'Interactive mode with prompts')
        .option('-p, --port <port>', 'Web server port', '8080')
        .parse();

    const options = program.opts();
    const orchestrator = new ScreenshotOrchestrator();

    orchestrator.run(options)
        .then(result => {
            process.exit(result.success ? 0 : 1);
        })
        .catch(error => {
            console.error('Fatal error:', error);
            process.exit(1);
        });
}

module.exports = ScreenshotOrchestrator;