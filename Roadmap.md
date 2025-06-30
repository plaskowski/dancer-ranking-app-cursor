# Dancer Ranking App - Roadmap

## Near-term Features (next few weeks)

- dancers pool category - see feature_DancersPoolCategory.md
- Tags on persons
  - ability to add tags to a person
  - ability to search by tag where we already search by person name
  - use-case: tag can express where I know the person from (dance class, dance school, regular party)
  - use-case: use tags to implement the "dancers pool category"
- CSV export for events and dancer data
- Data backup and restore functionality
- Statistical insights and trends
- migrate historical data from Diary
- export the party summary to the Diary
- Use emojis in Rank names
- Filter people by tags. Eg. tag about where I know them from in case I don't know or remember the name or #longTimeNoSee or #comesRarely
- in mass add in planning tab and add existing dancer dialog somehow filter out the dancers that come very rare or have not yet come for a long time
  - I won't backfill whole dancing history so I may need to set some info on the person
- People archival
  - they should stay in the past events but don't suggest them to be added
- Switch for filtering off dancers that 'left' in Present Tab
- rank emoji (so to present it alinged to right)

### Rejected ideas
- Event templates for recurring event types
  - I can just have an event with future date that serves as a template
- Dancers avatars/photos

## Long-term features (probably never)
- Internationalization support
- Smart suggestions based on dancing history

## Development Workflow Ideas

- Ability to run user stories for regression testing
- Automated testing before marking tasks as done
- User acceptance testing protocols
- Performance benchmarking tools
- Add a rule for the workflow to write down the mistakes that were made by cursor and add a cursor rule that will prevent it in the future
- rule to always pick up only one task
- how to keep the UX patterns consistent
- if I can make it use automated user stories validation it could run on its own for long time
  - it would be great to make it record the screens (as screenshots or video) when running these tests so I can review them
  - they also will be useful for project documentation
- increase the 25 tool calls limit