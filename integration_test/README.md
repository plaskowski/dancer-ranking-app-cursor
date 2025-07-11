# Integration Tests for Dancer Ranking App

This directory contains integration tests for the Dancer Ranking App. Integration tests verify that the app works correctly as a whole, testing user workflows and interactions across multiple screens.

## Test Structure

### `app_test.dart`
Basic app functionality tests including:
- App launch and home screen display
- Navigation between tabs (Events, Dancers, Settings)
- Event creation flow
- Event screen navigation
- Tab navigation within events

### `dancer_management_test.dart`
Dancer-specific functionality tests including:
- Adding dancers to events
- Ranking dancers
- Dancer filtering and search
- Settings navigation

### `import_functionality_test.dart`
Import feature tests including:
- Import dancers dialog
- Import events dialog
- Import rankings dialog
- File picker integration

## Running Integration Tests

### Prerequisites
1. Flutter SDK installed
2. A connected device or emulator
3. Dependencies installed: `flutter pub get`

### Running Tests

#### Using the test runner script:
```bash
./integration_test/run_integration_tests.sh
```

#### Using Flutter directly:
```bash
# Run all integration tests
flutter test integration_test/

# Run a specific test file
flutter test integration_test/app_test.dart

# Run with verbose output
flutter test integration_test/ --verbose
```

### Running on Specific Platforms

#### Android:
```bash
flutter test integration_test/ -d android
```

#### macOS:
```bash
flutter test integration_test/ -d macos
```

## Test Guidelines

### Writing New Tests
1. **Use descriptive test names** that explain what functionality is being tested
2. **Group related tests** using `group()` blocks
3. **Test user workflows** rather than individual components
4. **Use `pumpAndSettle()`** after user interactions to wait for animations
5. **Verify expected UI elements** appear after actions

### Best Practices
- **Start fresh**: Each test should start with `app.main()` to ensure a clean state
- **Wait for animations**: Use `pumpAndSettle()` after taps and text entry
- **Verify results**: Always verify that expected UI elements appear after actions
- **Handle platform differences**: Some UI elements may vary between platforms
- **Test error scenarios**: Include tests for error handling and edge cases

### Common Patterns

#### Testing Navigation:
```dart
await tester.tap(find.text('Button Text'));
await tester.pumpAndSettle();
expect(find.text('Expected Screen Title'), findsOneWidget);
```

#### Testing Text Entry:
```dart
await tester.enterText(find.byType(TextFormField), 'Test Input');
await tester.pumpAndSettle();
```

#### Testing Dialog Interactions:
```dart
await tester.tap(find.text('Open Dialog'));
await tester.pumpAndSettle();
expect(find.text('Dialog Title'), findsOneWidget);
await tester.tap(find.text('Confirm'));
await tester.pumpAndSettle();
```

## Troubleshooting

### Common Issues

1. **Tests fail on different platforms**: UI elements may have different text or structure
2. **Timing issues**: Use `pumpAndSettle()` to wait for animations
3. **Device not found**: Ensure a device is connected with `flutter devices`
4. **Build errors**: Run `flutter clean` and `flutter pub get` before testing

### Debugging
- Use `--verbose` flag for detailed output
- Add `print()` statements in tests for debugging
- Use `tester.binding.addTime(Duration(seconds: 5))` to slow down tests

## Continuous Integration

Integration tests can be run in CI/CD pipelines. Ensure the CI environment has:
- Flutter SDK installed
- A headless device or emulator available
- Proper permissions for file system access

Example CI configuration:
```yaml
- name: Run Integration Tests
  run: |
    flutter test integration_test/ --coverage
``` 