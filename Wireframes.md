# Dancer Ranking App - Wireframes

## 📱 **Home Screen Wireframe**

```
┌─────────────────────────────────┐
│  ← Dancer Ranking          👥   │ ← App bar
├─────────────────────────────────┤
│                                 │
│  📅 Upcoming Events             │
│  ┌─────────────────────────────┐ │
│  │ 🔵 Salsa Night             │ │
│  │    Dec 15, 2024            │ │
│  │                         →  │ │
│  └─────────────────────────────┘ │
│  ┌─────────────────────────────┐ │
│  │ 🔵 Bachata Workshop        │ │
│  │    Dec 20, 2024            │ │
│  │                         →  │ │
│  └─────────────────────────────┘ │
│                                 │
│  📚 Past Events                 │
│  ┌─────────────────────────────┐ │
│  │ ⚫ Kizomba Party           │ │
│  │    Dec 10, 2024            │ │
│  │                         →  │ │
│  └─────────────────────────────┘ │
│                                 │
├─────────────────────────────────┤
│               ➕                │ ← FAB (Add Event)
└─────────────────────────────────┘
```

## 📱 **Create Event Screen**

```
┌─────────────────────────────────┐
│  ← Create Event                 │
├─────────────────────────────────┤
│                                 │
│  Event Name *                   │
│  ┌─────────────────────────────┐ │
│  │ Salsa Night                 │ │
│  └─────────────────────────────┘ │
│                                 │
│  📅 Event Date                  │
│  ┌─────────────────────────────┐ │
│  │ 📅 Dec 15, 2024            │ │
│  │ [Change Date]               │ │
│  └─────────────────────────────┘ │
│                                 │
│                                 │
│                                 │
│                                 │
│                                 │
│                                 │
│  ┌─────────────────────────────┐ │
│  │        CREATE EVENT         │ │
│  └─────────────────────────────┘ │
└─────────────────────────────────┘
```

## 📱 **Event Screen - Planning Tab**

```
┌─────────────────────────────────┐
│  ← Salsa Night                 │ ← Back only
├─────────────────────────────────┤
│ Planning │ Present             │ ← Tabs
├─────────────────────────────────┤
│                                 │
│  Really want to dance           │
│  ┌─────────────────────────────┐ │
│  │ Maria Santos ✓              │ │ ← ✓ = present
│  │ "Great leader"              │ │
│  └─────────────────────────────┘ │
│                                 │
│  Nice style                     │
│  ┌─────────────────────────────┐ │
│  │ Carlos Rodriguez            │ │
│  │ "Smooth dancer"             │ │
│  └─────────────────────────────┘ │
│                                 │
│  No ranking yet                 │
│  ┌─────────────────────────────┐ │
│  │ Ana Lopez ✓                 │ │
│  └─────────────────────────────┘ │
│  ┌─────────────────────────────┐ │
│  │ David Kim                   │ │
│  └─────────────────────────────┘ │
├─────────────────────────────────┤
│               ➕                │ ← FAB (Add Dancer)
└─────────────────────────────────┘
```

## 📱 **Event Screen - Present Tab (Ranked Sections)**

```
┌─────────────────────────────────┐
│  ← Salsa Night                 │
├─────────────────────────────────┤
│ Planning │ Present             │
├─────────────────────────────────┤
│                                 │
│  Really want to dance           │
│  ┌─────────────────────────────┐ │
│  │ Maria Santos                │ │
│  │ "Great leader"              │ │
│  └─────────────────────────────┘ │
│                                 │
│  Would like to dance            │
│  ┌─────────────────────────────┐ │
│  │ Sofia Menendez              │ │
│  │ "Smooth follow"             │ │
│  │ 💃 Danced!                  │ │
│  └─────────────────────────────┘ │
│                                 │
│  No ranking yet                 │
│  ┌─────────────────────────────┐ │
│  │ David Kim                   │ │
│  └─────────────────────────────┘ │
├─────────────────────────────────┤
│               ➕                │ ← FAB (Add Dancer)
└─────────────────────────────────┘
```

## 📱 **Dancers Screen (Master List)**

```
┌─────────────────────────────────┐
│  ← Dancers                      │
├─────────────────────────────────┤
│  🔍 Search dancers...           │
├─────────────────────────────────┤
│                                 │
│  All Dancers (4)                │
│  ┌─────────────────────────────┐ │
│  │ 👤 M  Maria Santos          │ │
│  │       "Great lead, very     │ │
│  │        experienced"         │ │
│  │                          ⋮  │ │
│  └─────────────────────────────┘ │
│  ┌─────────────────────────────┐ │
│  │ 👤 C  Carlos Rodriguez      │ │
│  │       "Nice style, good     │ │
│  │        musicality"          │ │
│  │                          ⋮  │ │
│  └─────────────────────────────┘ │
│  ┌─────────────────────────────┐ │
│  │ 👤 A  Ana Lopez             │ │
│  │       No notes yet          │ │
│  │                          ⋮  │ │
│  └─────────────────────────────┘ │
├─────────────────────────────────┤
│               ➕                │ ← FAB (Add Dancer)
└─────────────────────────────────┘
```

## 📱 **Dancer Actions Dialog**

```
┌─────────────────────────────────┐
│  Maria Santos                   │
├─────────────────────────────────┤
│                                 │
│  ┌─────────────────────────────┐ │
│  │  🏷️  Set/Edit Ranking       │ │
│  └─────────────────────────────┘ │
│                                 │
│  ┌─────────────────────────────┐ │
│  │  ✓   Mark Present           │ │
│  └─────────────────────────────┘ │
│                                 │
│  ┌─────────────────────────────┐ │
│  │  💃  Record Dance           │ │
│  └─────────────────────────────┘ │
│                                 │
│  ┌─────────────────────────────┐ │
│  │  ✏️  Edit general note       │ │
│  └─────────────────────────────┘ │
│                                 │
│               [Cancel]          │
└─────────────────────────────────┘
```

## 📱 **Ranking Dialog**

```
┌─────────────────────────────────┐
│  Rank Maria Santos              │
├─────────────────────────────────┤
│                                 │
│  How eager are you to dance     │
│  with this person?              │
│                                 │
│  Rank Options:                  │
│                                 │
│  ⚪ Really want to dance        │
│  ⚪ Would like to dance         │
│  ⚫ Neutral / Default           │ ← selected
│  ⚪ Maybe later                 │
│  ⚪ Not really interested       │
│                                 │
│  Reason (optional):             │
│  ┌─────────────────────────────┐ │
│  │ Looking amazing tonight!    │ │
│  │ Great energy and style.     │ │
│  │                             │ │
│  └─────────────────────────────┘ │
│                                 │
│  Last updated: 8:35 PM          │
│                                 │
│  [Cancel]          [Set Ranking]│
└─────────────────────────────────┘
```

## 📱 **Add New Dancer Dialog (With "Already Danced")**

```
┌─────────────────────────────────┐
│  Add New Dancer                 │
├─────────────────────────────────┤
│                                 │
│  Name *                         │
│  ┌─────────────────────────────┐ │
│  │ Sofia Menendez              │ │
│  └─────────────────────────────┘ │
│                                 │
│  Notes (optional)               │
│  ┌─────────────────────────────┐ │
│  │ Met at salsa class last     │ │
│  │ month. Very skilled.        │ │
│  └─────────────────────────────┘ │
│                                 │
│  ☑️ Already danced with this    │ ← NEW FEATURE
│     person                      │
│                                 │
│  Impression (optional)          │ ← Shows when checked
│  ┌─────────────────────────────┐ │
│  │ Fantastic follow! Very      │ │
│  │ smooth and responsive.      │ │
│  │ Would definitely dance      │ │
│  │ again.                      │ │
│  └─────────────────────────────┘ │
│                                 │
│  [Cancel]           [Add Dancer]│
└─────────────────────────────────┘
```

## 📱 **Dance Recording Dialog**

```
┌─────────────────────────────────┐
│  Dance with Maria Santos        │
├─────────────────────────────────┤
│                                 │
│  Record that you danced with    │
│  this person.                   │
│                                 │
│  Impression (optional):         │
│  ┌─────────────────────────────┐ │
│  │ Amazing dance! Great        │ │
│  │ connection and she picked   │ │
│  │ up on all my leads         │ │
│  │ perfectly.                  │ │
│  └─────────────────────────────┘ │
│                                 │
│  ⚠️  Already danced with        │
│      Maria tonight!             │ │
│                                 │
│  [Cancel]        [Record Dance] │
└─────────────────────────────────┘
```

## 🎨 **Excalidraw Recreation Tips**

### **Elements to Use:**
- **Rectangles**: Phone frames, cards, buttons
- **Text**: All labels and content
- **Lines**: Separators and borders
- **Icons**: ⭐👤💃🏷️➕📅🔍
- **Hand-drawn style**: Excalidraw's specialty!

### **Suggested Colors:**
- **Background**: Light gray (#f8f9fa)
- **Present dancers**: Light green (#d4edda)
- **High rankings**: Gold/yellow (#fff3cd)
- **Buttons**: Blue outlines (#007bff)
- **Cards**: White (#ffffff)

### **Layout Guidelines:**
- **Phone width**: ~320px
- **Card height**: ~80-100px
- **Button height**: ~40px
- **Margins**: 16px from edges
- **Tab height**: 48px

### **Navigation Arrows:**
- Use arrows to show navigation flow between screens
- Color-code different user paths
- Add labels for key interactions

### **Key UI Changes:**
- **Simplified tabs**: Only Planning and Present (no Ranked tab)
- **Android FAB**: Add dancer button moved to bottom-right floating action button
- **Clean design**: Removed icons, simplified text, removed unnecessary info
- **Rank sections**: Present tab organized by ranking levels instead of separate ranked tab

To recreate in Excalidraw:
1. Go to excalidraw.com
2. Create a new drawing
3. Start with phone frame rectangles
4. Add text and icons from the wireframes above
5. Use hand-drawn style for a sketchy, approachable look

## 🎯 **Interaction Patterns**

### **Dancer Card Interactions**
- **Tap on dancer card** → Open dancer actions dialog
- **Tap "Set/Edit Ranking"** → Open ranking dialog
- **Tap "Mark Present"** → Add to present list (Planning tab)
- **Tap "Record Dance"** → Open dance recording dialog
- **Tap "Edit general note"** → Edit dancer's notes 