
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
- ✅ Migrated all hardcoded colors to theme system

Next step:
- write a Cursor rule to stop using "const" expression to avoid back and forth changes
- fix the Cursor config so that it can run flutter analyze without waiting for approval
- write a Cursor rule to not make changes that are unrelated to current task
- setup a strict Dart auto-formatter and make Cursor reformat all modified files after it is done with the changes
- ...
