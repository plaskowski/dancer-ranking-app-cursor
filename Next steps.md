
What to do/fix next:
- ✅ can I mark the ranked absent dancer as present and danced with at the same time?
  → Added "Mark Present & Record Dance" combo action for absent dancers in Present tab
- ✅ when I mark the dancer as absent in planning tab the list does not get refreshed
  → **MAJOR IMPROVEMENT**: Converted to reactive streams architecture with Drift database observation
  → Replaced manual callback chains with StreamBuilder + watchDancersForEvent()
  → UI now automatically refreshes for ALL data changes (notes, rankings, attendance, etc.)
