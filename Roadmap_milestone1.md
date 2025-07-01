
## Milestone 1

Milestone scope:
A working android app, where I can import dancers (with tags and notes) and historical events (with attendants, dance info, impressions and scores)
and then use it to plan future events.

What is needed:
- ✅ support putting tags on persons (see feature_TagsOnPersons.md for spec)
- ✅ import dancers (with tags and notes)
- ✅ import historical events (with attendances full data)
  - create missing dancers
  - create missing scores
- support putting a score on a present person in the event
  - have a scores dictionary for that (they should have a global order)
  - one can assign score independently from their status
  - support scores in events import
- have an info when I first met given person
  - either as explicit date set on dancer or calulated at runtime as the date of our first dance
  - on current and summary tab indicate that I first met them at that party
  - the historical data will can contain this information so support importing that attendance info
- new summary tab in event screen
  - it will contain a list of attendances, grouped by the score
  - it will allow to edit the score and impression

## Milestone 2

Milestone scope:
UX improvement to core journeys from Milestone 1.

Planned improvements:
- merge persons records
  - rationale: same person can be mention under different names and nicks in the imported history
- inteligent dancers suggestions
  - by default show those I danced with more than one in last 3 months
  - a switch to show all
- screen to edit scores dictionary
  - edit name
  - edit scores order
  - merge scores
    - rationale: in the imported history I used different names for similar scores in different events
- introduce settings screen that will contain all the less relevant screens as tabs
- app state management (maybe it is enough to handle this at SQLite file level?)
  - an option to reset app database
  - an option to backup app database to a file
  - an option to restore the app database from a file