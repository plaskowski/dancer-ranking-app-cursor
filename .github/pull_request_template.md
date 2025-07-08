# Pull Request Checklist

Please complete **every** item before requesting review. Remove lines that are not relevant.

## Type of Change
- [ ] feat
- [ ] fix
- [ ] refactor
- [ ] docs
- [ ] chore
- [ ] test
- [ ] style

## Pre-Merge Checklists

### UI / UX
- [ ] Verified on macOS *and* Android emulator
- [ ] Rotated screen; checked `SafeArea`, dialog overflow & scroll
- [ ] Colours & icons follow Material 3

### Provider / State
- [ ] No duplicate providers (widget pumped twice without crash)
- [ ] Added / updated integration test for new flow

### Cross-Platform
- [ ] `flutter test` passes locally
- [ ] CI checks are green

### Documentation & Spec
- [ ] Updated `Implementation specification.md` (if behaviour changed)
- [ ] Updated screenshots / diagrams if needed

### Changelog & Release
- [ ] Added entry to `Changelog.md`
- [ ] Ran `./scripts/release.sh --dry-run` if this PR bumps version

## Description / Motivation (short)

> Explain *what* & *why* in 1–2 sentences.

## Screenshots or GIFs (if UI change)

## Breaking Changes?
- [ ] Yes – describe migration path
- [ ] No