# Dancer Filtering by Activity Level

## Overview

This feature helps users quickly find the most relevant dancers when adding them to events by filtering based on their overall activity level - combining both how recently they attended and how frequently they participate.

## Problem Statement

### Current Pain Points
- **Overwhelming Lists**: Users see all dancers in the system, making it hard to find relevant ones
- **No Context**: No indication of which dancers are currently active or likely to attend
- **Time Waste**: Users spend time scrolling through inactive or irrelevant dancers

### User Scenarios Where This Hurts
1. **Weekly Social Organizer**: Needs to quickly find dancers who attended recent socials
2. **Festival Planner**: Wants to invite dancers with proven attendance records
3. **Class Instructor**: Looking for students who regularly attend classes

## Solution Vision

### Core Value Proposition
"Find the right dancers, faster. Filter by who's active and engaged."

### Key Benefits
- **Faster Dancer Discovery**: Find relevant dancers in seconds, not minutes
- **Better Event Planning**: Focus on dancers likely to attend
- **Improved User Experience**: Less scrolling, more relevant results

## User Experience Design

### Primary User Journey

#### 1. **Entry Point**
- User opens "Add Existing Dancer" dialog
- Sees intelligent default: "Active dancers"
- Results immediately show relevant dancers

#### 2. **Filter Discovery**
- User notices activity filter at the top
- Sees current filter: "Showing 15 of 47 dancers"
- Can adjust activity level to find different groups

#### 3. **Filter Adjustment**
- User changes to "Very Active" for highly engaged dancers
- List updates in real-time with loading indicator
- Results show: "Showing 8 of 47 dancers"

#### 4. **Selection**
- User selects desired dancers from filtered list
- Confirms selection and returns to event

### Filter Interface Design

#### **Compact Filter Bar**
```
┌─────────────────────────────────────────────────────────┐
│ 🔍 [Search dancers...]  🏷️ [Tags ▼]  🎯 [Active ▼]    │
└─────────────────────────────────────────────────────────┘
```

#### **Alternative: Inline Filter Row**
```
┌─────────────────────────────────────────────────────────┐
│ 🔍 [Search dancers...]                                 │
│ 🏷️ [Tags ▼]  🎯 [Active ▼]                            │
└─────────────────────────────────────────────────────────┘
```

#### **Activity Levels (Compact)**
- **All**: Show everyone (no filter)
- **Active**: 1+ events in 6 months
- **Very Active**: 3+ events in 6 months
- **Core**: 5+ events in year
- **Recent**: 1+ events in 3 months

#### **Filter Integration**
- **Horizontal Layout**: Activity filter sits alongside existing filters
- **Compact Dropdown**: Small, unobtrusive dropdown with icon
- **No Extra Space**: Integrates with existing filter row

### Enhanced Dancer List

#### **Dancer Card Design**
```
┌─────────────────────────────────────────────────────────┐
│ [👤] John Doe                    [✓]                   │
│     Tags: [Beginner] [Salsa]                           │
└─────────────────────────────────────────────────────────┘
```

#### **Information Display**
- **Primary**: Dancer name
- **Secondary**: Existing tags and notes
- **No new information**: Keep dancer cards simple and familiar

### Smart Defaults

#### **Context-Aware Defaults**
- **New Event**: "Active" (attended in last 6 months)
- **Weekly Social**: "Very Active" (3+ events in 6 months)
- **Monthly Event**: "Active" (1+ events in 6 months)
- **Annual Festival**: "Core Community" (5+ events in year)

## User Scenarios & Use Cases

### Scenario 1: Organizing Weekly Social with Long History
**Context**: You have 5+ years of dance history with 200+ dancers, but only 30-40 are currently active

**User Journey**:
1. Opens "Add Dancers" for weekly social
2. Sees default: "Very Active" (3+ events in 6 months)
3. List shows only 25 currently active dancers instead of 200
4. Quickly selects 15 regular attendees from the focused list
5. Done in 30 seconds instead of scrolling through 200 names

**Value**: Avoids the frustration of seeing 160+ inactive dancers who haven't attended in months/years

### Scenario 2: Planning Monthly Event with Mixed Attendance
**Context**: You have dancers who used to attend regularly but now come sporadically

**User Journey**:
1. Opens "Add Dancers" for monthly event
2. Uses "Active" (1+ events in 6 months) to see recent attendees
3. Finds 45 dancers who attended something recently
4. Reviews their last attendance dates to identify truly active vs. occasional
5. Selects 20 dancers likely to attend this month

**Value**: Focuses on dancers who are still engaged, not those who stopped coming years ago

### Scenario 3: Festival Planning with Legacy Dancers
**Context**: You want to invite both current regulars and some legacy dancers who might return

**User Journey**:
1. Opens "Add Dancers" for annual festival
2. Starts with "Core Community" (5+ events in year) to see current regulars
3. Finds 20 highly active dancers
4. Switches to "All Dancers" to see legacy dancers
5. Selects 15 current regulars + 5 legacy dancers who might return

**Value**: Balances current community with historical relationships

### Scenario 4: Class Planning with Inactive Students
**Context**: You have many former students who haven't attended classes in months/years

**User Journey**:
1. Opens "Add Dancers" for advanced class
2. Uses "Recent" (1+ events in 3 months) to see truly current students
3. Finds only 8 students who attended recently
4. Avoids the confusion of seeing 50+ inactive former students
5. Focuses on the 8 who are actually engaged

**Value**: Prevents adding inactive students who won't show up

### Scenario 5: Last-Minute Event with Current Community
**Context**: You need to quickly find dancers who are actually coming to events now

**User Journey**:
1. Opens "Add Dancers" for tomorrow's event
2. Uses "Very Active" (3+ events in 6 months) to see current regulars
3. Finds 18 dancers who attend regularly
4. Quickly identifies the most likely attendees
5. Sends targeted invitations to engaged dancers

**Value**: Maximizes attendance by focusing on currently active dancers

## Activity Level Definitions

### **All Dancers**
- **Criteria**: No filtering - shows all 200+ dancers
- **Use Case**: When you want to see everyone, including inactive legacy dancers
- **Best For**: Special events, reconnecting with old dancers, comprehensive planning

### **Active**
- **Criteria**: Attended 1+ events in last 6 months
- **Use Case**: See dancers who have attended something recently
- **Best For**: Monthly events, general planning, avoiding completely inactive dancers

### **Very Active**
- **Criteria**: Attended 3+ events in last 6 months
- **Use Case**: Focus on current regular attendees
- **Best For**: Weekly socials, regular classes, events that need reliable attendance

### **Core Community**
- **Criteria**: Attended 5+ events in last year
- **Use Case**: Identify your most engaged current dancers
- **Best For**: Important events, festivals, when you need guaranteed attendance

### **Recent**
- **Criteria**: Attended 1+ events in last 3 months
- **Use Case**: See only currently active dancers
- **Best For**: Last-minute events, current planning, avoiding seasonal dropouts

## Smart Suggestions

When no results match current filter:
```
┌─────────────────────────────────────────────────────────┐
│ No dancers match your criteria                         │
│                                                         │
│ Try: [Active] - Broader activity level                 │
│      [All Dancers] - Show everyone                     │
└─────────────────────────────────────────────────────────┘
```

## User Interface Guidelines

### Visual Design Principles
- **Simplicity**: Single dropdown filter
- **Clarity**: Clear activity level descriptions
- **Efficiency**: One-click filter changes
- **Feedback**: Immediate results update

### Accessibility Features
- **Screen Reader Support**: Proper ARIA labels
- **Keyboard Navigation**: Full keyboard accessibility
- **High Contrast**: Clear visual hierarchy

### Responsive Design
- **Mobile**: Compact filter layout
- **Tablet**: Standard filter layout
- **Desktop**: Full-width filter panel

## Success Metrics

### User Engagement
- **Filter Usage Rate**: % of users who use the filter
- **Time to Selection**: Average time to find and select dancers
- **User Satisfaction**: Reduced frustration scores

### Business Impact
- **Event Success Rate**: Improved attendance at events
- **Planning Efficiency**: Faster event preparation
- **Dancer Discovery**: More relevant dancer selections

## Implementation Phases

### Phase 1: Core Filtering (MVP)
**Features**:
- Single activity level filter
- 5 activity levels (All, Active, Very Active, Core Community, Recent)
- Real-time results
- Smart defaults

**Timeline**: 1-2 weeks

### Phase 2: Enhanced UX
**Features**:
- Activity badges on dancer cards
- Improved visual design
- Performance optimizations

**Timeline**: 1 week

## User Testing Plan

### Usability Testing
- **Task Completion**: Can users find specific dancers?
- **Time Measurement**: How long does filtering take?
- **Satisfaction**: Do users find the feature helpful?

### A/B Testing
- **Default Activity Level**: Test different default settings
- **Activity Level Names**: Test different naming conventions

## Conclusion

This simplified dancer filtering feature provides immediate value by helping users quickly find the most relevant dancers based on their activity level. By combining recency and frequency into intuitive activity levels, users can focus on what matters most - finding dancers who are likely to attend their events.

The single-filter approach is much simpler to understand and use, while still providing the core benefit of intelligent dancer discovery. 