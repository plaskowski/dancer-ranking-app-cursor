import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/import_models.dart';
import '../services/event_import_service.dart';
import '../utils/action_logger.dart';
import '../utils/toast_helper.dart';
import 'import/event_data_preview_step.dart';
import 'import/event_file_selection_step.dart';
import 'import/event_results_step.dart';

/// Main dialog for importing events from JSON files
/// Provides a simplified 3-step guided import process
class ImportEventsDialog extends StatefulWidget {
  const ImportEventsDialog({super.key});

  @override
  State<ImportEventsDialog> createState() => _ImportEventsDialogState();
}

class _ImportEventsDialogState extends State<ImportEventsDialog> {
  int _currentStep = 0;
  bool _isLoading = false;

  // Import state
  List<File> _selectedFiles = [];
  List<EventImportResult> _parseResults = [];
  EventImportSummary? _importResults;

  // Progress tracking
  double _importProgress = 0.0;
  String _currentOperation = '';

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Import Events'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.help_outline),
              onPressed: _showHelpDialog,
              tooltip: 'Import Help',
            ),
          ],
        ),
        body: Column(
          children: [
            // Stepper
            Expanded(
              child: Stepper(
                currentStep: _currentStep,
                controlsBuilder: _buildStepControls,
                onStepTapped: _canNavigateToStep,
                steps: [
                  Step(
                    title: const Text('Select Files'),
                    content: EventFileSelectionStep(
                      selectedFiles: _selectedFiles,
                      onFilesSelected: _onFilesSelected,
                      onFilesClear: _onFilesClear,
                      isLoading: _isLoading,
                    ),
                    isActive: _currentStep == 0,
                  ),
                  Step(
                    title: const Text('Preview Data'),
                    content: _buildPreviewContent(),
                    isActive: _currentStep == 1,
                  ),
                  Step(
                    title: const Text('Results'),
                    content: EventResultsStep(
                      results: _importResults,
                      progress: _importProgress,
                      currentOperation: _currentOperation,
                      isImporting: _isLoading,
                    ),
                    isActive: _currentStep == 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewContent() {
    if (_parseResults.isEmpty) {
      return const Center(
        child: Text('No data to preview. Please select and parse files first.'),
      );
    }

    // Check if all files are valid
    final allValid = _parseResults.every((result) => result.isValid);
    if (!allValid) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'File Errors',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          ..._parseResults.expand((result) => result.errors.map((error) => Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          error,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ))),
        ],
      );
    }

    // Combine all events and show combined preview
    final allEvents = _parseResults.expand((result) => result.events).toList();
    final combinedResult = EventImportResult(
      events: allEvents,
      errors: [],
      isValid: true,
      summary: _getCombinedSummary(),
    );

    return EventDataPreviewStep(
      parseResult: combinedResult,
      isLoading: _isLoading,
    );
  }

  EventImportSummary? _getCombinedSummary() {
    if (_parseResults.isEmpty) return null;

    final allEvents = _parseResults.expand((result) => result.events).toList();
    final allSummaries = _parseResults.where((result) => result.summary != null).map((result) => result.summary!);

    if (allSummaries.isEmpty) return null;

    return EventImportSummary(
      eventsProcessed: allEvents.length,
      eventsCreated: allSummaries.fold(0, (sum, summary) => sum + summary.eventsCreated),
      eventsSkipped: allSummaries.fold(0, (sum, summary) => sum + summary.eventsSkipped),
      attendancesCreated: allSummaries.fold(0, (sum, summary) => sum + summary.attendancesCreated),
      dancersCreated: allSummaries.fold(0, (sum, summary) => sum + summary.dancersCreated),
      scoresCreated: allSummaries.fold(0, (sum, summary) => sum + summary.scoresCreated),
      scoreAssignments: allSummaries.fold(0, (sum, summary) => sum + summary.scoreAssignments),
      errors: 0,
      errorMessages: [],
      skippedEvents: allSummaries.expand((summary) => summary.skippedEvents).toList(),
      createdScoreNames: allSummaries.expand((summary) => summary.createdScoreNames).toList(),
      eventAnalyses: allSummaries.expand((summary) => summary.eventAnalyses).toList(),
    );
  }

  Widget _buildStepControls(BuildContext context, ControlsDetails details) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          if (details.stepIndex > 0)
            OutlinedButton(
              onPressed: _isLoading ? null : details.onStepCancel,
              child: const Text('Previous'),
            ),
          const SizedBox(width: 8),
          if (_canProceedFromCurrentStep())
            ElevatedButton(
              onPressed: _isLoading ? null : () => _proceedToNextStep(details),
              child: _getNextButtonText(),
            ),
          if (_currentStep == 2) ...[
            // Results step - show both "Import more files" and "Close" buttons
            ElevatedButton.icon(
              onPressed: () => _resetToFileSelection(),
              icon: const Icon(Icons.file_upload),
              label: const Text('Import more files'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Close'),
            ),
          ],
        ],
      ),
    );
  }

  bool _canNavigateToStep(int step) {
    if (_isLoading) return false;

    switch (step) {
      case 0:
        return true;
      case 1:
        return _selectedFiles.isNotEmpty;
      case 2:
        return _importResults != null;
      default:
        return false;
    }
  }

  bool _canProceedFromCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _selectedFiles.isNotEmpty;
      case 1:
        return _parseResults.isNotEmpty && _parseResults.every((result) => result.isValid);
      case 2:
        return false; // Results is final step
      default:
        return false;
    }
  }

  Widget _getNextButtonText() {
    switch (_currentStep) {
      case 0:
        return _isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Preview');
      case 1:
        return _isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Import');
      default:
        return const Text('Next');
    }
  }

  Future<void> _proceedToNextStep(ControlsDetails details) async {
    switch (_currentStep) {
      case 0:
        await _parseFiles();
        break;
      case 1:
        await _performImport();
        break;
    }
  }

  void _onFilesSelected(List<File> files) {
    setState(() {
      _selectedFiles = files;
      _parseResults = [];
      _importResults = null;
    });
  }

  void _onFilesClear() {
    setState(() {
      _selectedFiles = [];
      _parseResults = [];
      _importResults = null;
    });
  }

  void _resetToFileSelection() {
    setState(() {
      _currentStep = 0;
      _selectedFiles = [];
      _parseResults = [];
      _importResults = null;
      _importProgress = 0.0;
      _currentOperation = '';
    });
  }

  Future<void> _parseFiles() async {
    if (_selectedFiles.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final eventImportService = Provider.of<EventImportService>(context, listen: false);
      final results = <EventImportResult>[];

      for (final file in _selectedFiles) {
        try {
          final jsonContent = await file.readAsString();
          final result = await eventImportService.parseAndValidateFile(jsonContent);
          results.add(result);
        } catch (e) {
          // Create error result for this file
          results.add(EventImportResult.failure(
            errors: [e.toString()],
          ));
        }
      }

      setState(() {
        _parseResults = results;
        _currentStep = 1;
      });
    } catch (e) {
      ToastHelper.showError(context, 'Error parsing files: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _performImport() async {
    if (_parseResults.isEmpty) return;

    setState(() {
      _isLoading = true;
      _importProgress = 0.0;
      _currentOperation = 'Starting import...';
    });

    try {
      final eventImportService = Provider.of<EventImportService>(context, listen: false);

      // Combine all valid events from all files
      final allEvents = <ImportableEvent>[];
      final allErrors = <String>[];

      for (final result in _parseResults) {
        if (result.isValid) {
          allEvents.addAll(result.events);
        } else {
          allErrors.addAll(result.errors);
        }
      }

      if (allEvents.isEmpty) {
        throw Exception('No valid events found in any of the selected files.');
      }

      // Import all events directly (no need to re-parse)
      final totalEvents = allEvents.length;

      final importResult = await eventImportService.importEvents(
        allEvents,
        const EventImportOptions(),
      );

      setState(() {
        _importResults = importResult;
        _currentStep = 2;
        _importProgress = 1.0;
        _currentOperation = 'Import completed';
      });

      ActionLogger.logUserAction('ImportEventsDialog', 'import_completed', {
        'totalFiles': _selectedFiles.length,
        'totalEvents': totalEvents,
        'importedEvents': importResult.eventsCreated,
        'skippedEvents': importResult.eventsSkipped,
        'newDancers': importResult.dancersCreated,
      });
    } catch (e) {
      ToastHelper.showError(context, 'Error importing events: $e');
      ActionLogger.logError('ImportEventsDialog._performImport', e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Event Import Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'How to import events:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('1. Select one or more JSON files containing event data'),
              Text('2. Review the preview to ensure data is correct'),
              Text('3. Click Import to add events to your database'),
              SizedBox(height: 16),
              Text(
                'File format requirements:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• JSON format only'),
              Text('• Maximum 5 MB per file'),
              Text('• Required fields: name, date, attendances'),
              Text('• Date format: YYYY-MM-DD'),
              Text('• Duplicate events are automatically skipped'),
              Text('• Missing dancers are automatically created'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
