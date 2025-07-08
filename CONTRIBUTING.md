# Contributing to Dancer Ranking App

Thank you for taking the time to contribute! To keep velocity high and regressions low, please **follow every rule and checklist below before you open a pull-request.**

---

## 1. Commit Message Convention

Prefix each commit with one of the following scopes so automation and changelogs stay tidy:

- **feat:** new feature or enhancement
- **fix:** bug-fix or regression patch
- **refactor:** code movement or re-architecture (no behaviour change)
- **docs:** documentation only
- **chore:** CI, tooling, release bumps, dependency updates
- **test:** unit / widget / integration tests
- **style:** formatting only (no logic change)

Example:
```bash
feat: implement unified dancer filtering component
```

---

## 2. Pre-Merge Checklists

### 2.1 UI / UX Checklist
- [ ] Hot-reload on **macOS _and_ Android** emulators and verify layout
- [ ] Rotate screen; ensure dialogs & bottom-sheets respect `SafeArea`
- [ ] Check scroll behaviour and overflow handling for lists/dialogs
- [ ] Confirm any new icons or colours follow Material 3 & app colour rules

### 2.2 Provider / State Checklist
- [ ] Verify new providers are **registered once** and disposed correctly
- [ ] Pump the widget twice in a unit test to catch duplicate provider errors
- [ ] Add or update an **integration test** that navigates through the new flow

### 2.3 Cross-Platform Smoke Test
- [ ] Run `flutter test` for all widget & unit tests
- [ ] CI must pass on Linux + Android runners

### 2.4 Documentation Sync
- [ ] If **implementation or behaviour** changes, update `Implementation specification.md`
- [ ] Record UI/UX changes under *Screens*, *Navigation Flow*, or *Key Features*

### 2.5 Release / Changelog
- [ ] Update `Changelog.md` (keep-a-changelog format) under the correct version section
- [ ] For version bumps, use `scripts/release.sh --dry-run` first

---

## 3. Opening Your Pull Request

1. Add a clear title: `feat: ...`, `fix: ...`, etc.
2. Fill out the PR template checkboxes (see `.github/pull_request_template.md`).
3. Ensure all CI checks pass.

_MRs that fail to tick **all** required boxes will be politely asked to follow the checklist before review._

---

## 4. Release Workflow (Quick Guide)

1. Merge all PRs that are intended for the release.
2. Run `./scripts/release.sh patch|minor|major` (or `--dry-run` for preview).
3. The script will:
   - Bump `pubspec.yaml` version & build
   - Update `Changelog.md` header stub
   - Commit & tag (`chore: bump version to X.Y.Z`)
   - Push commit and tag, which triggers the GH release workflow
4. Verify the GitHub Release artefacts.

---

## 5. Retro & Continuous Improvement

After each sprint or major feature delivery, use `docs/retro_template.md` to capture lessons and turn them into new rules or checklist items.

Happy coding!