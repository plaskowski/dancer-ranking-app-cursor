import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/import_models.dart';
import '../../services/dancer_import_service.dart';
import '../../utils/action_logger.dart';
import '../../utils/toast_helper.dart';
import 'data_preview_step.dart';
import 'file_selection_step.dart';
import 'import_options_step.dart';
import 'results_step.dart';

/// Main dialog for importing dancers from JSON files
/// Provides a step-by-step guided import process
class ImportDancersDialog extends StatefulWidget {
  const ImportDancersDialog({super.key});

  @override
  State<ImportDancersDialog> createState() => _ImportDancersDialogState();
}

class _ImportDancersDialogState extends State<ImportDancersDialog> {
  int _currentStep = 0;
  bool _isLoading = false;

  // Import state
  File? _selectedFile;
  DancerImportResult? _parseResult;
  List<DancerImportConflict> _conflicts = [];
  DancerImportOptions _options = const DancerImportOptions();
  DancerImportSummary? _importResults;

  // Progress tracking
  double _importProgress = 0.0;
  String _currentOperation = '';

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Import Dancers'),
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
                    content: FileSelectionStep(
                      selectedFile: _selectedFile,
                      onFileSelected: _onFileSelected,
                      onFileClear: _onFileClear,
                      isLoading: _isLoading,
                    ),
                    isActive: _currentStep == 0,
                  ),
                  Step(
                    title: const Text('Preview Data'),
                    content: DataPreviewStep(
                      parseResult: _parseResult,
                      conflicts: _conflicts,
                      isLoading: _isLoading,
                    ),
                    isActive: _currentStep == 1,
                  ),
                  Step(
                    title: const Text('Import Options'),
                    content: ImportOptionsStep(
                      options: _options,
                      conflicts: _conflicts,
                      onOptionsChanged: _onOptionsChanged,
                    ),
                    isActive: _currentStep == 2,
                  ),
                  Step(
                    title: const Text('Results'),
                    content: ResultsStep(
                      results: _importResults,
                      progress: _importProgress,
                      currentOperation: _currentOperation,
                      isImporting: _isLoading,
                      onViewImportedDancers: _onViewImportedDancers,
                      onImportAnother: _onImportAnother,
                    ),
                    isActive: _currentStep == 3,
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
          if (_currentStep == 3) // Results step
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
        return _parseResult != null && _parseResult!.isValid;
      case 3:
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
        return true; // Can always proceed from options
      case 3:
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
            : const Text('Parse File');
      case 1:
        return const Text('Configure');
      case 2:
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
        await _parseSelectedFile();
        break;
      case 1:
        await _validateImportData();
        break;
      case 2:
        await _performImport();
        break;
    }

    if (_canProceedFromCurrentStep()) {
      details.onStepContinue?.call();
    }
  }

  Future<void> _onFileSelected(File file) async {
    setState(() {
      _selectedFile = file;
      _parseResult = null;
      _conflicts = [];
      _importResults = null;
    });

    ActionLogger.logUserAction('ImportDancersDialog', 'file_selected', {
      'fileName': file.path.split('/').last,
      'fileSize': await file.length(),
    });
  }

  void _onFileClear() {
    setState(() {
      _selectedFile = null;
      _parseResult = null;
      _conflicts = [];
      _importResults = null;
      _currentStep = 0;
    });

    ActionLogger.logUserAction('ImportDancersDialog', 'file_cleared', {});
  }

  void _onOptionsChanged(DancerImportOptions options) {
    setState(() {
      _options = options;
    });
  }

  Future<void> _parseSelectedFile() async {
    if (_selectedFile == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final importService =
          Provider.of<DancerImportService>(context, listen: false);
      final content = await _selectedFile!.readAsString();

      final result = await importService.validateImportFile(content);

      setState(() {
        _parseResult = result;
        _currentStep = 1;
      });

      if (result.isValid) {
        ToastHelper.showSuccess(context,
            'File parsed successfully! Found ${result.dancers.length} dancers.');
      } else {
        ToastHelper.showError(
            context, 'File contains errors. Please review and fix.');
      }
    } catch (e) {
      ToastHelper.showError(context, 'Error parsing file: $e');
      ActionLogger.logError(
          'ImportDancersDialog._parseSelectedFile', e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _validateImportData() async {
    if (_parseResult == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Add conflict detection via import service
      // For now, proceed to options step

      setState(() {
        _currentStep = 2;
      });
    } catch (e) {
      ToastHelper.showError(context, 'Error validating data: $e');
      ActionLogger.logError(
          'ImportDancersDialog._validateImportData', e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _performImport() async {
    if (_selectedFile == null) return;

    setState(() {
      _isLoading = true;
      _importProgress = 0.0;
      _currentOperation = 'Starting import...';
    });

    try {
      final importService =
          Provider.of<DancerImportService>(context, listen: false);
      final content = await _selectedFile!.readAsString();

      setState(() {
        _currentOperation = 'Processing dancers...';
        _importProgress = 0.5;
      });

      final results =
          await importService.importDancersFromJson(content, _options);

      setState(() {
        _importResults = results;
        _currentStep = 3;
        _importProgress = 1.0;
        _currentOperation = 'Import completed';
      });

      if (results.isSuccessful) {
        ToastHelper.showSuccess(
            context, 'Successfully imported ${results.imported} dancers!');
      } else {
        ToastHelper.showWarning(
            context, 'Import completed with ${results.errors} errors.');
      }
    } catch (e) {
      ToastHelper.showError(context, 'Import failed: $e');
      ActionLogger.logError('ImportDancersDialog._performImport', e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onViewImportedDancers() {
    Navigator.of(context).pop(true);
    // The parent screen should refresh to show new dancers
  }

  void _onImportAnother() {
    setState(() {
      _selectedFile = null;
      _parseResult = null;
      _conflicts = [];
      _options = const DancerImportOptions();
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
        title: const Text('Import Help'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('JSON Format:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                '{\n'
                '  "dancers": [\n'
                '    {\n'
                '      "name": "Dancer Name",\n'
                '      "tags": ["tag1", "tag2"],\n'
                '      "notes": "Optional notes"\n'
                '    }\n'
                '  ]\n'
                '}',
                style: TextStyle(fontFamily: 'monospace'),
              ),
              SizedBox(height: 16),
              Text('Tips:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('• Maximum 1000 dancers per file'),
              Text('• Names must be unique'),
              Text('• Tags will be created automatically'),
              Text('• Notes are optional'),
            ],
          ),
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
