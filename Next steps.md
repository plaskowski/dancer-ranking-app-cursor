
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

- ✅ **DEVELOPMENT WORKFLOW ENHANCED**: Comprehensive Cursor configuration and development rules
  → **Enhanced .cursorrules**: Added const expression rules, auto-approval for flutter analyze, task focus rules
  → **Stricter Linting**: Enhanced analysis_options.yaml with 20+ additional lint rules for code quality
  → **Auto-formatting**: Set up dart format integration and VS Code settings for format-on-save
  → **Development Scripts**: Created scripts/analyze.sh for quick code quality checks
  → **Key Rules Added**:
    - Never use `const` with dynamic values (Theme.of(context), context.danceTheme)
    - Auto-run `flutter analyze --no-fatal-infos --no-fatal-warnings` without approval
    - Stay focused on current task - no unrelated changes
    - Auto-format all modified Dart files
    - Handle linter errors efficiently (max 3 iterations per file)

Next step:
- fix the Cursor config so that it can run flutter analyze without waiting for approval
- ...
