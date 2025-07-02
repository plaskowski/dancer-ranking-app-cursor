
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
- keep up-to-date wireframes
- auto-save todo file 

# Hard ones
- increase the 25 tool calls limit

# Solved

## Cursor Cheatsheet
- always open Markdown files in preview
  - add vscode.markdown.preview.editor in "Preferences: Open Settings (UI)" > "editor assoc"
- second cursor
  - https://egghead.io/launch-multiple-cursor-composer-ai-agents-to-work-in-parallel~y1q56