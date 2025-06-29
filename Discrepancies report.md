
# Discrepancies Report (between spec and impl)

1. CRITICAL: FAB Behavior Mismatch
Specification says:
Planning Tab FAB: Opens Select Dancers Screen
Present Tab FAB: Opens Add Dancer Dialog (create new dancers)
Implementation currently:
FAB always opens Select Dancers Screen regardless of active tab
Location: lib/screens/event_screen.dart line 81-99
2. Planning Tab Missing Mark Present Context Action
Specification says:
Quick context action: Blue location icon button for absent dancers → instant "Mark Present"
Implementation status:
I added this earlier but need to verify it's working properly
3. "Ranked Tab" Reference in Specification
Specification mentions:
"Ranked tab shows best rank ordinal first based on current rankings" (Key Features section)
Implementation reality:
Only has Planning and Present tabs, no separate "Ranked" tab