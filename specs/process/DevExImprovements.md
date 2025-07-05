
## Cursor based development improvements

# Most urgent
- allow it to delete .dart and .md files
- autosave?

# Later
- Ability to run user stories for regression testing
- Automated testing before marking tasks as done
- User acceptance testing protocols
- Add a rule for the workflow to write down the mistakes that were made by cursor and add a cursor rule that will prevent it in the future
- rule to always pick up only one task
- how to keep the UX patterns consistent
- if I can make it use automated user stories validation it could run on its own for long time
  - it would be great to make it record the screens (as screenshots or video) when running these tests so I can review them
  - they also will be useful for project documentation
- rule to refactor code to new files
- rule to add actions tracking to new code
- a way to run flutter run so that it closes the terminal tab when it ends
- after coming up with the design ask it to validate it against existing UX patterns in the app
- keep a separte human-only todolist file to not lost your toughts chain
- close all editor windows after commit
- don't edit dot files directly, write down changes to a separate file I can review first
- save the reasoning I provided for decisions
- split the impl work to front and backend tasks and use two agents?
- make the second-line started apps in different color (same for IDE)
- don't open modified files (I don't read them either way)
- auto-commit todo files after 1 minute of inactivity
- keep up-to-date ASCII wireframes
- auto-save todo file 
- a way to instruct the macOS app to auto-navigate to given screen (to test faster, via CMD arg)
- auto-close non-pinned editors after 2 min idle time
- need better way to sync two lines
- MCP tool to run app that connects to a running run configuration in IDE
- don't put new files into main directory to avoid clutter
- prevent generating tech spec until I agree on feature and UX spec
- write the long output to file so I can comment on it, save it for later and track it's changes
- how to have separate configs for workspaces (e.g. title bar color)
- codebase has to be cohesive and modular to avoid conflicts between agents lines
- If the agent ask for choice it should present buttons for them
- changelog as separate small files to avoid conflicts between agent lines
- use native patterns (like reactive updates)
- automation that let you drive initial navigation via CLI arg
- way to release versions with changelog (how to have only meaningful changes summarized)

# Hard ones
- increase the 25 tool calls limit

# Solved

## Cursor Cheatsheet
- always open Markdown files in preview
  - add vscode.markdown.preview.editor in "Preferences: Open Settings (UI)" > "editor assoc"
- second cursor
  - https://egghead.io/launch-multiple-cursor-composer-ai-agents-to-work-in-parallel~y1q56

## Remember
- DB migration
- update wireframes
- ..

## Przemyslenia
Bez szans zeby moc mergowac zmiany roznych agentow kiedy pisza low level code