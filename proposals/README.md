# Proposals Directory

This directory contains **unimplemented proposals** and ideas that are under consideration but not yet part of the system.

## Status Definitions

- **🟡 PROPOSAL**: New idea or suggestion, not yet approved
- **🟠 UNDER_REVIEW**: Being evaluated by team/stakeholders  
- **🟢 APPROVED**: Approved for implementation, but not yet implemented
- **🔴 REJECTED**: Not moving forward
- **✅ IMPLEMENTED**: Moved to main documentation and removed from proposals

## Directory Structure

```
proposals/
├── README.md                           # This file
├── documentation/                      # Documentation system proposals
│   ├── multi-agent-docs-structure.md  # Multi-agent documentation proposal
│   └── ...
├── features/                          # New feature proposals
│   ├── advanced-filtering.md
│   └── ...
├── technical/                         # Technical architecture proposals
│   ├── performance-optimization.md
│   └── ...
├── ui-ux/                            # UI/UX improvement proposals
│   ├── mobile-responsive-design.md
│   └── ...
├── process/                          # Process and workflow proposals
│   ├── testing-strategy.md
│   └── ...
└── archive/                          # Rejected or superseded proposals
    ├── rejected/
    └── superseded/
```

## Proposal Lifecycle

1. **Create**: Add new proposal with `🟡 PROPOSAL` status
2. **Review**: Change status to `🟠 UNDER_REVIEW` 
3. **Decision**: 
   - Approve: `🟢 APPROVED` → plan implementation
   - Reject: `🔴 REJECTED` → move to `archive/rejected/`
4. **Implement**: When implementation begins, move to appropriate system docs
5. **Complete**: Remove from proposals, ensure it's in main documentation

## Proposal Template

Use this template for new proposals:

```markdown
# Proposal: [Title]

**Status**: 🟡 PROPOSAL  
**Created**: YYYY-MM-DD  
**Author**: [Name/Agent]  
**Type**: [Documentation/Feature/Technical/UI-UX/Process]  

## Summary
Brief one-paragraph summary of the proposal.

## Problem Statement
What problem does this solve?

## Proposed Solution
Detailed description of the proposed solution.

## Implementation Plan
How would this be implemented?

## Benefits
What are the expected benefits?

## Drawbacks/Risks
What are the potential downsides?

## Alternatives Considered
What other options were considered?

## Decision Required
What decision needs to be made and by whom?
```

## File Naming Convention

- Use descriptive, kebab-case names
- Include the type in the path (not filename)
- Example: `features/dancer-activity-tracking.md`

## Moving from Proposals to Implementation

When a proposal is approved and implemented:

1. **Update main documentation** (specs/, docs/, etc.)
2. **Update proposal status** to ✅ IMPLEMENTED
3. **Add link to implementation** in proposal
4. **Remove proposal file** after 1-2 weeks (keep in git history)

## Integration with Existing System

- **Proposals**: Stay in `proposals/` directory
- **Specifications**: Move to `specs/` when approved but not implemented  
- **Documentation**: Move to `docs/` when implemented
- **Implementation**: Track in main codebase and `Implementation specification.md`