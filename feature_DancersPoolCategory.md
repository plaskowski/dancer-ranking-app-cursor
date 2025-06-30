# Feature Specification: Dancers Pool Category

## 🎯 **Use Case: Managing Infrequent/One-time Dancers**

### **Problem Statement**
- **Current State**: All dancers appear equally in event planning, creating noise
- **Desired State**: Prioritize regular attendees while keeping track of infrequent ones
- **Core Need**: Reduce clutter without losing data on potential future regulars

## 💡 **Solution: Event-Specific Inclusion Lists (Option B)**

### **Core Concept**
Instead of trying to automatically categorize dancers, let the user actively choose which "pool" of dancers to consider for each event.

### **Dancer Pool Categories**

**1. Core/Regular Pool**
- Dancers you see frequently at events
- Your "go-to" list for most events
- Default suggestion pool for new events

**2. Extended/Occasional Pool** 
- Dancers you've met but see less frequently
- Include when you want broader options
- Good for larger events or when trying new combinations

**3. Everyone/Complete Pool**
- All dancers in your database
- Include one-time meets, inactive dancers, etc.
- Use when you want to be comprehensive or rediscover forgotten connections

### **Event Planning Workflow**

**Step 1: Choose Your Pool**
```
When creating/planning an event:
"Who should I consider for this event?"
[ ] Core dancers only (clean, focused list)
[ ] Core + Extended dancers (broader options)  
[ ] Everyone (complete database)

Default: Core dancers only
```

**Step 2: Smart Defaults by Event Context**
```
- Regular social events → Core dancers
- Special workshops → Core + Extended  
- Large parties → Everyone
- Intimate gatherings → Core dancers only

User can override defaults anytime
```

**Step 3: Remember Preferences**
```
System learns patterns:
- "Friday socials" → Usually core dancers
- "Monthly workshops" → Usually core + extended
- Auto-suggest based on similar past events
```

### **Dancer Management Interface**

**Pool Assignment**
```
Each dancer has a simple designation:
- "Core" - Always include in default suggestions
- "Extended" - Include when explicitly requested
- "Archive" - Keep in database but don't suggest

Easy bulk actions:
- "Move to Core" (promote)
- "Move to Extended" (demote)
- "Archive" (rarely used)
```

**Quick Pool Management**
```
Dedicated screen for pool management:
- Drag & drop between pools
- Search and filter
- Bulk select and move
- Visual indicators (last seen, events attended)
```

### **Event Planning UX Flow**

**Simple Mode (Default)**
```
1. Create event
2. See core dancers automatically
3. Select who to invite
4. Done!
```

**Expanded Mode (When Needed)**
```
1. Create event
2. Toggle "Include extended dancers"
3. Expanded list appears
4. Select from broader pool
5. Done!
```

**Comprehensive Mode (Rarely)**
```
1. Create event  
2. Toggle "Show everyone"
3. Full database visible
4. Search/filter as needed
5. Select and proceed
```

### **Key Benefits of This Approach**

**✅ No Historical Data Required**
- Works from day one
- User manually curates pools based on their knowledge

**✅ Full User Control**
- Never lose access to any dancer
- Choose exactly who to consider for each event

**✅ Reduces Cognitive Load**
- Start with focused list
- Expand only when needed
- Learn user's patterns over time

**✅ Flexible & Adaptive**
- Pools can evolve as relationships change
- Easy to promote/demote dancers
- Scales from small to large databases

### **Migration Strategy**

**For New Users:**
- All dancers start in "Extended" pool
- User manually promotes favorites to "Core"
- Gradually builds focused core list

**For Existing Users:**
- Smart initial assignment based on recent activity
- User refines the auto-assignments
- System learns preferences quickly

## 🎨 **User Stories**

**"I want to plan a regular Friday social"**
→ See core dancers, quick selection, done in 30 seconds

**"I want to try mixing things up this week"**  
→ Toggle extended dancers, see broader options, experiment

**"I'm organizing a big party and want to invite everyone I know"**
→ Toggle everyone, comprehensive view, invite widely

**"I met someone new and they're becoming a regular"**
→ Easy promote to core pool, now appears in default suggestions

**"Someone I used to dance with hasn't come in months"**
→ Move to extended pool, reduces clutter but keeps them available

## 📋 **Implementation Considerations**

### **Database Changes**
- Add `pool_category` field to dancers table (core/extended/archive)
- Add event preferences tracking
- Migration strategy for existing data

### **UI Components**
- Pool selection toggles in event planning
- Dancer pool management screen
- Bulk actions for pool management
- Visual indicators for pool membership

### **User Experience**
- Intuitive defaults based on event context
- Easy promotion/demotion workflows
- Clear visual distinction between pools
- Remembering user preferences per event type 