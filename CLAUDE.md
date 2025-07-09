# 🧠 Claude Coding Agent Guidelines

This document defines exact behavioral rules for the Claude code assistant in this repository. It integrates architecture constraints, changelog behavior, and a multi-stage workflow for implementing GitHub issues.

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

## 🧱 Code & Architecture Rules

- Use **Flutter with Material 3**, targeting macOS and Android
- Data layer: **SQLite with Drift**, use Drift expressions only
- Type-safe queries required
- Follow UX patterns already used in the app

### Code Organization
- One class per file
- Descriptive file/class names
- Group by domain (`models/`, `screens/`, `widgets/`)
- Split files >300 lines
- Follow single responsibility & separation of concerns

### Code Quality
- No `const` in `build()` methods — ❌ forbidden
- Format all Dart files with `dart format` only after user approval
- Only fix linter errors relevant to the task

---

## 🛠️ Issue Implementation Lifecycle

Claude MUST follow this structured lifecycle for every task.

### 1️⃣ Issue Analysis

Claude MUST:
- Read the issue title and description
- Identify affected screens, components, models or flows
- Leave a comment summarizing understanding
- Ask for clarification if needed

---

### 2️⃣ Functional Specification

Claude MUST create:

```
.claude/agent/issue-<number>/functional-spec.md
```

Must include:
- User story and behavioral summary
- ASCII wireframe mockup
- UX patterns used + where they are reused in the app

Claude MUST request user approval before continuing.

---

### 3️⃣ Technical Specification

After functional spec is approved, create:

```
.claude/agent/issue-<number>/technical-spec.md
```

Must include:
- What components/functions will be created or modified
- Planned file structure
- Logic/data flow (no implementation code)

Wait for user approval before proceeding.

---

### 4️⃣ Implementation

Once approved, Claude MUST:
- Create a branch: `agent/issue-<number>`
- Implement only what was approved
- Use a **separate commit for each incremental change**:
  - One for layout
  - One for logic
  - One for test
  - One for docs
- Modify only relevant files
- Reuse components and patterns when possible
- Notify user when code is ready for formatting

---

### 5️⃣ Testing

Claude MUST:
- Add or update tests (widget/unit/integration)
- If skipping tests, explain in `changelog.md`

---

### 6️⃣ Finalization

Claude MUST:
- Leave a comment linking:

```
.claude/agent/issue-<number>/
├── changelog.md
├── conversation.md
├── functional-spec.md
└── technical-spec.md
```

---

## 📄 Output Files

All outputs must be stored under:

```
.claude/agent/<branch-name>/
```

Each task must contain:

- `changelog.md`
- `conversation.md`
- `functional-spec.md`
- `technical-spec.md`

---

## ✅ Commit Rules

Claude MUST:

1. Use a branch: `agent/<task>`
2. Never push directly to `main`
3. Use a **separate commit for each logical change**
4. Follow conventional commit format:
   - `feat:`, `fix:`, `test:`, `docs:`, etc.
5. Include all relevant files in commits

---

## 📌 Task Discipline

Claude MUST stay focused:
- No unrelated refactors
- No extra linting fixes
- No unsolicited improvements

---

## ✅ Claude Checklist

- [ ] Analyze issue and confirm understanding
- [ ] Create and submit functional-spec.md
- [ ] Wait for approval
- [ ] Create and submit technical-spec.md
- [ ] Wait for approval
- [ ] Implement task using separate commits
- [ ] Create changelog.md and conversation.md
- [ ] Add comment with `.claude/agent/<branch>/changelog.md` link

---

**This file is part of Claude’s system prompt. It must be machine-readable and strictly enforced.**
