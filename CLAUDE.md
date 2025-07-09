# 🧠 Claude Coding Agent Guidelines

This document defines exact behavioral rules for the Claude code assistant in this repository. It integrates Cursor rules, architecture constraints, changelog behavior, and a multi-stage workflow for implementing GitHub issues.

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
- Format all Dart files with `dart format` when the implementation is ready according to user
- Only fix linter errors relevant to the task

---

## 🛠️ Issue Implementation Lifecycle

When Claude is asked to implement a GitHub issue, it MUST follow this structured lifecycle:

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

This spec MUST include:
- User story and behavioral summary
- Wireframe mockup (ASCII format)
- List of UX patterns used
- For each pattern: where it already exists in the app

Claude MUST notify the user for review.  
> ✅ Claude MUST NOT continue unless the user explicitly approves the functional spec.

---

### 3️⃣ Technical Specification

Upon approval of the functional spec, Claude MUST create:

```
.claude/agent/issue-<number>/technical-spec.md
```

This file MUST:
- Outline the components/screens/functions to be added or changed
- Describe file-level structure and logic/data flow
- Avoid writing implementation code

Claude MUST notify the user and wait for approval before proceeding.

---

### 4️⃣ Implementation

After technical spec is approved, Claude MUST:
- Create a new branch: `agent/issue-<number>`
- Implement only the approved functionality
- Modify only relevant files
- Reuse existing UX and components
- Update documentation if required (`Implementation specification.md`, `Next steps.md`)
- Format Dart code only after confirmation from the user

---

### 5️⃣ Testing

Claude MUST:
- Add or update tests relevant to the logic/UI changed
- If tests are skipped, explain why in `changelog.md`

---

### 6️⃣ Finalization

Claude MUST:
- Commit the full set of changes in one commit (unless instructed otherwise)
- Follow conventional commit naming
- Leave a PR comment with a link to:

```
.claude/agent/issue-<number>/
├── changelog.md
├── conversation.md
├── functional-spec.md
└── technical-spec.md
```

---

## 📄 Output Files & Logging

For each branch, Claude MUST create:

- `changelog.md` – summary of implementation
- `conversation.md` – interaction + reasoning trace
- `functional-spec.md` – planned behavior and wireframe
- `technical-spec.md` – technical description (no code)

All files MUST be stored in:

```
.claude/agent/<branch-name>/
```

---

## ✅ Commit & Workflow Rules

Claude MUST:

1. Work on a new branch: `agent/<task>`
2. Never push directly to `main`
3. Make a single commit per task (unless explicitly told otherwise)
4. Use conventional commit format:
   - `feat:`, `fix:`, `docs:`, `refactor:`, etc.
5. Include in commit:
   - Code
   - changelog.md
   - conversation.md
   - functional-spec.md
   - technical-spec.md
   - Any updated docs (`Implementation specification.md`, `Next steps.md`)

---

## 📌 Task Discipline (CRITICAL)

Claude MUST remain focused:
- Do not refactor unrelated code
- Do not fix linter warnings not caused by this task
- Do not add “helpful improvements” unless asked

---

## ✅ Claude Checklist (Per Task)

Claude MUST ensure the following before implementation is marked complete:

- [ ] Create functional-spec.md and wait for approval
- [ ] Create technical-spec.md and wait for approval
- [ ] Format all `.dart` files after user approval
- [ ] Add/update tests
- [ ] Update documentation (if needed)
- [ ] Create changelog.md and conversation.md
- [ ] Leave PR comment linking `.claude/agent/<branch>/changelog.md`

---

**This file is part of Claude's system prompt. It must be machine-readable and strictly enforced.**
