// This file is used by the human to track things that come up to their mind during working with Cursor Agent.
// Agent should never modify this file so not to overwrite the human entered content.

## Status
The app has all I need to start using it. :celebrate:

## Backlog

Right away:
- [x] add action to events import summary - "Import more files"
- [x] import many files at once
- [ ] (in progress) import more history
  - [ ] validate the counts against Diary text  <--- diary agent
  - [ ] validate all the new events files can be imported
  - [ ] extract a summary of my impression on event itself

Small improvements:
- persons import
  - [ ] introduce optional aliases list on dancers
  - [ ] use AI to extract all dancers names from the JSON files, sort them and deduplicate with aliases
- events import
  - [x] do the import preview right away after selecting a file (or dropping to drop zone)
  - [ ] have optional aliases list on dancers to reduce clean up effort after event history import
  - [ ] ...
- Add existing dancer dialog
  - [x] move info block into the scroll area to not take vertical space
  - [ ] ...
- "Add new dancer" dialog
  - [x] move "already danced" checkbox in above the tags section so I don't have to scroll through tags for it
  - [ ] "Tags" label collides with the impression field
  - [ ] ...
- home screen
  - [x] move the settings action to AppBar and remove dots
  - [ ] ...
-  Android
  - [ ] the FAB button is covered with bottom system bar
  - [x] use native android toasts
-  event screen
  - [x] edit ranking action does not make sense for past events
  - [x] summary screen > score group header - move counter as simple text in parenthesis instead of pill
  - [ ] make "Dance summary" have same style as the score group
  - [ ] set ranking causes error
  - [ ] ...
- docs
  - [ ] preambula o moim szacunku dla partnerek
  - [ ] ...
-  dancers screen
  - [x] add tag filter
  - [x] add both filter fields into scrollview so they don't take space
  - [ ] ...

Extract more historical data:
- [ ] regenerate file for 2024-08
- [ ] AloCubano z 2024-08
- [ ] extract earlier months

### Milestone 3
- filter people by tags. Eg. tag about where I know them from in case I don't know or remember the name or #longTimeNoSee or #comesRarely
- smart suggestions in add dancers dialog
