import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:path/path.dart' as path;

class AndroidScreenshotBot {
  late FlutterDriver driver;
  final String screenshotDir = './screenshots/android';
  final String reportDir = './reports/android';
  final List<Map<String, dynamic>> capturedScreenshots = [];
  
  AndroidScreenshotBot();

  Future<void> initialize() async {
    print('🚀 Initializing Android Screenshot Bot...');
    
    // Create directories
    await Directory(screenshotDir).create(recursive: true);
    await Directory(reportDir).create(recursive: true);
    
    // Connect to Flutter driver
    driver = await FlutterDriver.connect();
    await driver.waitUntilFirstFrameRasterized();
    
    print('✅ Android Screenshot Bot initialized');
  }

  Future<String> takeScreenshot(String name, {String? description}) async {
    final timestamp = DateTime.now().toIso8601String().replaceAll(RegExp(r'[:.+]'), '-');
    final filename = '${name}_$timestamp.png';
    final filepath = path.join(screenshotDir, filename);
    
    print('📸 Taking Android screenshot: $filename');
    
    // Take screenshot using Flutter driver
    final Uint8List screenshot = await driver.screenshot();
    
    // Save screenshot
    final file = File(filepath);
    await file.writeAsBytes(screenshot);
    
    // Also capture device screenshot using ADB for full device view
    final deviceScreenshotPath = await _captureDeviceScreenshot(name, timestamp);
    
    final screenshotData = {
      'name': name,
      'description': description ?? '',
      'timestamp': DateTime.now().toIso8601String(),
      'appScreenshot': filepath,
      'deviceScreenshot': deviceScreenshotPath,
      'filename': filename,
    };
    
    capturedScreenshots.add(screenshotData);
    
    print('✅ Screenshot saved: $filepath');
    return filepath;
  }

  Future<String?> _captureDeviceScreenshot(String name, String timestamp) async {
    try {
      final deviceFilename = '${name}_device_$timestamp.png';
      final deviceFilepath = path.join(screenshotDir, deviceFilename);
      
      // Use ADB to capture device screenshot
      final result = await Process.run('adb', [
        'exec-out',
        'screencap',
        '-p'
      ]);
      
      if (result.exitCode == 0) {
        final file = File(deviceFilepath);
        await file.writeAsBytes(result.stdout);
        print('✅ Device screenshot saved: $deviceFilepath');
        return deviceFilepath;
      } else {
        print('⚠️  Failed to capture device screenshot: ${result.stderr}');
        return null;
      }
    } catch (e) {
      print('⚠️  Error capturing device screenshot: $e');
      return null;
    }
  }

  Future<void> performAction(String action, {String? finder, String? text}) async {
    print('🎯 Performing action: $action');
    
    switch (action) {
      case 'tap':
        if (finder != null) {
          await driver.tap(find.byValueKey(finder));
        }
        break;
      case 'scroll':
        await driver.scroll(find.byValueKey('main-scroll'), 0, -300, Duration(milliseconds: 300));
        break;
      case 'enterText':
        if (finder != null && text != null) {
          await driver.tap(find.byValueKey(finder));
          await driver.enterText(text);
        }
        break;
      case 'wait':
        await Future.delayed(Duration(seconds: 2));
        break;
      case 'back':
        await driver.tap(find.pageBack());
        break;
    }
    
    // Wait for animations to complete
    await Future.delayed(Duration(milliseconds: 1000));
  }

  Future<void> runTestScenario(List<Map<String, dynamic>> scenario) async {
    print('🎬 Running test scenario with ${scenario.length} steps...');
    
    for (int i = 0; i < scenario.length; i++) {
      final step = scenario[i];
      print('📍 Step ${i + 1}/${scenario.length}: ${step['name']}');
      
      // Perform action if specified
      if (step['action'] != null) {
        await performAction(
          step['action'],
          finder: step['finder'],
          text: step['text'],
        );
      }
      
      // Take screenshot
      await takeScreenshot(
        step['name'],
        description: step['description'],
      );
      
      // Additional wait if specified
      if (step['wait'] != null) {
        await Future.delayed(Duration(milliseconds: step['wait']));
      }
    }
    
    print('✅ Test scenario completed');
  }

  Future<void> generateReport() async {
    print('📊 Generating Android screenshot report...');
    
    final report = {
      'timestamp': DateTime.now().toIso8601String(),
      'platform': 'android',
      'totalScreenshots': capturedScreenshots.length,
      'screenshots': capturedScreenshots,
      'deviceInfo': await _getDeviceInfo(),
    };
    
    // Generate HTML report
    final htmlContent = _generateHtmlReport(report);
    final htmlFile = File(path.join(reportDir, 'android-report-${DateTime.now().toIso8601String().replaceAll(RegExp(r'[:.+]'), '-')}.html'));
    await htmlFile.writeAsString(htmlContent);
    
    // Generate JSON report
    final jsonFile = File(path.join(reportDir, 'android-report-${DateTime.now().toIso8601String().replaceAll(RegExp(r'[:.+]'), '-')}.json'));
    await jsonFile.writeAsString(report.toString());
    
    print('📊 Android report generated: ${htmlFile.path}');
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    try {
      final deviceName = await Process.run('adb', ['shell', 'getprop', 'ro.product.model']);
      final androidVersion = await Process.run('adb', ['shell', 'getprop', 'ro.build.version.release']);
      final resolution = await Process.run('adb', ['shell', 'wm', 'size']);
      
      return {
        'deviceName': deviceName.stdout.toString().trim(),
        'androidVersion': androidVersion.stdout.toString().trim(),
        'resolution': resolution.stdout.toString().trim(),
      };
    } catch (e) {
      return {'error': 'Failed to get device info: $e'};
    }
  }

  String _generateHtmlReport(Map<String, dynamic> report) {
    return '''
<!DOCTYPE html>
<html>
<head>
    <title>Android Screenshot Test Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: #e8f5e8; padding: 20px; border-radius: 8px; }
        .summary { display: flex; gap: 20px; margin: 20px 0; }
        .summary-item { background: #f0f8ff; padding: 15px; border-radius: 8px; text-align: center; }
        .screenshots { display: grid; grid-template-columns: repeat(auto-fit, minmax(400px, 1fr)); gap: 20px; }
        .screenshot-item { border: 1px solid #ddd; border-radius: 8px; padding: 15px; }
        .screenshot-comparison { display: flex; gap: 10px; }
        .screenshot-comparison img { max-width: 45%; height: auto; border-radius: 4px; }
        .device-info { background: #f5f5f5; padding: 15px; border-radius: 8px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="header">
        <h1>📱 Android Screenshot Test Report</h1>
        <p><strong>Generated:</strong> ${report['timestamp']}</p>
    </div>
    
    <div class="summary">
        <div class="summary-item">
            <h3>${report['totalScreenshots']}</h3>
            <p>Screenshots Captured</p>
        </div>
        <div class="summary-item">
            <h3>Android</h3>
            <p>Platform</p>
        </div>
    </div>
    
    <div class="device-info">
        <h3>📱 Device Information</h3>
        <p><strong>Device:</strong> ${report['deviceInfo']['deviceName'] ?? 'Unknown'}</p>
        <p><strong>Android Version:</strong> ${report['deviceInfo']['androidVersion'] ?? 'Unknown'}</p>
        <p><strong>Resolution:</strong> ${report['deviceInfo']['resolution'] ?? 'Unknown'}</p>
    </div>
    
    <h2>📸 Screenshots</h2>
    <div class="screenshots">
        ${(report['screenshots'] as List).map((screenshot) => '''
            <div class="screenshot-item">
                <h3>${screenshot['name']}</h3>
                <p>${screenshot['description']}</p>
                <div class="screenshot-comparison">
                    <div>
                        <h4>App Screenshot</h4>
                        <img src="${screenshot['appScreenshot']}" alt="${screenshot['name']} - App">
                    </div>
                    ${screenshot['deviceScreenshot'] != null ? '''
                    <div>
                        <h4>Device Screenshot</h4>
                        <img src="${screenshot['deviceScreenshot']}" alt="${screenshot['name']} - Device">
                    </div>
                    ''' : ''}
                </div>
                <p><small>Captured: ${screenshot['timestamp']}</small></p>
            </div>
        ''').join('')}
    </div>
    
    <h2>📋 Test Summary</h2>
    <div style="background: #f5f5f5; padding: 15px; border-radius: 8px;">
        <h3>Visual Testing Results:</h3>
        <ul>
            <li><strong>Total Screenshots:</strong> ${report['totalScreenshots']}</li>
            <li><strong>App Screenshots:</strong> Captured using Flutter Driver</li>
            <li><strong>Device Screenshots:</strong> Captured using ADB</li>
            <li><strong>Platform:</strong> Android</li>
        </ul>
    </div>
</body>
</html>
    ''';
  }

  Future<void> cleanup() async {
    print('🧹 Cleaning up Android Screenshot Bot...');
    await driver.close();
    print('✅ Cleanup completed');
  }
}

// Test scenario definition
final androidTestScenario = [
  {
    'name': 'home-screen',
    'description': 'Initial home screen',
    'action': 'wait',
  },
  {
    'name': 'navigation-drawer',
    'description': 'Navigation drawer opened',
    'action': 'tap',
    'finder': 'menu-button',
  },
  {
    'name': 'dancers-tab',
    'description': 'Dancers tab selected',
    'action': 'tap',
    'finder': 'dancers-tab',
  },
  {
    'name': 'add-dancer-form',
    'description': 'Add dancer form opened',
    'action': 'tap',
    'finder': 'add-dancer-button',
  },
  {
    'name': 'dancer-form-filled',
    'description': 'Dancer form with sample data',
    'action': 'enterText',
    'finder': 'dancer-name-field',
    'text': 'Test Dancer',
  },
  {
    'name': 'events-tab',
    'description': 'Events tab selected',
    'action': 'tap',
    'finder': 'events-tab',
  },
  {
    'name': 'add-event-form',
    'description': 'Add event form opened',
    'action': 'tap',
    'finder': 'add-event-button',
  },
];

// Main execution
void main() async {
  final bot = AndroidScreenshotBot();
  
  try {
    await bot.initialize();
    await bot.runTestScenario(androidTestScenario);
    await bot.generateReport();
    
    print('\n🎉 Android screenshot testing completed successfully!');
    
  } catch (e) {
    print('❌ Android screenshot testing failed: $e');
    exit(1);
  } finally {
    await bot.cleanup();
  }
}