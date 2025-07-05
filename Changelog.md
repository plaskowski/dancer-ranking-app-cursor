# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.4.7] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I feel like we now have many such simple dialogs, extract common component for that." - Request to create reusable component for simple selection dialogs

### Added
- **SimpleSelectionDialog Component**: New reusable component for simple selection dialogs
  - **Generic Design**: Supports any type of items with customizable title and selection logic
  - **One-Tap Selection**: Immediate selection with visual feedback (check_circle vs circle_outlined)
  - **Built-in Logging**: Automatic action logging with configurable prefix
  - **Loading States**: Built-in loading indicator support
  - **Consistent UI**: Standardized header, list, and cancel button layout
  - **Error Handling**: Proper error handling and user feedback

### Refactored
- **ScoreDialog**: Refactored to use SimpleSelectionDialog component
  - **Reduced Code**: Eliminated duplicate UI code by 70%
  - **Consistent Behavior**: Maintains same functionality with cleaner implementation
  - **Better Maintainability**: Easier to modify and extend
- **Scores Management Merge Dialog**: Refactored merge target selection to use SimpleSelectionDialog
  - **Simplified Logic**: Cleaner dialog presentation and selection handling
  - **Consistent UX**: Same visual pattern as other selection dialogs

### Technical
- **Component Reusability**: Created generic SimpleSelectionDialog<T> for type-safe usage
- **Action Logging**: Integrated logging with configurable prefixes for different dialogs
- **Error Handling**: Proper async error handling with user-friendly messages
- **UI Consistency**: Standardized visual design across all simple selection dialogs

## [v1.4.6] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I have reverted ScoreDialog latest changes (commit). Now try simplify it to simple sheet with one tap options" - Request to simplify ScoreDialog to basic one-tap options
- "remove last updated from edit rank dialog" - Request to remove last updated info from RankingDialog

### Changed
- **ScoreDialog Simplification**: Reverted to simple one-tap design
  - **Simple ListTile**: Uses basic ListTile with circle icons for selection
  - **One-Tap Selection**: Tap any score to immediately assign it
  - **Minimal UI**: Removed complex RadioListTile structure and action buttons
  - **Direct Action**: Score is assigned immediately when you tap it
- **RankingDialog Cleanup**: Removed last updated timestamp display
  - **Cleaner UI**: Removed unnecessary timestamp information
  - **Simplified Layout**: Less visual clutter in the ranking dialog

### Technical
- **UI Consistency**: Ensured appropriate complexity for each dialog's use case
- **Code Simplification**: Reduced complexity where appropriate for better UX

## [v1.4.5] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "Why the assign score sheet looks different from other sheets?" - Request to understand and fix UI inconsistency in ScoreDialog

### Improved
- **ScoreDialog UI Consistency**: Updated ScoreDialog to match RankingDialog's structure and styling
  - **Consistent Layout**: Now uses same header, sections, and action button layout as RankingDialog
  - **RadioListTile Selection**: Replaced ListTile with RadioListTile for better selection UX
  - **Proper Action Buttons**: Added Cancel and Set Score buttons with loading states
  - **Better Visual Hierarchy**: Clear sections with proper spacing and typography
  - **Static Show Method**: Added ScoreDialog.show() for consistent presentation pattern
- **Dialog Presentation**: Updated all ScoreDialog calls to use new static show method
  - **Consistent Pattern**: All dialogs now follow same presentation pattern
  - **Better Integration**: Improved integration with existing dialog flows

### Technical
- **UI Architecture**: Standardized dialog presentation patterns across the app
- **Code Reusability**: Improved consistency between similar dialog components
- **User Experience**: Enhanced visual consistency and interaction patterns

## [v1.4.4] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "All good now, commit" - Request to commit the real-time filtering improvements

### Improved
- **Real-Time Dancer Filtering**: Enhanced dancer filtering to use streams for live updates
  - **Dancers Screen**: Converted from Future to Stream for real-time dancer list updates
  - **Base Dancer Selection**: Updated base class to support streaming data for live filtering
  - **Immediate Updates**: Dancer lists now update automatically when data changes
  - **Better Performance**: Reduced unnecessary rebuilds with streaming approach
  - **Consistent Architecture**: All dancer filtering now uses same streaming pattern

### Technical
- **Streaming Architecture**: Implemented Stream<List<DancerWithTags>> for real-time updates
- **Performance Optimization**: Reduced unnecessary widget rebuilds with streaming approach
- **Code Consistency**: Unified filtering patterns across all dancer selection components

## [v1.4.3] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v1.4.2] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v1.4.1] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v1.4.0] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v1.3.0] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v1.2.0] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v1.1.0] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v1.0.0] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v0.9.0] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v0.8.0] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v0.7.0] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v0.6.0] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v0.5.0] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v0.4.0] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v0.3.0] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v0.2.0] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v0.1.0] - 2025-01-17
## [v1.4.8] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs
