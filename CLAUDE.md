# 🧠 Claude Coding Agent Guidelines

This document defines exact behavioral rules for the Claude code assistant in this repository. It integrates Cursor rules, architecture constraints, changelog behavior, and per-task logging.

---

## 🧩 Claude's Purpose

Claude performs automation tasks when explicitly requested by the user:

- Implements functionality described in GitHub issues
- Applies unresolved PR feedback comments
- Updates related tests and documentation

> Triggered via GitHub comment:
> ```
> @claude please implement this
> @claude fix unresolved comments
> ```

---

## 🔧 Allowed Tools

Claude may only use:

- `ViewFile` – read file contents
- `Write` – modify code and documentation
- `GrepTool` – search within repo content

❗ No other tools (e.g., shell execution, package install, git, list files) are allowed.

---

## 📂 File & Directory Access Rules

Claude MAY modify files in:
- `lib/`
- `test/`
- `assets/`
- `Implementation specification.md`
- `Next steps.md`

Claude MUST NOT touch:
- `infra/`, `config/`, `.github/`, `secrets/`, `scripts/`
- Any `main`, `dev`, or human-authored branch directly

Claude MUST use `// @allow-agent` if modifying files outside typical scope.

---

## 🧱 Code & Architecture Rules

- Use **Flutter with Material 3**, targeting macOS and Android
- Data layer: **SQLite with Drift**, use Drift expressions only
- Type-safe queries required

### Code Organization
- One class per file
- Descriptive file/class names
- Group by domain (`models/`, `screens/`, `widgets/`)
- Split files >300 lines
- Follow single responsibility & separation of concerns

### Code Quality
- No `const` in `build()` methods — ❌ forbidden
- Format all Dart files with `dart format`
- Only fix linter errors relevant to the task

---

## 🧪 App Testing Workflow (CRITICAL)

If user asks to “test the app”:

- ❌ DO NOT run `flutter run`
- ✅ DO ask the user to reload their existing terminal session
- ✅ Instruct to use `r` (hot reload) or `R` (hot restart)
- ✅ Wait for feedback before continuing

Use this workflow unless user specifically requests build/deploy actions.

---

## 📚 Documentation & Sync Rules

Claude MUST update:
- `Implementation specification.md`
- `Next steps.md`
- `.claude/agent/<branch>/changelog.md`

Update when:
- UI/UX changes occur
- New features are added
- Data models or screen flows change

Follow Keep a Changelog format and semantic versioning.

---

## 📄 Output Files & Logging

Claude MUST create the following files per task in:

```
.claude/agent/<branch-name>/
```

### `changelog.md`
- Task summary, files changed, notes on testing/specs
- NEVER touch the human `Changelog.md`

### `conversation.md`
- Original user comment
- Claude’s reasoning and decisions
- Full message log (if multi-turn)

### Example:

```
.claude/
└── agent/issue-42/
    ├── changelog.md
    └── conversation.md
```

Claude MUST link to `changelog.md` in the PR comment:
> “📄 See changelog: `.claude/agent/issue-42/changelog.md`”

---

## ✅ Commit & Workflow Rules

Claude MUST:

1. Work on a new branch: `agent/<task>`
2. Never push directly to `main`
3. Make a single commit per task
4. Follow conventional commit format:
   - `feat:`, `fix:`, `docs:`, `refactor:`, etc.
5. Include in commit:
   - Code changes
   - changelog.md
   - conversation.md
   - Spec + Next Steps updates (if applicable)

---

## 📌 Task Discipline (CRITICAL)

Claude MUST stay focused:
- Do not refactor unrelated code
- Do not fix linter issues not caused by the task
- Do not apply “helpful improvements” unless requested

If improvements are noticed — Claude should suggest them in a comment but not apply.

---

## ✅ Claude Checklist (Per Task)

Claude MUST ensure the following before submitting changes:

- [ ] Format all `.dart` files
- [ ] Add/update tests (if logic is changed)
- [ ] Update `Implementation specification.md`
- [ ] Update `Next steps.md`
- [ ] Create `.claude/agent/<branch>/changelog.md`
- [ ] Create `.claude/agent/<branch>/conversation.md`
- [ ] Leave summary comment in PR with changelog link

---

**This file is part of Claude's system prompt. It must be machine-readable and strictly enforced.**
