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
│  │    Dec 15, 2024 - 20:00    │ │
│  │    📍 Studio X          →  │ │
│  └─────────────────────────────┘ │
│  ┌─────────────────────────────┐ │
│  │ 🔵 Bachata Workshop        │ │
│  │    Dec 20, 2024 - 19:30    │ │
│  │    📍 Dance Center      →  │ │
│  └─────────────────────────────┘ │
│                                 │
│  📚 Past Events                 │
│  ┌─────────────────────────────┐ │
│  │ ⚫ Kizomba Party           │ │
│  │    Dec 10, 2024 - 21:00    │ │
│  │    📍 Club Z             →  │ │
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
│  Description (optional)         │
│  ┌─────────────────────────────┐ │
│  │ Weekly salsa social at      │ │
│  │ Studio X. Great music and   │ │
│  │ friendly atmosphere.        │ │
│  └─────────────────────────────┘ │
│                                 │
│  📅 Event Date & Time           │
│  ┌─────────────────────────────┐ │
│  │ 📅 Dec 15, 2024  🕐 20:00  │ │
│  │ [Change Date]   [Change Time]│ │
│  └─────────────────────────────┘ │
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
│  ← Salsa Night            👥 ➕ │ ← Back, Dancers, Add
├─────────────────────────────────┤
│ 📋Planning │ 👥Present │⭐Ranked │ ← Tabs
├─────────────────────────────────┤
│                                 │
│  All Dancers                    │
│  ┌─────────────────────────────┐ │
│  │ 👤 Maria Santos             │ │
│  │    ⭐⭐⭐⭐⭐ "Great leader"  │ │
│  │    ✅ Present               │ │
│  │    [🏷️Rank] [➕Add] [💃Dance] │ │
│  └─────────────────────────────┘ │
│  ┌─────────────────────────────┐ │
│  │ 👤 Carlos Rodriguez         │ │
│  │    ⭐⭐⭐ "Nice style"       │ │
│  │    ⚫ Not present           │ │
│  │    [🏷️Rank] [➕Add] [💃Dance] │ │
│  └─────────────────────────────┘ │
│  ┌─────────────────────────────┐ │
│  │ 👤 Ana Lopez                │ │
│  │    No ranking yet           │ │
│  │    ⚫ Not present           │ │
│  │    [🏷️Rank] [➕Add] [💃Dance] │ │
│  └─────────────────────────────┘ │
│                                 │
└─────────────────────────────────┘
```

## 📱 **Event Screen - Present Tab (Filtered View)**

```
┌─────────────────────────────────┐
│  ← Salsa Night            👥 ➕ │
├─────────────────────────────────┤
│ 📋Planning │👥Present │⭐Ranked │
├─────────────────────────────────┤
│                                 │
│  Present at Event (2)           │
│  ┌─────────────────────────────┐ │
│  │ 👤 Maria Santos             │ │
│  │    ⭐⭐⭐⭐⭐ "Great leader"  │ │
│  │    ✅ Arrived: 8:30 PM      │ │
│  │    [🏷️Edit] [💃Dance]       │ │
│  └─────────────────────────────┘ │
│  ┌─────────────────────────────┐ │
│  │ 👤 Sofia Menendez           │ │
│  │    No ranking yet           │ │
│  │    ✅ Arrived: 9:15 PM      │ │
│  │    💃 Danced!               │ │
│  │    [🏷️Rank] [💃Again?]      │ │
│  └─────────────────────────────┘ │
│                                 │
│  ⚫ Carlos (not present yet)     │
│                                 │
└─────────────────────────────────┘
```

## 📱 **Event Screen - Ranked Tab (Priority Order)**

```
┌─────────────────────────────────┐
│  ← Salsa Night            👥 ➕ │
├─────────────────────────────────┤
│ 📋Planning │ 👥Present │⭐Ranked │
├─────────────────────────────────┤
│                                 │
│  Priority Order (Present)       │
│  ┌─────────────────────────────┐ │
│  │ 🥇 Maria Santos             │ │
│  │    ⭐⭐⭐⭐⭐ "Great leader"  │ │
│  │    Updated: 8:35 PM         │ │
│  │    [🏷️Edit] [💃Dance]       │ │
│  └─────────────────────────────┘ │
│  ┌─────────────────────────────┐ │
│  │ 🥈 Sofia Menendez           │ │
│  │    ⭐⭐⭐⭐ "Smooth follow"   │ │
│  │    Updated: 9:20 PM         │ │
│  │    💃 Danced!               │ │
│  │    [🏷️Edit] [💃Again?]      │ │
│  └─────────────────────────────┘ │
│                                 │
│  📊 No other ranked dancers     │
│      present yet                │
│                                 │
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

## 📱 **Ranking Dialog**

```
┌─────────────────────────────────┐
│  Rank Maria Santos              │
├─────────────────────────────────┤
│                                 │
│  How eager are you to dance     │
│  with this person?              │
│                                 │
│  Eagerness Level:               │
│                                 │
│  ┌─┐ ┌─┐ ┌─┐ ┌─┐ ┌─┐            │
│  │⭐│ │⭐│ │⭐│ │⭐│ │⭐│            │
│  │1 │ │2 │ │3 │ │4 │ │5 │            │
│  └─┘ └─┘ └─┘ └─┘ └─┘            │
│              ↑ selected          │
│                                 │
│  "Really want to dance!"        │
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

To recreate in Excalidraw:
1. Go to excalidraw.com
2. Create a new drawing
3. Start with phone frame rectangles
4. Add text and icons from the wireframes above
5. Use hand-drawn style for a sketchy, approachable look 