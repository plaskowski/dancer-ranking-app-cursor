# 🚀 Quick Start: Automated Screenshot Testing

## 30-Second Setup

```bash
# 1. Make setup script executable and run it
chmod +x scripts/setup.sh && ./scripts/setup.sh

# 2. Run interactive screenshot testing
node scripts/screenshot_orchestrator.js --interactive
```

## What You Get

✅ **Automated Flutter Web Screenshots** - Using Puppeteer  
✅ **Android App Screenshots** - Using Flutter Driver + ADB  
✅ **Integration Test Screenshots** - Using Flutter's built-in testing  
✅ **Detailed HTML Reports** - With visual comparisons  
✅ **Baseline Comparison** - Automatic visual regression detection  

## Quick Commands

| Want to... | Run this command |
|------------|------------------|
| **Test everything** | `npm run test:all` |
| **Web screenshots only** | `npm run test:web` |
| **Android screenshots only** | `npm run test:android` |
| **Integration tests only** | `npm run test:integration` |
| **Interactive mode** | `node scripts/screenshot_orchestrator.js --interactive` |
| **View reports** | `open reports/consolidated-report-*.html` |

## Your Files

The system created these key files:

```
📁 Your Project/
├── 🎯 package.json                              # Node.js config
├── 🔧 screenshot_config.json                    # Settings
├── 📚 AUTOMATED_SCREENSHOTS_README.md           # Full docs
├── 🚀 scripts/setup.sh                          # Setup script
├── 🌐 scripts/automated_screenshots.js          # Web automation
├── 🤖 test_driver/screenshot_test.dart           # Android tests
├── 🧪 integration_test/screenshot_integration_test.dart  # Integration tests
└── 📊 screenshots/ & reports/                   # Output folders
```

## Next Steps

1. **Customize test scenarios** in the script files to match your app
2. **Run tests** to generate baseline screenshots
3. **Make UI changes** and re-run to detect visual regressions
4. **View HTML reports** to see before/after comparisons

## Need Help?

- 📖 **Full Documentation**: `AUTOMATED_SCREENSHOTS_README.md`
- 🐛 **Troubleshooting**: Check the troubleshooting section in the README
- 🔧 **Configuration**: Edit `screenshot_config.json`

**Happy automated testing! 🎉**