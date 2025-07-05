import 'package:flutter/material.dart';

import '../utils/action_logger.dart';

/// A reusable simple selection dialog component
/// Used for dialogs that show a list of options with one-tap selection
class SimpleSelectionDialog<T> extends StatefulWidget {
  final String title;
  final List<T> items;
  final String Function(T item) itemTitle;
  final bool Function(T item)? isSelected;
  final Future<void> Function(T item) onItemSelected;
  final Future<void> Function()? onCancel;
  final bool isLoading;
  final String? cancelButtonText;
  final String? logPrefix;

  const SimpleSelectionDialog({
    super.key,
    required this.title,
    required this.items,
    required this.itemTitle,
    this.isSelected,
    required this.onItemSelected,
    this.onCancel,
    this.isLoading = false,
    this.cancelButtonText,
    this.logPrefix,
  });

  @override
  State<SimpleSelectionDialog<T>> createState() => _SimpleSelectionDialogState<T>();
}

class _SimpleSelectionDialogState<T> extends State<SimpleSelectionDialog<T>> {
  @override
  void initState() {
    super.initState();

    if (widget.logPrefix != null) {
      ActionLogger.logUserAction(widget.logPrefix!, 'dialog_opened', {
        'title': widget.title,
        'itemsCount': widget.items.length,
      });
    }
  }

  Future<void> _handleItemSelected(T item) async {
    if (widget.logPrefix != null) {
      ActionLogger.logUserAction(widget.logPrefix!, 'item_selected', {
        'title': widget.title,
        'itemTitle': widget.itemTitle(item),
      });
    }

    try {
      await widget.onItemSelected(item);
    } catch (e) {
      if (widget.logPrefix != null) {
        ActionLogger.logError('${widget.logPrefix!}._handleItemSelected', e.toString());
      }
      rethrow;
    }
  }

  void _handleCancel() {
    if (widget.logPrefix != null) {
      ActionLogger.logUserAction(widget.logPrefix!, 'dialog_cancelled', {
        'title': widget.title,
      });
    }

    if (widget.onCancel != null) {
      widget.onCancel!();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: widget.isLoading
              ? const SizedBox(
                  height: 100,
                  child: Center(child: CircularProgressIndicator()),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: _handleCancel,
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Items List
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 300, // Limit height to prevent overflow
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: widget.items.map((item) {
                            final isSelected = widget.isSelected?.call(item) ?? false;

                            return ListTile(
                              leading: Icon(
                                isSelected ? Icons.check_circle : Icons.circle_outlined,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              title: Text(
                                widget.itemTitle(item),
                                style: TextStyle(
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              onTap: () => _handleItemSelected(item),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    // Cancel Button
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: _handleCancel,
                            child: Text(widget.cancelButtonText ?? 'Cancel'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
