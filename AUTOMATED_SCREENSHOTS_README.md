# 🎨 Flutter App Automated Screenshot Testing

> **Comprehensive solution for automated visual testing and screenshot generation for Flutter applications**

This system provides multiple approaches to automatically run your Flutter app and capture screenshots programmatically, eliminating the need for manual screenshot testing and providing detailed visual reports.

## 🚀 Features

- **🌐 Web Automation**: Uses Puppeteer to automate Flutter web apps in headless Chrome
- **🤖 Android Automation**: Uses Flutter Driver with ADB to capture Android app screenshots
- **🧪 Integration Testing**: Uses Flutter's integration_test package for cross-platform screenshots
- **☁️ Hosted Services**: Framework for integrating with Firebase Test Lab, BrowserStack, etc.
- **📊 Detailed Reports**: Generates HTML and JSON reports with visual comparisons
- **🔄 Baseline Comparison**: Automatically compares with baseline images to detect regressions
- **🎯 Multiple Test Scenarios**: Supports custom test flows and user interactions
- **📱 Multi-Platform**: Works with web, Android, iOS, and desktop Flutter apps

## 📁 Project Structure

```
├── scripts/
│   ├── automated_screenshots.js     # Puppeteer web automation
│   ├── screenshot_orchestrator.js   # Main orchestration script
│   └── setup.sh                     # Setup script
├── test_driver/
│   ├── app.dart                     # Flutter driver app
│   └── screenshot_test.dart         # Android screenshot tests
├── integration_test/
│   └── screenshot_integration_test.dart # Integration tests
├── screenshots/                     # Generated screenshots
│   ├── web/
│   ├── android/
│   ├── integration/
│   └── baseline/
├── reports/                         # Generated reports
├── package.json                     # Node.js dependencies
└── screenshot_config.json           # Configuration file
```

## 🛠️ Installation & Setup

### 1. Quick Setup

```bash
# Make setup script executable
chmod +x scripts/setup.sh

# Run the setup script
./scripts/setup.sh
```

### 2. Manual Setup

```bash
# Install Node.js dependencies
npm install

# Install Flutter dependencies
flutter pub get

# Create directories
mkdir -p screenshots/{web,android,integration,baseline}
mkdir -p reports/{web,android,integration}
```

### 3. Prerequisites

- **Flutter SDK** (latest stable version)
- **Node.js** (v16 or higher)
- **Chrome/Chromium** browser
- **Android SDK with ADB** (for Android testing)
- **Git** (for version control)

## 🎯 Usage

### Interactive Mode (Recommended)

```bash
node scripts/screenshot_orchestrator.js --interactive
```

This will prompt you to select which testing methods to use.

### Command Line Options

```bash
# Run all screenshot tests
npm run test:all

# Run specific test types
npm run test:web          # Web automation only
npm run test:android      # Android testing only
npm run test:integration  # Integration tests only

# Orchestrator with options
node scripts/screenshot_orchestrator.js --mode web
node scripts/screenshot_orchestrator.js --mode all --port 8080
```

### Available Commands

| Command | Description |
|---------|-------------|
| `npm run setup` | Install all dependencies |
| `npm run test:web` | Run web screenshot automation |
| `npm run test:android` | Run Android screenshot tests |
| `npm run test:integration` | Run integration screenshot tests |
| `npm run test:all` | Run all screenshot tests |
| `npm run start:web` | Start Flutter web app for testing |
| `npm run clean` | Clean up screenshots and reports |

## 🔧 Configuration

### screenshot_config.json

```json
{
  "web": {
    "port": 8080,
    "headless": true,
    "viewport": { "width": 1920, "height": 1080 },
    "timeout": 30000
  },
  "android": {
    "device": "auto",
    "timeout": 60000
  },
  "integration": {
    "timeout": 120000,
    "platforms": ["android", "ios", "web"]
  },
  "output": {
    "screenshotDir": "./screenshots",
    "reportDir": "./reports",
    "format": "png"
  },
  "comparison": {
    "threshold": 0.1,
    "includeAA": false
  }
}
```

## 🎬 Test Scenarios

### Customizing Test Flows

Edit the test scenarios in each script to match your app's navigation:

#### Web Testing (automated_screenshots.js)
```javascript
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
      selector: '[data-testid="menu-button"]',
      screenshotOptions: { fullPage: true }
    }
    // Add more actions...
  ]
};
```

#### Android Testing (screenshot_test.dart)
```dart
final androidTestScenario = [
  {
    'name': 'home-screen',
    'description': 'Initial home screen',
    'action': 'wait',
  },
  {
    'name': 'dancers-tab',
    'description': 'Dancers tab selected',
    'action': 'tap',
    'finder': 'dancers-tab',
  }
  // Add more steps...
];
```

#### Integration Testing (screenshot_integration_test.dart)
```dart
final scenario = [
  {
    'name': 'home-screen',
    'description': 'Initial home screen of the app',
    'action': 'wait',
  },
  {
    'name': 'add-dancer-form',
    'description': 'Add dancer form opened',
    'action': 'tap',
    'finder': 'add-dancer-button',
  }
  // Add more scenarios...
];
```

## 📊 Understanding Reports

### HTML Reports

Each testing method generates detailed HTML reports with:

- **Summary Statistics**: Number of screenshots, success/failure rates
- **Visual Gallery**: Grid view of all captured screenshots
- **Test Details**: Timestamps, descriptions, and metadata
- **Comparison Results**: Baseline vs current screenshot comparisons
- **Device Information**: Platform details and configurations

### Accessing Reports

Reports are generated in the `reports/` directory:
- `reports/web/` - Web automation reports
- `reports/android/` - Android testing reports  
- `reports/integration/` - Integration test reports
- `reports/consolidated-report-*.html` - Combined reports

## 🔍 Screenshot Types

### 1. Web Screenshots (Puppeteer)
- **Full page screenshots** of Flutter web app
- **Element-specific screenshots** 
- **Mobile viewport simulation**
- **Custom device dimensions**

### 2. Android Screenshots (Flutter Driver + ADB)
- **App-level screenshots** using Flutter Driver
- **Device-level screenshots** using ADB
- **Multiple device support**
- **Automatic device detection**

### 3. Integration Screenshots
- **Cross-platform compatibility**
- **Built-in Flutter framework**
- **Dark/light theme support**
- **Tablet/mobile layout testing**

## 🔄 Baseline Comparison

### Setting Up Baselines

1. **First Run**: Initial screenshots become baselines
2. **Subsequent Runs**: Compare against baselines
3. **Update Baselines**: Copy new screenshots to baseline folder when changes are intentional

### Comparison Process

```bash
# Screenshots are automatically compared
# Differences are highlighted in reports
# New baselines are created for new tests
```

### Managing Baselines

```bash
# Update all baselines with current screenshots
cp screenshots/web/* screenshots/baseline/
cp screenshots/android/* screenshots/baseline/
cp screenshots/integration/* screenshots/baseline/
```

## 🚀 Advanced Usage

### Custom Actions

Add custom actions to test scenarios:

```javascript
// Web testing custom action
{
  name: 'form-interaction',
  type: 'custom',
  execute: async (page) => {
    await page.type('#input-field', 'Test data');
    await page.click('#submit-button');
    await page.waitForSelector('#success-message');
  }
}
```

### Multiple Devices

Configure multiple device testing:

```json
{
  "devices": [
    {
      "name": "mobile",
      "viewport": { "width": 375, "height": 667 }
    },
    {
      "name": "tablet", 
      "viewport": { "width": 768, "height": 1024 }
    },
    {
      "name": "desktop",
      "viewport": { "width": 1920, "height": 1080 }
    }
  ]
}
```

### CI/CD Integration

#### GitHub Actions
```yaml
name: Screenshot Tests
on: [push, pull_request]
jobs:
  screenshots:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-node@v2
        with:
          node-version: '16'
      - uses: subosito/flutter-action@v2
      - run: ./scripts/setup.sh
      - run: npm run test:all
      - uses: actions/upload-artifact@v2
        with:
          name: screenshot-reports
          path: reports/
```

#### GitLab CI
```yaml
screenshot_tests:
  stage: test
  script:
    - ./scripts/setup.sh
    - npm run test:all
  artifacts:
    paths:
      - reports/
      - screenshots/
```

## 🐛 Troubleshooting

### Common Issues

#### 1. Chrome/Puppeteer Issues
```bash
# Install Chrome dependencies
sudo apt-get install -y gconf-service libasound2 libatk1.0-0 libcairo2 libcups2 libfontconfig1 libgbm1 libgdk-pixbuf2.0-0 libgtk-3-0 libicu-dev libjpeg-dev libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libpng-dev libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6
```

#### 2. Android Device Not Detected
```bash
# Check ADB connection
adb devices

# Restart ADB
adb kill-server
adb start-server
```

#### 3. Flutter Web Not Starting
```bash
# Check Flutter web support
flutter config --enable-web
flutter devices

# Clear Flutter cache
flutter clean
flutter pub get
```

#### 4. Permission Issues
```bash
# Make scripts executable
chmod +x scripts/*.sh

# Fix Node.js permissions
sudo chown -R $(whoami) ~/.npm
```

### Debug Mode

Run with debug output:

```bash
DEBUG=1 node scripts/screenshot_orchestrator.js --mode web
```

## 📈 Performance Tips

1. **Parallel Testing**: Run different test types simultaneously
2. **Selective Testing**: Use specific modes for faster feedback
3. **Screenshot Optimization**: Adjust viewport sizes for faster capture
4. **Timeout Configuration**: Increase timeouts for slow devices
5. **Cleanup**: Regularly clean old screenshots and reports

## 🔒 Security Considerations

- Screenshots may contain sensitive data
- Use `.gitignore` to exclude screenshots from version control
- Consider encryption for CI/CD artifact storage
- Sanitize test data to avoid exposing real user information

## 🤝 Contributing

### Adding New Test Types

1. Create new script in `scripts/` directory
2. Add configuration to `screenshot_config.json`
3. Update orchestrator to include new test type
4. Add documentation and examples

### Extending Reports

1. Modify report generation functions
2. Add new metadata fields
3. Update HTML templates
4. Test with various screenshot counts

## 📚 Examples

### Basic Flutter App Testing

```bash
# Complete testing workflow
./scripts/setup.sh
npm run test:all
open reports/consolidated-report-*.html
```

### Custom Test Scenario

```javascript
// Create custom test in scripts/custom_test.js
const customScenario = {
  name: 'Custom User Journey',
  actions: [
    { name: 'login', type: 'click', selector: '#login-btn' },
    { name: 'dashboard', type: 'wait', duration: 3000 },
    { name: 'profile', type: 'click', selector: '#profile-link' }
  ]
};
```

## 📞 Support

For issues and questions:

1. Check the troubleshooting section
2. Review generated error logs in `reports/`
3. Verify all dependencies are installed
4. Test with minimal example first

## 📄 License

This automated screenshot testing system is part of your Flutter project and follows the same license terms.

---

**🎉 Happy Testing!** 

Your Flutter app now has comprehensive automated screenshot testing capabilities. The system will help you catch visual regressions early and maintain UI consistency across platforms and updates.