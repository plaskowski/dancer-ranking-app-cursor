
History:
- ✅ can I mark the ranked absent dancer as present and danced with at the same time?
  → Added "Mark Present & Record Dance" combo action for absent dancers in Present tab
- ✅ when I mark the dancer as absent in planning tab the list does not get refreshed
  → **MAJOR IMPROVEMENT**: Converted to reactive streams architecture with Drift database observation
  → Replaced manual callback chains with StreamBuilder + watchDancersForEvent()
  → UI now automatically refreshes for ALL data changes (notes, rankings, attendance, etc.)
- ✅ Introduce Theme System based on Material 3
  → **COMPREHENSIVE THEME SYSTEM**: Implemented complete Material 3 theme with custom extensions
  → Created theme foundation with proper color schemes (light/dark), semantic colors, and dance-specific extensions
  → Theme files: `app_theme.dart`, `color_schemes.dart`, `theme_extensions.dart`

Next step:
- Continue migrating hardcoded colors throughout the app to use the new theme system
