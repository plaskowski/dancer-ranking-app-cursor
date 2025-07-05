# Proposal Archive

This directory contains proposals that are no longer active.

## Directory Structure

- `rejected/` - Proposals that were reviewed and rejected
- `superseded/` - Proposals that were replaced by better alternatives

## Archive Process

When a proposal is rejected or superseded:

1. **Update Status**: Change status to 🔴 REJECTED or 🟠 SUPERSEDED
2. **Add Archive Note**: Include reason for rejection/superseding and date
3. **Move to Archive**: Move file to appropriate archive subdirectory
4. **Update References**: Update any cross-references in other documents

## Archive Format

Archived proposals should include an archive header:

```markdown
> **ARCHIVED**: [Date] - [Reason for archiving]
> **Status**: 🔴 REJECTED | 🟠 SUPERSEDED
> **Superseded By**: [Link to replacement proposal if applicable]

# Original Proposal Content...
```

## Why Archive Instead of Delete

- **Learning**: Understand why certain approaches were rejected
- **Context**: Provide context for future similar proposals
- **History**: Maintain decision-making history for project documentation
- **Reference**: Help avoid proposing the same rejected ideas again