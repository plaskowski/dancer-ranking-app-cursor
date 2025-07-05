import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as path;

// Import your main app
import '../lib/main.dart' as app;

class IntegrationScreenshotBot {
  final IntegrationTestWidgetsFlutterBinding binding;
  final String screenshotDir = './screenshots/integration';
  final String reportDir = './reports/integration';
  final List<Map<String, dynamic>> capturedScreenshots = [];
  
  IntegrationScreenshotBot(this.binding);

  Future<void> initialize() async {
    print('🚀 Initializing Integration Screenshot Bot...');
    
    // Create directories
    await Directory(screenshotDir).create(recursive: true);
    await Directory(reportDir).create(recursive: true);
    
    // Configure for Android screenshots
    if (Platform.isAndroid) {
      await binding.convertFlutterSurfaceToImage();
    }
    
    print('✅ Integration Screenshot Bot initialized');
  }

  Future<String> takeScreenshot(WidgetTester tester, String name, {String? description}) async {
    final timestamp = DateTime.now().toIso8601String().replaceAll(RegExp(r'[:.+]'), '-');
    final filename = '${name}_$timestamp.png';
    final filepath = path.join(screenshotDir, filename);
    
    print('📸 Taking integration screenshot: $filename');
    
    // Wait for animations to complete
    await tester.pumpAndSettle(Duration(seconds: 2));
    
    // Take screenshot
    await binding.takeScreenshot(name);
    
    // The screenshot is saved automatically by the integration test framework
    // We'll track it in our report
    final screenshotData = {
      'name': name,
      'description': description ?? '',
      'timestamp': DateTime.now().toIso8601String(),
      'filename': filename,
      'path': filepath,
    };
    
    capturedScreenshots.add(screenshotData);
    
    print('✅ Screenshot captured: $name');
    return filepath;
  }

  Future<void> performAction(WidgetTester tester, String action, {String? finder, String? text}) async {
    print('🎯 Performing action: $action');
    
    switch (action) {
      case 'tap':
        if (finder != null) {
          await tester.tap(find.byKey(Key(finder)));
          await tester.pumpAndSettle();
        }
        break;
      case 'scroll':
        await tester.drag(find.byKey(Key('main-scroll')), Offset(0, -300));
        await tester.pumpAndSettle();
        break;
      case 'enterText':
        if (finder != null && text != null) {
          await tester.tap(find.byKey(Key(finder)));
          await tester.enterText(find.byKey(Key(finder)), text);
          await tester.pumpAndSettle();
        }
        break;
      case 'wait':
        await tester.pump(Duration(seconds: 2));
        break;
      case 'back':
        // Simulate back button press
        await tester.binding.defaultBinaryMessenger.send(
          'flutter/navigation', 
          const StandardMethodCodec().encodeMethodCall(
            const MethodCall('routePopped'),
          ),
        );
        await tester.pumpAndSettle();
        break;
    }
    
    // Additional wait for animations
    await tester.pump(Duration(milliseconds: 500));
  }

  Future<void> runTestScenario(WidgetTester tester, List<Map<String, dynamic>> scenario) async {
    print('🎬 Running integration test scenario with ${scenario.length} steps...');
    
    for (int i = 0; i < scenario.length; i++) {
      final step = scenario[i];
      print('📍 Step ${i + 1}/${scenario.length}: ${step['name']}');
      
      // Perform action if specified
      if (step['action'] != null) {
        await performAction(
          tester,
          step['action'],
          finder: step['finder'],
          text: step['text'],
        );
      }
      
      // Take screenshot
      await takeScreenshot(
        tester,
        step['name'],
        description: step['description'],
      );
      
      // Additional wait if specified
      if (step['wait'] != null) {
        await tester.pump(Duration(milliseconds: step['wait']));
      }
    }
    
    print('✅ Integration test scenario completed');
  }

  Future<void> generateReport() async {
    print('📊 Generating integration test report...');
    
    final report = {
      'timestamp': DateTime.now().toIso8601String(),
      'platform': Platform.isAndroid ? 'android' : (Platform.isIOS ? 'ios' : 'web'),
      'testType': 'integration_test',
      'totalScreenshots': capturedScreenshots.length,
      'screenshots': capturedScreenshots,
    };
    
    // Generate HTML report
    final htmlContent = _generateHtmlReport(report);
    final htmlFile = File(path.join(reportDir, 'integration-report-${DateTime.now().toIso8601String().replaceAll(RegExp(r'[:.+]'), '-')}.html'));
    await htmlFile.writeAsString(htmlContent);
    
    // Generate JSON report
    final jsonFile = File(path.join(reportDir, 'integration-report-${DateTime.now().toIso8601String().replaceAll(RegExp(r'[:.+]'), '-')}.json'));
    await jsonFile.writeAsString(report.toString());
    
    print('📊 Integration test report generated: ${htmlFile.path}');
  }

  String _generateHtmlReport(Map<String, dynamic> report) {
    return '''
<!DOCTYPE html>
<html>
<head>
    <title>Integration Test Screenshot Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: #e3f2fd; padding: 20px; border-radius: 8px; }
        .summary { display: flex; gap: 20px; margin: 20px 0; }
        .summary-item { background: #f3e5f5; padding: 15px; border-radius: 8px; text-align: center; }
        .screenshots { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
        .screenshot-item { border: 1px solid #ddd; border-radius: 8px; padding: 15px; }
        .screenshot-item img { max-width: 100%; height: auto; border-radius: 4px; }
        .test-info { background: #f5f5f5; padding: 15px; border-radius: 8px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🧪 Integration Test Screenshot Report</h1>
        <p><strong>Generated:</strong> ${report['timestamp']}</p>
    </div>
    
    <div class="summary">
        <div class="summary-item">
            <h3>${report['totalScreenshots']}</h3>
            <p>Screenshots Captured</p>
        </div>
        <div class="summary-item">
            <h3>${report['platform']}</h3>
            <p>Platform</p>
        </div>
        <div class="summary-item">
            <h3>${report['testType']}</h3>
            <p>Test Type</p>
        </div>
    </div>
    
    <div class="test-info">
        <h3>🧪 Test Information</h3>
        <p><strong>Platform:</strong> ${report['platform']}</p>
        <p><strong>Test Type:</strong> Flutter Integration Test</p>
        <p><strong>Screenshot Method:</strong> integration_test package</p>
        <p><strong>Total Screenshots:</strong> ${report['totalScreenshots']}</p>
    </div>
    
    <h2>📸 Screenshots</h2>
    <div class="screenshots">
        ${(report['screenshots'] as List).map((screenshot) => '''
            <div class="screenshot-item">
                <h3>${screenshot['name']}</h3>
                <p>${screenshot['description']}</p>
                <p><strong>Filename:</strong> ${screenshot['filename']}</p>
                <p><small>Captured: ${screenshot['timestamp']}</small></p>
            </div>
        ''').join('')}
    </div>
    
    <h2>📋 Test Summary</h2>
    <div style="background: #f5f5f5; padding: 15px; border-radius: 8px;">
        <h3>Integration Test Results:</h3>
        <ul>
            <li><strong>Total Screenshots:</strong> ${report['totalScreenshots']}</li>
            <li><strong>Test Framework:</strong> Flutter Integration Test</li>
            <li><strong>Platform:</strong> ${report['platform']}</li>
            <li><strong>Screenshot Location:</strong> ./screenshots/integration/</li>
        </ul>
        
        <h3>Next Steps:</h3>
        <ul>
            <li>Review screenshots in the screenshots directory</li>
            <li>Compare with previous runs for visual regression testing</li>
            <li>Update test scenarios as needed</li>
        </ul>
    </div>
</body>
</html>
    ''';
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late IntegrationScreenshotBot bot;

  group('Flutter App Screenshot Tests', () {
    setUpAll(() async {
      bot = IntegrationScreenshotBot(binding);
      await bot.initialize();
    });

    testWidgets('Full App Screenshot Flow', (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Define test scenario
      final scenario = [
        {
          'name': 'home-screen',
          'description': 'Initial home screen of the app',
          'action': 'wait',
        },
        {
          'name': 'navigation-menu',
          'description': 'Navigation menu interaction',
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

      // Run the test scenario
      await bot.runTestScenario(tester, scenario);
      
      // Generate report
      await bot.generateReport();
      
      print('\n🎉 Integration test screenshot flow completed successfully!');
    });

    testWidgets('Dark Theme Screenshot Flow', (WidgetTester tester) async {
      // Start the app with dark theme
      app.main();
      await tester.pumpAndSettle();

      // Take screenshots in dark mode
      await bot.takeScreenshot(tester, 'dark-theme-home', description: 'Home screen in dark theme');
      
      // You can add more dark theme specific tests here
    });

    testWidgets('Tablet Layout Screenshot Flow', (WidgetTester tester) async {
      // Configure for tablet layout
      tester.binding.window.physicalSizeTestValue = Size(1024, 768);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      await bot.takeScreenshot(tester, 'tablet-layout-home', description: 'Home screen in tablet layout');
      
      // Reset to default
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
  });
}