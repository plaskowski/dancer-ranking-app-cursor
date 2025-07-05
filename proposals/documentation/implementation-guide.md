# Implementation Guide: Multi-Agent Documentation Structure

> **Note**: This is a supporting document for the [Multi-Agent Documentation Structure Proposal](multi-agent-docs-structure.md)

## Overview

This guide provides step-by-step instructions for implementing the proposed multi-agent documentation structure in the Dancer Ranking App project.

## Pre-Implementation Analysis

### Current Structure Assessment
- **Large Files**: `Changelog.md` (57KB), `Product specification.md` (42KB)
- **Mixed Content**: Single files contain multiple types of information
- **Conflict Potential**: High chance of merge conflicts with multiple agents
- **Existing Organization**: Some structure exists in `specs/` directory

### Migration Complexity
- **Medium**: Existing structure has some organization
- **Data Volume**: Significant content to migrate
- **Active Development**: Need to maintain functionality during transition

## Implementation Phases

### Phase 1: Structure Creation (Week 1)

#### Step 1.1: Create New Directory Structure

```bash
# Create main documentation directories
mkdir -p docs/agents
mkdir -p docs/changelog/{versions,components,unreleased}
mkdir -p docs/specifications/{product,technical,features,implementation}
mkdir -p docs/planning/{roadmap,backlog,completed}
mkdir -p docs/guides/{user-guides,developer-guides,design-guides}
mkdir -p docs/meta

# Create feature-specific directories
mkdir -p docs/specifications/features/dancer-management
mkdir -p docs/specifications/features/event-management
mkdir -p docs/specifications/features/ranking-system
mkdir -p docs/specifications/features/tag-system
mkdir -p docs/specifications/features/event-import

# Create implementation directories
mkdir -p docs/specifications/implementation/{screens,components,services}
```

#### Step 1.2: Create Index Files

Create README.md files for each major directory:

```markdown
# docs/README.md
# Dancer Ranking App Documentation

This directory contains all project documentation organized for multi-agent collaboration.

## Directory Structure
- `agents/` - Agent coordination and standards
- `changelog/` - Version history and changes
- `specifications/` - Detailed specifications
- `planning/` - Roadmap and backlog
- `guides/` - User and developer guides
- `meta/` - Documentation about documentation

## Quick Links
- [Agent Coordination](agents/agent-coordination.md)
- [Current Roadmap](planning/roadmap/current-milestone.md)
- [Development Guide](guides/developer-guides/setup-guide.md)
```

#### Step 1.3: Agent Coordination Files

Create coordination files:

```yaml
# docs/agents/agent-coordination.md
---
owner: system
last_updated: 2025-01-17T10:30:00Z
update_frequency: low
dependencies: []
conflicts_with: []
---

# Agent Coordination Guidelines

## File Ownership Rules
1. Check metadata header before updating any file
2. Respect `owner` field - coordinate with owner if needed
3. Update `last_updated` timestamp when making changes
4. Declare dependencies and potential conflicts

## Update Procedures
1. Read current file content
2. Check for recent updates (< 5 minutes)
3. Make atomic changes when possible
4. Update metadata after changes
5. Validate cross-references

## Conflict Resolution
1. **Prevention**: Use staged updates in `unreleased/` directories
2. **Detection**: Check timestamps and owner metadata
3. **Resolution**: Coordinate with other agents or escalate to human
```

### Phase 2: Content Migration (Week 2)

#### Step 2.1: Split Large Files

**Changelog Migration**:
```bash
# Split Changelog.md into versions
python scripts/split_changelog.py Changelog.md docs/changelog/versions/
```

**Product Specification Migration**:
```bash
# Split Product specification.md into logical components
python scripts/split_product_spec.py "specs/Product specification.md" docs/specifications/
```

#### Step 2.2: Feature Documentation Migration

For each feature, create the standard structure:

```markdown
# docs/specifications/features/dancer-management/overview.md
---
owner: feature-agent
last_updated: 2025-01-17T10:30:00Z
update_frequency: medium
dependencies: 
  - specifications/technical/database-schema.md
  - specifications/implementation/screens/dancers-screen.md
conflicts_with: []
---

# Dancer Management Feature

## Purpose
Comprehensive system for managing dancer profiles, including creation, editing, archiving, and organization through tags and search functionality.

## Key Components
- Dancer profiles with notes and tags
- Search and filtering capabilities
- Archival system for inactive dancers
- Merge functionality for duplicates
- Last met tracking

## User Stories
[Content from existing Product specification.md]

## Business Rules
[Content from existing Product specification.md]
```

#### Step 2.3: Implementation Documentation Migration

Create screen-specific documentation:

```markdown
# docs/specifications/implementation/screens/dancers-screen.md
---
owner: implementation-agent
last_updated: 2025-01-17T10:30:00Z
update_frequency: high
dependencies: 
  - specifications/features/dancer-management/overview.md
  - specifications/technical/database-schema.md
conflicts_with: []
---

# Dancers Screen Implementation

## File Location
`lib/screens/dancers/dancers_screen.dart`

## Purpose
View and manage all dancers in the system with comprehensive filtering and search capabilities.

## Current Implementation
[Content from existing Implementation specification.md]

## UI Components
[Detailed component breakdown]

## State Management
[State management details]

## Navigation Flow
[Navigation implementation]
```

### Phase 3: Agent Integration (Week 3)

#### Step 3.1: Update Agent Rules

Update `.cursorrules` file to reference new structure:

```markdown
## Documentation Sync Rule
**CRITICAL**: When making changes to implementation, update corresponding documentation in the new structure:

### Documentation Update Flow
1. **Feature Changes**: Update `docs/specifications/features/[feature-name]/`
2. **Implementation Changes**: Update `docs/specifications/implementation/`
3. **UI Changes**: Update `docs/guides/design-guides/`
4. **Changelog**: Add entry to `docs/changelog/unreleased/`

### File Coordination
- Check file metadata before updating
- Respect ownership and recent updates
- Use staged updates for complex changes
- Validate cross-references after updates
```

#### Step 3.2: Create Migration Scripts

```python
# scripts/migrate_documentation.py
import os
import yaml
import re
from datetime import datetime

def add_metadata_header(file_path, owner="system", update_frequency="medium"):
    """Add metadata header to markdown file"""
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Check if header already exists
    if content.startswith('---'):
        return
    
    header = f"""---
owner: {owner}
last_updated: {datetime.now().isoformat()}
update_frequency: {update_frequency}
dependencies: []
conflicts_with: []
---

"""
    
    with open(file_path, 'w') as f:
        f.write(header + content)

def migrate_changelog(source_file, target_dir):
    """Split changelog into individual version files"""
    with open(source_file, 'r') as f:
        content = f.read()
    
    # Split by version headers
    versions = re.split(r'^## \[v([\d.]+)\]', content, flags=re.MULTILINE)
    
    for i in range(1, len(versions), 2):
        version = versions[i]
        version_content = versions[i+1]
        
        filename = f"{target_dir}/v{version}.md"
        with open(filename, 'w') as f:
            f.write(f"# Version {version}\n\n{version_content.strip()}")
        
        add_metadata_header(filename, "changelog-agent", "low")

# Usage
migrate_changelog("Changelog.md", "docs/changelog/versions")
```

#### Step 3.3: Validation Scripts

```python
# scripts/validate_documentation.py
import os
import yaml
import re
from pathlib import Path

def validate_file_structure():
    """Validate that all required files exist"""
    required_files = [
        "docs/README.md",
        "docs/agents/agent-coordination.md",
        "docs/changelog/README.md",
        "docs/specifications/README.md",
        "docs/planning/README.md",
        "docs/guides/README.md",
        "docs/meta/README.md",
    ]
    
    for file_path in required_files:
        if not os.path.exists(file_path):
            print(f"Missing required file: {file_path}")

def validate_metadata_headers():
    """Validate that all markdown files have proper metadata headers"""
    docs_dir = Path("docs")
    
    for md_file in docs_dir.rglob("*.md"):
        with open(md_file, 'r') as f:
            content = f.read()
        
        if not content.startswith('---'):
            print(f"Missing metadata header: {md_file}")
            continue
        
        # Extract and validate metadata
        try:
            header_end = content.index('---', 3)
            header_content = content[3:header_end]
            metadata = yaml.safe_load(header_content)
            
            required_fields = ['owner', 'last_updated', 'update_frequency', 'dependencies', 'conflicts_with']
            for field in required_fields:
                if field not in metadata:
                    print(f"Missing metadata field '{field}' in {md_file}")
        
        except Exception as e:
            print(f"Invalid metadata in {md_file}: {e}")

def validate_cross_references():
    """Validate that all internal links are valid"""
    docs_dir = Path("docs")
    
    for md_file in docs_dir.rglob("*.md"):
        with open(md_file, 'r') as f:
            content = f.read()
        
        # Find all markdown links
        links = re.findall(r'\[([^\]]+)\]\(([^)]+)\)', content)
        
        for link_text, link_url in links:
            if link_url.startswith('http'):
                continue  # Skip external links
            
            # Resolve relative path
            target_path = (md_file.parent / link_url).resolve()
            
            if not target_path.exists():
                print(f"Broken link in {md_file}: {link_url}")

if __name__ == "__main__":
    validate_file_structure()
    validate_metadata_headers()
    validate_cross_references()
```

## Agent Workflow Examples

### Example 1: Feature Development Agent

```python
# Workflow for adding new feature documentation
def update_feature_documentation(feature_name, changes):
    """Update documentation for a new feature"""
    
    # 1. Check existing documentation
    feature_dir = f"docs/specifications/features/{feature_name}"
    if not os.path.exists(feature_dir):
        os.makedirs(feature_dir)
        create_feature_template(feature_dir)
    
    # 2. Update feature overview
    update_file_with_metadata(
        f"{feature_dir}/overview.md", 
        changes['overview'],
        owner="feature-agent"
    )
    
    # 3. Update implementation docs
    update_file_with_metadata(
        f"docs/specifications/implementation/screens/{feature_name}-screen.md",
        changes['implementation'],
        owner="feature-agent"
    )
    
    # 4. Add changelog entry
    add_changelog_entry(changes['changelog'], "new-features")
    
    # 5. Update roadmap
    update_roadmap(feature_name, "completed")

def create_feature_template(feature_dir):
    """Create standard feature documentation template"""
    templates = {
        "overview.md": """# {feature_name} Feature

## Purpose
[Brief description]

## User Stories
[User scenarios]

## Business Rules
[Core business logic]
""",
        "user-interface.md": """# {feature_name} UI Specification

## Screens
[Screen descriptions]

## Components
[UI components]

## Interactions
[User interactions]
""",
        "data-model.md": """# {feature_name} Data Model

## Database Schema
[Database changes]

## Service Layer
[Service methods]

## Data Flow
[Data flow description]
""",
        "implementation.md": """# {feature_name} Implementation

## File Structure
[Implementation files]

## Key Components
[Implementation details]

## Testing
[Testing approach]
"""
    }
    
    for filename, template in templates.items():
        file_path = f"{feature_dir}/{filename}"
        with open(file_path, 'w') as f:
            f.write(template)
        add_metadata_header(file_path, "feature-agent", "medium")
```

### Example 2: Bug Fix Agent

```python
# Workflow for bug fix documentation
def update_bug_fix_documentation(component, bug_description, fix_description):
    """Update documentation for a bug fix"""
    
    # 1. Update implementation documentation
    impl_file = f"docs/specifications/implementation/components/{component}.md"
    update_implementation_doc(impl_file, bug_description, fix_description)
    
    # 2. Add changelog entry
    changelog_entry = {
        "type": "Fixed",
        "description": bug_description,
        "fix": fix_description,
        "files_affected": [impl_file]
    }
    add_changelog_entry(changelog_entry, "bug-fixes")
    
    # 3. Update testing documentation if needed
    if needs_test_update(bug_description):
        update_testing_guide(component, fix_description)

def update_implementation_doc(file_path, bug_description, fix_description):
    """Update implementation documentation with bug fix details"""
    
    # Check if file is recently updated by another agent
    if recently_updated(file_path):
        print(f"File {file_path} was recently updated. Coordinating with other agent...")
        return
    
    with open(file_path, 'r') as f:
        content = f.read()
    
    # Add bug fix section
    bug_fix_section = f"""
## Recent Bug Fixes

### {datetime.now().strftime('%Y-%m-%d')}: {bug_description}

**Issue**: {bug_description}

**Fix**: {fix_description}

**Files Modified**: [List of files]

**Testing**: [Testing approach]
"""
    
    # Insert before the last section
    updated_content = content.replace(
        "## Testing", 
        bug_fix_section + "\n## Testing"
    )
    
    with open(file_path, 'w') as f:
        f.write(updated_content)
    
    update_metadata(file_path, "bug-fix-agent")
```

## Validation and Testing

### Continuous Validation

```bash
# Run validation scripts
python scripts/validate_documentation.py

# Check for broken links
python scripts/check_links.py

# Validate metadata consistency
python scripts/validate_metadata.py
```

### Testing Multi-Agent Workflow

```python
# Test script for multi-agent coordination
def test_multi_agent_coordination():
    """Test that multiple agents can work simultaneously"""
    
    # Simulate Feature Agent
    feature_agent = FeatureAgent("feature-agent-1")
    feature_agent.update_feature("new-feature", {"overview": "..."})
    
    # Simulate Bug Fix Agent
    bug_fix_agent = BugFixAgent("bug-fix-agent-1")
    bug_fix_agent.fix_bug("component-x", "bug description", "fix description")
    
    # Simulate UI Agent
    ui_agent = UIAgent("ui-agent-1")
    ui_agent.update_design_guide("material3-icons", {"new_icons": "..."})
    
    # Validate no conflicts
    validate_no_conflicts()
    
    # Validate all documentation is consistent
    validate_documentation_consistency()
```

## Rollback Strategy

If issues arise during migration:

```bash
# Rollback to previous structure
git checkout HEAD~1 -- docs/
git checkout HEAD~1 -- specs/

# Restore original files
cp backup/Changelog.md .
cp backup/Next\ steps.md .
cp backup/specs/ . -r
```

## Success Metrics

### Quantitative Metrics
- **File Size Reduction**: Average file size < 5KB
- **Conflict Reduction**: < 5% of documentation updates cause conflicts
- **Update Speed**: Documentation updates complete in < 30 seconds
- **Cross-Reference Accuracy**: > 95% of internal links valid

### Qualitative Metrics
- **Agent Coordination**: Agents successfully coordinate without conflicts
- **Documentation Quality**: Information remains accurate and up-to-date
- **Developer Experience**: Easier to find and update relevant documentation
- **Maintenance Overhead**: Reduced time spent resolving documentation conflicts

## Conclusion

This implementation guide provides a structured approach to migrating from the current documentation structure to a multi-agent friendly system. The key success factors are:

1. **Gradual Migration**: Implement in phases to maintain stability
2. **Automation**: Use scripts to handle repetitive migration tasks
3. **Validation**: Continuous validation to catch issues early
4. **Agent Coordination**: Clear rules and metadata for agent coordination
5. **Rollback Plan**: Safety net in case of issues

The result will be a documentation system that supports multiple agents working simultaneously while maintaining quality and consistency.