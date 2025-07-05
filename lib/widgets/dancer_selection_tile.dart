import 'package:flutter/material.dart';

import '../models/dancer_with_tags.dart';

/// A reusable tile widget for dancer selection screens
class DancerSelectionTile extends StatelessWidget {
  final DancerWithTags dancer;
  final String buttonText;
  final VoidCallback? onPressed;
  final bool isLoading;

  const DancerSelectionTile({
    super.key,
    required this.dancer,
    required this.buttonText,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: ListTile(
        title: Text(
          dancer.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: dancer.notes != null && dancer.notes!.isNotEmpty ? Text(dancer.notes!) : null,
        trailing: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(buttonText),
        ),
      ),
    );
  }
}
