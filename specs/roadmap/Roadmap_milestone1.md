
## Milestone 1

Milestone scope:
A working android app, where I can import dancers (with tags and notes) and historical events (with attendants, dance info, impressions and scores)
and then use it to plan future events.

What is needed:
- ✅ support putting tags on persons (see feature_TagsOnPersons.md for spec)
- ✅ import dancers (with tags and notes)
- ✅ import historical events (with attendances full data)
  - create missing dancers
- support putting a score on a present person in the event
  - have a scores dictionary for that (they should have a global order)
  - one can assign score independently from their status
  - support scores in events import (create missing)
- have an info when I first met given person
  - either as explicit date set on dancer or calulated at runtime as the date of our first dance
  - on current and summary tab indicate that I first met them at that party
  - the historical data will can contain this information so support importing that attendance info
- new summary tab in event screen
  - it will contain a list of attendances, grouped by the score
  - it will allow to edit the score and impression
