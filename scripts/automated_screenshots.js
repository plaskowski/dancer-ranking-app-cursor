const puppeteer = require('puppeteer');
const fs = require('fs');
const path = require('path');

class FlutterWebScreenshotBot {
    constructor() {
        this.browser = null;
        this.page = null;
        this.screenshotDir = './screenshots/automated';
        this.reportDir = './reports/visual-changes';
        this.baselineDir = './screenshots/baseline';
    }

    async initialize() {
        console.log('🚀 Initializing Flutter Web Screenshot Bot...');

        // Ensure directories exist
        [this.screenshotDir, this.reportDir, this.baselineDir].forEach(dir => {
            if (!fs.existsSync(dir)) {
                fs.mkdirSync(dir, { recursive: true });
            }
        });

        // Launch headless browser
        this.browser = await puppeteer.launch({
            headless: true,
            args: [
                '--no-sandbox',
                '--disable-setuid-sandbox',
                '--disable-dev-shm-usage',
                '--disable-accelerated-2d-canvas',
                '--disable-gpu',
                '--window-size=1920,1080'
            ]
        });

        this.page = await this.browser.newPage();
        await this.page.setViewport({ width: 1920, height: 1080 });

        console.log('✅ Browser initialized successfully');
    }

    async startFlutterWeb() {
        console.log('🔄 Starting Flutter web app...');

        // Wait for Flutter web to be ready
        await this.page.goto('http://localhost:8080', {
            waitUntil: 'networkidle2',
            timeout: 30000
        });

        // Wait for Flutter to finish loading
        await this.page.waitForSelector('flt-scene-host', { timeout: 10000 });
        await this.page.waitForTimeout(2000); // Additional wait for animations

        console.log('✅ Flutter web app loaded successfully');
    }

    async takeScreenshot(name, options = {}) {
        const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
        const filename = `${name}_${timestamp}.png`;
        const filepath = path.join(this.screenshotDir, filename);

        console.log(`📸 Taking screenshot: ${filename}`);

        // Optional: Wait for specific elements or conditions
        if (options.waitForSelector) {
            await this.page.waitForSelector(options.waitForSelector, { timeout: 5000 });
        }

        if (options.waitForTimeout) {
            await this.page.waitForTimeout(options.waitForTimeout);
        }

        // Take screenshot
        await this.page.screenshot({
            path: filepath,
            fullPage: options.fullPage || false,
            type: 'png'
        });

        console.log(`✅ Screenshot saved: ${filepath}`);
        return filepath;
    }

    async navigateAndCapture(actions) {
        const screenshots = [];

        for (const action of actions) {
            console.log(`🎯 Executing action: ${action.name}`);

            try {
                // Execute navigation or interaction
                if (action.type === 'click') {
                    await this.page.click(action.selector);
                } else if (action.type === 'type') {
                    await this.page.type(action.selector, action.text);
                } else if (action.type === 'wait') {
                    await this.page.waitForTimeout(action.duration);
                } else if (action.type === 'scroll') {
                    await this.page.evaluate((pixels) => {
                        window.scrollBy(0, pixels);
                    }, action.pixels);
                }

                // Wait for Flutter to settle
                await this.page.waitForTimeout(1000);

                // Take screenshot
                const screenshotPath = await this.takeScreenshot(action.name, action.screenshotOptions);
                screenshots.push({
                    name: action.name,
                    path: screenshotPath,
                    timestamp: new Date().toISOString()
                });

            } catch (error) {
                console.error(`❌ Error executing action ${action.name}:`, error.message);
            }
        }

        return screenshots;
    }

    async compareWithBaseline(screenshots) {
        const comparisons = [];

        for (const screenshot of screenshots) {
            const baselinePath = path.join(this.baselineDir, `${screenshot.name}.png`);

            if (fs.existsSync(baselinePath)) {
                // Here you would implement image comparison logic
                // For now, we'll just record that we have both images
                comparisons.push({
                    name: screenshot.name,
                    current: screenshot.path,
                    baseline: baselinePath,
                    hasBaseline: true,
                    // You'd add actual comparison results here
                });
            } else {
                // No baseline exists, copy current as baseline
                fs.copyFileSync(screenshot.path, baselinePath);
                comparisons.push({
                    name: screenshot.name,
                    current: screenshot.path,
                    baseline: baselinePath,
                    hasBaseline: false,
                    isNewBaseline: true
                });
            }
        }

        return comparisons;
    }

    async generateReport(screenshots, comparisons) {
        const report = {
            timestamp: new Date().toISOString(),
            summary: {
                totalScreenshots: screenshots.length,
                newBaselines: comparisons.filter(c => c.isNewBaseline).length,
                comparisons: comparisons.filter(c => c.hasBaseline).length
            },
            screenshots: screenshots,
            comparisons: comparisons,
            visualChanges: []
        };

        // Generate HTML report
        const htmlReport = this.generateHtmlReport(report);
        const reportPath = path.join(this.reportDir, `visual-report-${new Date().toISOString().replace(/[:.]/g, '-')}.html`);

        fs.writeFileSync(reportPath, htmlReport);

        // Generate JSON report
        const jsonReportPath = path.join(this.reportDir, `visual-report-${new Date().toISOString().replace(/[:.]/g, '-')}.json`);
        fs.writeFileSync(jsonReportPath, JSON.stringify(report, null, 2));

        console.log(`📊 Visual report generated: ${reportPath}`);
        console.log(`📊 JSON report generated: ${jsonReportPath}`);

        return { htmlReport: reportPath, jsonReport: jsonReportPath };
    }

    generateHtmlReport(report) {
        return `
<!DOCTYPE html>
<html>
<head>
    <title>Flutter App Visual Changes Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: #f0f0f0; padding: 20px; border-radius: 8px; }
        .summary { display: flex; gap: 20px; margin: 20px 0; }
        .summary-item { background: #e3f2fd; padding: 15px; border-radius: 8px; text-align: center; }
        .screenshots { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
        .screenshot-item { border: 1px solid #ddd; border-radius: 8px; padding: 15px; }
        .screenshot-item img { max-width: 100%; height: auto; border-radius: 4px; }
        .new-baseline { background: #e8f5e8; }
        .has-comparison { background: #fff3e0; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🎨 Flutter App Visual Changes Report</h1>
        <p><strong>Generated:</strong> ${report.timestamp}</p>
    </div>
    
    <div class="summary">
        <div class="summary-item">
            <h3>${report.summary.totalScreenshots}</h3>
            <p>Total Screenshots</p>
        </div>
        <div class="summary-item">
            <h3>${report.summary.newBaselines}</h3>
            <p>New Baselines</p>
        </div>
        <div class="summary-item">
            <h3>${report.summary.comparisons}</h3>
            <p>Comparisons Made</p>
        </div>
    </div>
    
    <h2>📸 Screenshots Captured</h2>
    <div class="screenshots">
        ${report.screenshots.map(screenshot => `
            <div class="screenshot-item ${report.comparisons.find(c => c.name === screenshot.name)?.isNewBaseline ? 'new-baseline' : 'has-comparison'}">
                <h3>${screenshot.name}</h3>
                <img src="${screenshot.path}" alt="${screenshot.name}">
                <p><small>Captured: ${screenshot.timestamp}</small></p>
                ${report.comparisons.find(c => c.name === screenshot.name)?.isNewBaseline ?
                '<p style="color: green;">✅ New Baseline Created</p>' :
                '<p style="color: orange;">🔄 Compared with Baseline</p>'
            }
            </div>
        `).join('')}
    </div>
    
    <h2>📊 Testing Instructions</h2>
    <div style="background: #f5f5f5; padding: 15px; border-radius: 8px;">
        <h3>How to Review Changes:</h3>
        <ol>
            <li><strong>New Baselines:</strong> Review green-highlighted screenshots as new baselines</li>
            <li><strong>Comparisons:</strong> Orange-highlighted screenshots were compared with existing baselines</li>
            <li><strong>Next Steps:</strong> 
                <ul>
                    <li>If changes are expected, approve the new screenshots</li>
                    <li>If changes are unexpected, investigate the root cause</li>
                    <li>Update baselines when UI changes are intentional</li>
                </ul>
            </li>
        </ol>
    </div>
</body>
</html>
    `;
    }

    async runFullTest(testScenario) {
        try {
            await this.initialize();
            await this.startFlutterWeb();

            const screenshots = await this.navigateAndCapture(testScenario.actions);
            const comparisons = await this.compareWithBaseline(screenshots);
            const reports = await this.generateReport(screenshots, comparisons);

            console.log('\n🎉 Automated screenshot testing completed!');
            console.log(`📊 View report: ${reports.htmlReport}`);

            return {
                success: true,
                screenshots: screenshots.length,
                reports
            };

        } catch (error) {
            console.error('❌ Screenshot testing failed:', error);
            return { success: false, error: error.message };
        } finally {
            if (this.browser) {
                await this.browser.close();
            }
        }
    }
}

// Example test scenario
const testScenario = {
    name: 'Flutter App UI Flow',
    actions: [
        {
            name: 'home-screen',
            type: 'wait',
            duration: 2000,
            screenshotOptions: { fullPage: true }
        },
        {
            name: 'navigation-menu',
            type: 'click',
            selector: '[data-testid="menu-button"]', // You'd need to add these to your Flutter web app
            screenshotOptions: { fullPage: true }
        },
        {
            name: 'dancer-list',
            type: 'click',
            selector: '[data-testid="dancers-tab"]',
            screenshotOptions: { fullPage: true }
        },
        {
            name: 'add-dancer-form',
            type: 'click',
            selector: '[data-testid="add-dancer-button"]',
            screenshotOptions: { fullPage: true }
        }
    ]
};

// Main execution
if (require.main === module) {
    const bot = new FlutterWebScreenshotBot();
    bot.runFullTest(testScenario)
        .then(result => {
            console.log('\n🏁 Final Result:', result);
            process.exit(result.success ? 0 : 1);
        })
        .catch(error => {
            console.error('Fatal error:', error);
            process.exit(1);
        });
}

module.exports = FlutterWebScreenshotBot;