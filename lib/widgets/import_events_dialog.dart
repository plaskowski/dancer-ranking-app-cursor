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
  File? _selectedFile;
  EventImportResult? _parseResult;
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
                    title: const Text('Select File'),
                    content: EventFileSelectionStep(
                      selectedFile: _selectedFile,
                      onFileSelected: _onFileSelected,
                      onFileClear: _onFileClear,
                      isLoading: _isLoading,
                    ),
                    isActive: _currentStep == 0,
                  ),
                  Step(
                    title: const Text('Preview Data'),
                    content: EventDataPreviewStep(
                      parseResult: _parseResult,
                      isLoading: _isLoading,
                    ),
                    isActive: _currentStep == 1,
                  ),
                  Step(
                    title: const Text('Results'),
                    content: EventResultsStep(
                      results: _importResults,
                      progress: _importProgress,
                      currentOperation: _currentOperation,
                      isImporting: _isLoading,
                      onImportAnother: _onImportAnother,
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
          if (_currentStep == 2) // Results step
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Close'),
            ),
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
        return _selectedFile != null;
      case 2:
        return _importResults != null;
      default:
        return false;
    }
  }

  bool _canProceedFromCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _selectedFile != null;
      case 1:
        return _parseResult != null && _parseResult!.isValid;
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
        await _parseFile();
        break;
      case 1:
        await _performImport();
        break;
    }
  }

  void _onFileSelected(File file) {
    setState(() {
      _selectedFile = file;
      _parseResult = null;
      _importResults = null;
    });
  }

  void _onFileClear() {
    setState(() {
      _selectedFile = null;
      _parseResult = null;
      _importResults = null;
      _currentStep = 0;
    });
  }

  Future<void> _parseFile() async {
    if (_selectedFile == null) return;

    setState(() {
      _isLoading = true;
      _currentOperation = 'Parsing JSON file...';
    });

    try {
      ActionLogger.logAction('ImportEventsDialog', 'parse_file_started', {
        'fileName': _selectedFile!.path.split('/').last,
        'fileSize': await _selectedFile!.length(),
      });

      final content = await _selectedFile!.readAsString();
      final service = context.read<EventImportService>();
      final result = await service.validateImportFile(content);

      setState(() {
        _parseResult = result;
        _currentOperation = '';
      });

      if (result.isValid) {
        setState(() {
          _currentStep = 1;
        });
        ActionLogger.logAction('ImportEventsDialog', 'parse_file_success', {
          'eventsCount': result.events.length,
        });
      } else {
        ToastHelper.showError(
          context,
          'Invalid file format: ${result.errors.first}',
        );
        ActionLogger.logAction('ImportEventsDialog', 'parse_file_failed', {
          'errors': result.errors,
        });
      }
    } catch (e) {
      ToastHelper.showError(context, 'Failed to parse file: $e');
      ActionLogger.logError('ImportEventsDialog.parseFile', e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _performImport() async {
    if (_parseResult == null || !_parseResult!.isValid) return;

    setState(() {
      _isLoading = true;
      _currentOperation = 'Importing events...';
      _importProgress = 0.0;
    });

    try {
      ActionLogger.logAction('ImportEventsDialog', 'import_started', {
        'eventsCount': _parseResult!.events.length,
      });

      final content = await _selectedFile!.readAsString();
      final service = context.read<EventImportService>();

      // Simulate progress updates
      _updateProgress(0.2, 'Validating data...');
      await Future.delayed(const Duration(milliseconds: 200));

      _updateProgress(0.4, 'Processing events...');
      await Future.delayed(const Duration(milliseconds: 200));

      final summary = await service.importEventsFromJson(
        content,
        const EventImportOptions(),
      );

      _updateProgress(1.0, 'Import completed');

      setState(() {
        _importResults = summary;
        _currentStep = 2;
        _currentOperation = '';
      });

      if (summary.hasErrors) {
        ToastHelper.showWarning(
          context,
          'Import completed with ${summary.errors} errors',
        );
      } else {
        ToastHelper.showSuccess(
          context,
          'Successfully imported ${summary.eventsCreated} events',
        );
      }

      ActionLogger.logAction('ImportEventsDialog', 'import_completed', {
        'eventsCreated': summary.eventsCreated,
        'errors': summary.errors,
      });
    } catch (e) {
      ToastHelper.showError(context, 'Import failed: $e');
      ActionLogger.logError('ImportEventsDialog.performImport', e.toString());
    } finally {
      setState(() {
        _isLoading = false;
        _importProgress = 0.0;
      });
    }
  }

  void _updateProgress(double progress, String operation) {
    setState(() {
      _importProgress = progress;
      _currentOperation = operation;
    });
  }

  void _onImportAnother() {
    setState(() {
      _selectedFile = null;
      _parseResult = null;
      _importResults = null;
      _currentStep = 0;
      _importProgress = 0.0;
      _currentOperation = '';
    });
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Event Import Help'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Event Import JSON Format:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• Events with name, date (YYYY-MM-DD), and attendances'),
            Text('• Attendance statuses: present, served, left'),
            Text('• Optional impression for served status'),
            SizedBox(height: 16),
            Text('Automatic Behavior:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• Duplicate events are automatically skipped'),
            Text('• Missing dancers are automatically created'),
            Text('• Import is performed immediately'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
