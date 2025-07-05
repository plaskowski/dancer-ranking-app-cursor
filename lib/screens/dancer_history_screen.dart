import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/dancer/dancer_event_service.dart';
import '../services/dancer/dancer_models.dart';
import '../utils/action_logger.dart';
import '../widgets/extract_dance_record_dialog.dart';

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
  List<DancerRecentHistory> _history = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _dancerEventService = DancerEventService(
      Provider.of<AppDatabase>(context, listen: false),
    );
    _loadHistory();

    // Add scroll listener for load more functionality
    _scrollController.addListener(_onScroll);

    ActionLogger.logUserAction('DancerHistoryScreen', 'screen_opened', {
      'dancerId': widget.dancerId,
      'dancerName': widget.dancerName,
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    ActionLogger.logUserAction('DancerHistoryScreen', 'screen_closed', {
      'dancerId': widget.dancerId,
      'dancerName': widget.dancerName,
    });
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreHistory();
    }
  }

  Future<void> _loadHistory() async {
    try {
      final history =
          await _dancerEventService.getRecentHistory(widget.dancerId);

      if (mounted) {
        setState(() {
          _history = history;
          _isLoading = false;
          _hasMoreData =
              history.length >= 20; // If we got 20 items, there might be more
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

  Future<void> _loadMoreHistory() async {
    if (_isLoadingMore || !_hasMoreData || _history.isEmpty) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final lastEvent = _history.last;
      final moreHistory = await _dancerEventService.getMoreHistory(
        widget.dancerId,
        lastEvent.eventDate,
      );

      if (mounted) {
        setState(() {
          _history.addAll(moreHistory);
          _isLoadingMore = false;
          _hasMoreData = moreHistory.length >=
              20; // If we got 20 items, there might be more
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading more history: $e'),
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
          : _history.isEmpty
              ? const Center(
                  child: Text(
                    'No event history found',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _history.length + (_hasMoreData ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _history.length) {
                      // Show loading indicator at the bottom
                      return _isLoadingMore
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : const SizedBox.shrink();
                    }

                    final event = _history[index];
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

    return GestureDetector(
      onTap: () => _showContextMenu(event),
      child: Padding(
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
      ),
    );
  }

  void _showContextMenu(DancerRecentHistory event) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                event.eventName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.call_split),
                title: const Text('Separate record'),
                subtitle: const Text('Extract as one-time person'),
                onTap: () {
                  Navigator.pop(context);
                  _extractDanceRecord(event);
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _extractDanceRecord(DancerRecentHistory event) {
    ExtractDanceRecordDialog.show(
      context,
      attendanceId: event.attendanceId,
      dancerName: widget.dancerName,
      eventName: event.eventName,
      eventDate: event.eventDate,
      impression: event.impression,
      scoreName: event.scoreName,
    ).then((_) {
      // Refresh the history after extraction
      _loadHistory();
    });
  }
}
