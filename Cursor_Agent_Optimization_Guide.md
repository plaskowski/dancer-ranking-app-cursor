# Cursor Agent Optimization Guide: Reducing Back-and-Forth Refinement

Based on analysis of a week-long Flutter development project using Cursor IDE, this guide provides practical strategies to optimize Cursor Agent usage and minimize refinement cycles.

## Table of Contents
1. [Critical Setup & Configuration](#critical-setup--configuration)
2. [Task Management & Focus](#task-management--focus)
3. [Documentation Synchronization](#documentation-synchronization)
4. [Testing Workflow Optimization](#testing-workflow-optimization)
5. [Code Quality & Organization](#code-quality--organization)
6. [Multi-Agent Coordination](#multi-agent-coordination)
7. [Common Pitfalls & Solutions](#common-pitfalls--solutions)
8. [Automation & Scripts](#automation--scripts)

## Critical Setup & Configuration

### 1. Comprehensive .cursorrules File
Create a detailed `.cursorrules` file that acts as your agent's playbook. Based on the analyzed project, key sections include:

**Essential Rules to Include:**
```markdown
## Task Focus Rule
**CRITICAL**: Stay strictly focused on the current task. Do NOT make unrelated changes.
- Only modify files directly related to the current task
- Do not refactor unrelated code "while you're at it"
- Do not fix unrelated linter warnings unless they block the current task
- If you see opportunities for improvement, mention them but don't implement unless asked

## Testing Workflow Rule
**CRITICAL**: When user asks to test the app, follow this exact workflow:
1. **DO NOT** start a new terminal session or run commands
2. **DO** ask the user to reload in their existing session
3. **DO** provide exact commands they should run
4. **DO** wait for user feedback about results

## Documentation Sync Rule
**CRITICAL**: Whenever you make changes to implementation, you MUST also update corresponding documentation sections.
```

### 2. File Organization Standards
Establish clear file organization rules to prevent clutter and confusion:

```markdown
## File Structure Rules
- **One class per file**: Put each component class into a separate file
- **Descriptive naming**: Use clear, descriptive names matching class names
- **Logical grouping**: Organize into appropriate directories
- **File size limit**: Refactor files longer than 300 lines into smaller classes
- **Don't put new files into main directory** to avoid clutter
```

### 3. Const Expression Handling
Add specific rules to handle common Flutter/Dart issues:

```markdown
## Const Expression Rule
**CRITICAL**: NEVER use `const` keyword in build methods because it changes back and forth
- If const expression errors occur, immediately remove `const` keyword
- Don't try to work around const issues - just remove them
```

## Task Management & Focus

### 1. Single Task Rule
**Problem Identified**: Agents tend to expand scope and make unrelated changes.

**Solution**: Implement strict task focus rules:
- Always specify ONE clear task per interaction
- Include explicit instructions not to make unrelated improvements
- If agent suggests additional improvements, ask them to note them for later but not implement

**Example Prompt Structure:**
```
Task: [Specific single task]
Focus: Only modify files directly related to this task
Do NOT: Refactor unrelated code, fix unrelated warnings, or make "while we're at it" improvements
```

### 2. Task Completion Workflow
Establish a mandatory sequence for completing tasks:

1. **Implement** the specific change
2. **Update documentation** if behavior changed
3. **Update changelog** with version bump
4. **Clean up next steps** document
5. **Commit all changes** in single commit

### 3. User Story Validation
**Pain Point**: No way to validate if implementation meets requirements.

**Planned Solutions** (from DevExImprovements.md):
- Ability to run user stories for regression testing
- Automated testing before marking tasks as done
- User acceptance testing protocols
- Screenshot/video recording of test runs for review

## Documentation Synchronization

### 1. Automatic Documentation Updates
**Problem**: Implementation and documentation get out of sync.

**Solution**: Mandatory documentation sync rules:

```markdown
## Documentation Sync Rule
**CRITICAL**: Always update these sections when making changes:
- **New features**: Add to screen descriptions, navigation flow, key features
- **UI/UX changes**: Update screen descriptions, actions, navigation patterns
- **Data model changes**: Update database schema, relationships, workflows
- **Dialog/modal changes**: Update navigation flow and screen actions
```

### 2. Specification Files to Maintain
- `Implementation specification.md` - Technical implementation details
- `Product specification.md` - Product requirements and features
- `Changelog.md` - Detailed change tracking with version bumping
- `Next steps.md` - Clean task tracking

### 3. Version-Based Development
Implement immediate version bumping for every change:
- Create new version section for each development session
- Include "User Requests" section documenting what user asked for
- Use semantic versioning (patch/minor/major)
- Follow [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format

## Testing Workflow Optimization

### 1. Hot Reload Protocol
**Problem**: Agents starting new terminal sessions unnecessarily.

**Solution**: Specific testing workflow rules:
```markdown
When user asks to test:
1. DO NOT start new terminal session or run flutter run
2. DO ask user to reload in existing session (r for hot reload, R for restart)
3. DO wait for user feedback about results
4. DO mention app should already be running
```

### 2. Automated Testing Integration
**Future Improvements** (from pain points):
- User story automation for regression testing
- Test validation before task completion
- CLI navigation support for faster testing
- Screenshot/video capture during testing

### 3. Testing Feedback Loop
Establish clear testing communication:
- Agent provides specific testing instructions
- User provides specific feedback
- Agent responds only to feedback received
- No assumptions about test results

## Code Quality & Organization

### 1. Linter Error Handling
**Problem**: Agents trying to work around linter errors instead of fixing them.

**Solution**: Clear linter rules:
```markdown
## Linter Error Handling
- Fix linter errors directly related to your changes
- If const expression errors occur, immediately remove const keyword
- Don't try to work around linter issues
- Test changes thoroughly before committing
```

### 2. Auto-Formatting
Always format modified files:
```markdown
## Auto-Formatting Rule
**ALWAYS** format modified Dart files:
- Use `dart format` on any Dart files you modify
- Ensure consistent indentation and style
- Run formatting automatically after making changes
```

### 3. File Management
**Pain Point**: Agents can't delete files or manage file operations effectively.

**Solutions Needed**:
- Allow agents to delete .dart and .md files
- Better file organization capabilities
- Auto-save functionality for work-in-progress

## Multi-Agent Coordination

### 1. Parallel Development Challenges
**Key Finding**: "Bez szans zeby moc mergowac zmiany roznych agentow kiedy pisza low level code" (No way to merge changes from different agents when writing low-level code)

**Recommendations**:
- Use separate agents for front-end and back-end tasks
- Implement modular codebase architecture to avoid conflicts
- Use separate changelog files to avoid merge conflicts
- Coordinate through shared specification documents

### 2. Agent Separation Strategies
- **Frontend Agent**: UI/UX, screens, dialogs, navigation
- **Backend Agent**: Data models, services, database operations
- **Documentation Agent**: Specifications, documentation updates

### 3. Coordination Tools
**From Pain Points Analysis**:
- Separate configs for different workspaces (title bar colors)
- Native reactive update patterns
- MCP tools for running apps connecting to IDE configurations
- Better synchronization between development lines

## Common Pitfalls & Solutions

### 1. Scope Creep Prevention
**Pitfall**: Agents making unrelated improvements during focused tasks.

**Solutions**:
- Explicit "Do NOT" instructions in every task
- Task focus rules in .cursorrules
- Single responsibility principle for each interaction

### 2. Documentation Drift
**Pitfall**: Implementation and documentation getting out of sync.

**Solutions**:
- Mandatory documentation updates with every change
- Automatic specification syncing rules
- Version-based change tracking

### 3. Testing Inefficiency
**Pitfall**: Unnecessary terminal sessions and testing overhead.

**Solutions**:
- Hot reload protocol rules
- CLI navigation support for faster testing
- Automated app navigation for testing

### 4. File Organization Chaos
**Pitfall**: Files scattered in main directory, unclear organization.

**Solutions**:
- Strict file organization rules
- One class per file principle
- Logical directory grouping
- Don't put new files in main directory

## Automation & Scripts

### 1. Release Automation
Based on the analyzed project's `release.sh` script:
- Automated version bumping in pubspec.yaml
- Changelog generation
- APK building and distribution
- Validation and error handling

### 2. Code Quality Scripts
- `validate_imports.sh` - Import validation
- `analyze.sh` - Code analysis automation
- Auto-formatting integration

### 3. Development Workflow Scripts
**Suggested Automations**:
- Auto-commit todo files after inactivity
- Auto-close non-pinned editors after idle time
- Automated user story validation
- Screenshot/video capture for testing

## Implementation Checklist

### Initial Setup
- [ ] Create comprehensive .cursorrules file with all critical rules
- [ ] Set up file organization standards
- [ ] Establish documentation structure
- [ ] Configure testing workflow protocols

### Per-Task Workflow
- [ ] Define single, specific task
- [ ] Include explicit focus instructions
- [ ] Specify what NOT to change
- [ ] Follow mandatory completion sequence
- [ ] Update all relevant documentation
- [ ] Bump version and update changelog
- [ ] Test using hot reload protocol

### Quality Assurance
- [ ] Validate documentation sync
- [ ] Check file organization compliance
- [ ] Run automated validation scripts
- [ ] Verify single commit includes all changes

### Long-term Optimization
- [ ] Implement user story automation
- [ ] Set up multi-agent coordination
- [ ] Develop testing automation
- [ ] Create workflow improvement feedback loop

## Conclusion

The key to reducing back-and-forth with Cursor Agent lies in:

1. **Comprehensive upfront configuration** through detailed .cursorrules
2. **Strict task focus** with explicit boundaries
3. **Mandatory documentation synchronization** with every change
4. **Optimized testing workflows** using hot reload protocols
5. **Clear file organization** standards and automation
6. **Version-based development** with immediate change tracking

By implementing these strategies based on real development experience, you can significantly reduce refinement cycles and improve development efficiency with Cursor Agent.