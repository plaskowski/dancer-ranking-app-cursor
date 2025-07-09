# 🧠 Claude Coding Agent Guidelines

This document defines exact behavioral rules for the Claude code assistant in this repository. It includes architectural constraints, changelog behavior, and a multi-stage workflow for implementing GitHub issues.

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

When Claude is asked to implement a GitHub issue, it MUST follow this structured lifecycle:

---

### 1️⃣ Issue Analysis

Claude MUST:
- Read the issue title and description
- Identify affected screens, components, models or flows
- Leave a comment summarizing understanding
- Ask for clarification if needed

🚀 Immediately after analysis, Claude MUST:
- Create a dedicated branch: `agent/issue-<number>`
- Open a draft pull request titled: `feat: start planning issue #<number>`
- Begin committing incremental changes **starting with planning artifacts**

---

### 2️⃣ Functional Specification

Claude MUST create:

```
.claude/agent/issue-<number>/functional-spec.md
```

Must include:
- User story and behavioral summary
- ASCII wireframe mockup
- UX patterns used, and where already present in the app

Claude MUST:
- Commit this file with a descriptive message (`docs: add functional spec for issue #<number>`)
- Notify the user and await approval before proceeding

---

### 3️⃣ Technical Specification

After functional spec approval, Claude MUST create:

```
.claude/agent/issue-<number>/technical-spec.md
```

Must describe:
- Affected components/screens/functions
- File-level structure and logic/data flow (no implementation)
- Out of scope areas

Claude MUST:
- Commit this file as an incremental step
- Notify the user and wait for approval

---

### 4️⃣ Implementation (incremental)

Once technical spec is approved, Claude MUST:

- Continue committing small, focused changes under the same branch
- Each iteration of implementation (e.g. layout, state handling, UX logic) must have its own commit
- Use conventional commit messages (`feat:`, `fix:`, `test:` etc.)
- Do NOT squash or rebase without permission

---

### 5️⃣ Testing

Claude MUST:
- Add or update relevant tests (widget/unit/integration)
- Justify missing tests in `changelog.md` if applicable
- Commit tests in dedicated commits (e.g. `test: add test for ranking tile`)

---

### 6️⃣ Finalization

Claude MUST:
- Add/update:
  - `changelog.md`
  - `conversation.md`
  - `functional-spec.md` (if changes occurred)
  - `technical-spec.md` (if changes occurred)
- Push all changes to the branch used for the PR
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

Claude MUST maintain these files under:

```
.claude/agent/<branch-name>/
```

- `functional-spec.md` – UI and user needs
- `technical-spec.md` – implementation outline
- `changelog.md` – summary of changes
- `conversation.md` – reasoning & discussion trace

---

## ✅ Commit & Branching Rules

Claude MUST:

1. Create a branch at the start: `agent/<task>`
2. Push all outputs and plans to that branch
3. Use separate, focused commits for:
   - Planning
   - UI implementation
   - Logic
   - Tests
   - Documentation
4. Follow conventional commit format
5. Avoid rebasing, amending, or force-pushing

---

## 📌 Task Discipline

Claude MUST stay focused:
- Do not refactor unrelated code
- Do not fix unrelated lint errors
- Do not apply improvements unless explicitly requested

---

## ✅ Claude Checklist

- [ ] Analyze issue and create `agent/<task>` branch
- [ ] Create functional-spec.md and commit it
- [ ] Wait for approval
- [ ] Create technical-spec.md and commit it
- [ ] Wait for approval
- [ ] Implement step by step, commit every increment
- [ ] Add/update tests
- [ ] Write changelog.md and conversation.md
- [ ] Leave PR comment linking `.claude/agent/<branch>/changelog.md`

---

**This file is part of Claude’s system prompt. It must be machine-readable and strictly enforced.**
