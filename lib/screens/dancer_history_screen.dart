import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/dancer/dancer_event_service.dart';
import '../services/dancer/dancer_models.dart';
import '../utils/action_logger.dart';

class DancerHistoryScreen extends StatefulWidget {
  final int dancerId;
  final String dancerName;

  const DancerHistoryScreen({
    super.key,
    required this.dancerId,
    required this.dancerName,
  });

  @override
  State<DancerHistoryScreen> createState() => _DancerHistoryScreenState();
}

class _DancerHistoryScreenState extends State<DancerHistoryScreen> {
  late DancerEventService _dancerEventService;
  List<DancerRecentHistory>? _history;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _dancerEventService = DancerEventService(
      Provider.of<AppDatabase>(context, listen: false),
    );
    _loadHistory();

    ActionLogger.logUserAction('DancerHistoryScreen', 'screen_opened', {
      'dancerId': widget.dancerId,
      'dancerName': widget.dancerName,
    });
  }

  @override
  void dispose() {
    ActionLogger.logUserAction('DancerHistoryScreen', 'screen_closed', {
      'dancerId': widget.dancerId,
      'dancerName': widget.dancerName,
    });
    super.dispose();
  }

  Future<void> _loadHistory() async {
    try {
      final history =
          await _dancerEventService.getRecentHistory(widget.dancerId);

      if (mounted) {
        setState(() {
          _history = history;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading history: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dancerName),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _history == null || _history!.isEmpty
              ? const Center(
                  child: Text(
                    'No event history found',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _history!.length,
                  itemBuilder: (context, index) {
                    final event = _history![index];
                    return _buildEventItem(event);
                  },
                ),
    );
  }

  Widget _buildEventItem(DancerRecentHistory event) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final formattedDate = dateFormat.format(event.eventDate);

    // Format status and score
    final statusIcon = event.danced ? '☑' : '☐';
    final scoreText = event.scoreName != null ? '${event.scoreName}' : '';
    final impressionText = event.impression ?? '';

    // Build the content line: Status • Score • "Impression"
    final List<String> parts = [];
    if (scoreText.isNotEmpty) {
      parts.add(scoreText);
    }
    if (impressionText.isNotEmpty) {
      parts.add('"$impressionText"');
    }
    final contentLine = parts.join(' • ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event name and date
          Text(
            '$formattedDate - ${event.eventName}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          // Status, score, and impression
          Text(
            '$statusIcon $contentLine',
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
