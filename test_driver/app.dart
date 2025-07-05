import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_driver/driver_registry.dart';

// Import your main app
import '../lib/main.dart' as app;

void main() {
  // Enable Flutter driver extension
  enableFlutterDriverExtension(
    handler: (String? message) async {
      // Handle custom commands from the driver
      if (message == 'get_app_state') {
        return 'app_ready';
      }
      return null;
    },
  );

  // Add custom commands for screenshot testing
  driverRegistry['takeScreenshot'] = (command) async {
    // Custom screenshot logic can be added here
    return 'screenshot_taken';
  };

  // Run the main app
  runApp(ScreenshotTestApp());
}

class ScreenshotTestApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Screenshot Test App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ScreenshotTestWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ScreenshotTestWrapper extends StatefulWidget {
  @override
  _ScreenshotTestWrapperState createState() => _ScreenshotTestWrapperState();
}

class _ScreenshotTestWrapperState extends State<ScreenshotTestWrapper> {
  @override
  void initState() {
    super.initState();
    // Initialize any test data or mocks here
    _initializeTestData();
  }

  void _initializeTestData() {
    // Add test data initialization here
    // This is where you would set up mock data for consistent screenshots
  }

  @override
  Widget build(BuildContext context) {
    // Return your main app widget here
    // For now, using a placeholder - you should replace this with your actual app
    return Scaffold(
      key: Key('main-scaffold'),
      appBar: AppBar(
        title: Text('Dancer Ranking App'),
        leading: IconButton(
          key: Key('menu-button'),
          icon: Icon(Icons.menu),
          onPressed: () {
            // Handle menu tap
          },
        ),
      ),
      body: Column(
        key: Key('main-scroll'),
        children: [
          _buildTabBar(),
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        key: Key('add-dancer-button'),
        onPressed: () {
          // Handle add dancer
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTabItem('dancers-tab', 'Dancers', Icons.people),
          _buildTabItem('events-tab', 'Events', Icons.event),
          _buildTabItem('rankings-tab', 'Rankings', Icons.emoji_events),
        ],
      ),
    );
  }

  Widget _buildTabItem(String key, String title, IconData icon) {
    return Expanded(
      child: InkWell(
        key: Key(key),
        onTap: () {
          // Handle tab selection
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Welcome to Dancer Ranking App',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            'Use the tabs above to navigate between sections',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 40),
          _buildSampleForm(),
        ],
      ),
    );
  }

  Widget _buildSampleForm() {
    return Card(
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              key: Key('dancer-name-field'),
              decoration: InputDecoration(
                labelText: 'Dancer Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              key: Key('event-name-field'),
              decoration: InputDecoration(
                labelText: 'Event Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              key: Key('add-event-button'),
              onPressed: () {
                // Handle add event
              },
              child: Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }
}