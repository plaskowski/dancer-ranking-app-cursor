# 💃 Dancer Ranking App

A social dancer's companion app for planning and tracking dance events.

## 🎯 Problem Statement

Social dancers often face overwhelming decision-making at parties with many potential partners. This app helps solve the challenge of:
- Who to prioritize for dances
- Remembering who is present at events
- Tracking dance experiences and impressions
- Planning ahead based on past experiences

## ✨ Features

- **Pre-event Planning**: Set initial rankings and eagerness levels
- **Real-time Tracking**: Mark attendance and adjust rankings during events
- **Dance Recording**: Capture impressions after each dance
- **Dynamic Rankings**: Adjust priorities based on current situation
- **Quick Dancer Addition**: Add new people met at events

## 🏗️ Architecture

### Framework & Libraries
- **Flutter** - Android mobile development (with macOS support)
- **Drift** - Type-safe SQLite ORM for data persistence
- **Provider** - State management
- **Material Design** - UI components

### Database Design
- **Events** - Dance events with name and date
- **Dancers** - Master list of dance partners
- **Ranks** - Predefined eagerness levels (1-5)
- **Rankings** - Event-specific dancer rankings with reasons
- **Attendances** - Tracks presence and dance completion

### Key Dependencies
```yaml
dependencies:
  drift: ^2.14.1           # Database ORM
  sqlite3_flutter_libs: ^0.5.15  # SQLite support
  provider: ^6.1.1         # State management
  flutter_datetime_picker: ^1.5.1  # Date/time selection
  intl: ^0.18.1           # Internationalization
  
dev_dependencies:
  drift_dev: ^2.14.1      # Code generation
  build_runner: ^2.4.7    # Build system
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (tested with 3.8+)
- Android Studio or VS Code
- Android device/emulator (primary target)
- macOS for development and testing
- Android SDK and tools

### Setup
```bash
# Install dependencies
flutter pub get

# Generate database code (when ready)
flutter packages pub run build_runner build

# Run the app
flutter run
```

### Project Structure
```
lib/
├── main.dart              # App entry point
├── database/              # Drift database setup
├── models/                # Data models
├── services/              # Business logic
├── screens/               # UI screens
└── widgets/               # Reusable UI components
```

## 📱 Screens

1. **Home Screen** - Event list
2. **Create Event Screen** - New event form
3. **Event Screen** - Main interface with Planning/Present tabs
4. **Dancers Screen** - Master dancer management
5. **Dialogs** - Ranking, dance recording, dancer addition

## 🎨 UI Design

- Clean Material Design interface
- Two-tab event management (Planning/Present)
- Tap-to-action pattern (no button clutter)
- FAB for quick additions
- Rank-based grouping for easy prioritization

## 📊 Default Ranks

1. **Really want to dance!** (Ordinal 1 - Best)
2. **Would like to dance** (Ordinal 2)
3. **Neutral / Default** (Ordinal 3)
4. **Maybe later** (Ordinal 4)
5. **Not really interested** (Ordinal 5 - Lowest)

## 🔄 Workflow

1. **Pre-event**: Create event, add/rank expected dancers
2. **At event**: Switch to Present tab, mark attendance
3. **During event**: Adjust rankings, record dances
4. **New people**: Quick add with optional "already danced"
5. **Post-dance**: Record impressions and experiences

## 🛠️ Development

### Code Guidelines
- Each component class in separate file
- Use Provider for state management
- Follow Material Design patterns
- Type-safe database operations with Drift

### Database Generation
After modifying database models:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 📄 License

Private project - not for public distribution.

---

**Built with Flutter 💙**
