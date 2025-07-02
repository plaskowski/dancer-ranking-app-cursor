
## Milestone 2

Milestone scope:
UX improvement to core journeys from Milestone 1.

Planned improvements:
- merge persons records
  - rationale: same person can be mention under different names and nicks in the imported history
- inteligent dancers suggestions
  - by default show those I danced with more than one in last 3 months
  - a switch to show all
- introduce settings screen that will contain all the less relevant screens as tabs
- [X] screen to edit scores dictionary
  - edit name
  - edit scores order
  - merge scores
    - rationale: in the imported history I used different names for similar scores in different events
- app state management (maybe it is enough to handle this at SQLite file level?)
  - an option to reset app database
  - an option to backup app database to a file
  - an option to restore the app database from a file
- add new “Dancer history” screen
  - purpose: review our dances history to aid ranking decisions
