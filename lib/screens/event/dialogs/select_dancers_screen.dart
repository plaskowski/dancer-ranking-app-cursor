import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../screens/event/event_screen.dart';
import '../../../services/attendance_service.dart';
import '../../../services/dancer/dancer_filter_service.dart';
import '../../../services/dancer_service.dart';
import '../../../theme/theme_extensions.dart';
import '../../../utils/action_logger.dart';
import '../../../widgets/safe_fab.dart';
import '../../../widgets/simplified_tag_filter.dart';

class SelectDancersScreen extends StatefulWidget {
  final int eventId;
  final String eventName;

  const SelectDancersScreen({
    super.key,
    required this.eventId,
    required this.eventName,
  });

  @override
  State<SelectDancersScreen> createState() => _SelectDancersScreenState();
}

class _SelectDancersScreenState extends State<SelectDancersScreen> {
  final Set<int> _selectedDancerIds = <int>{};
  String _searchQuery = '';
  bool _isLoading = false;
  int _refreshKey = 0; // Add refresh key for reactive updates

  // New tag filtering state
  int? _selectedTagId; // null = show all

  @override
  void dispose() {
    super.dispose();
  }

  void _onTagChanged(int? tagId) {
    setState(() {
      _selectedTagId = tagId;
    });
  }

  Future<void> _addSelectedDancers() async {
    if (_selectedDancerIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one dancer'),
          backgroundColor: context.danceTheme.warning,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Add dancers to event without assigning any rank
      // Users can manually assign ranks later if desired
      final attendanceService = Provider.of<AttendanceService>(context, listen: false);

      for (final dancerId in _selectedDancerIds) {
        await attendanceService.markPresent(widget.eventId, dancerId);
      }

      if (mounted) {
        // Store count before clearing selections
        final addedCount = _selectedDancerIds.length;

        // Clear selections and trigger refresh
        setState(() {
          _selectedDancerIds.clear();
          _refreshKey++; // Trigger reactive update
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added $addedCount dancers to event (no rank assigned)'),
            backgroundColor: context.danceTheme.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding dancers: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => EventScreen(
                  eventId: widget.eventId,
                  initialTab: 'planning',
                ),
              ),
            );
          },
        ),
        title: Column(
          children: [
            const Text('Select Dancers'),
            Text(
              widget.eventName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          if (_selectedDancerIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  '${_selectedDancerIds.length} selected',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SimplifiedTagFilter(
              selectedTagIds: _selectedTagId != null ? [_selectedTagId!] : [],
              onTagsChanged: (tagIds) {
                _onTagChanged(tagIds.isNotEmpty ? tagIds.first : null);
              },
              onSearchChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              searchHintText: 'Search dancers',
              initialSearchQuery: _searchQuery,
            ),
          ),

          // Dancers List
          Expanded(
            child: FutureBuilder<List<DancerWithEventInfo>>(
              key: ValueKey('${_searchQuery}_${_selectedTagId}_$_refreshKey'),
              future: _getDancersForSelection(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  ActionLogger.logError('SelectDancersScreen', 'stream_error', {
                    'eventId': widget.eventId,
                    'error': snapshot.error.toString(),
                    'stackTrace': snapshot.stackTrace?.toString(),
                  });
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Unable to load dancers',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please try again or contact support',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final allDancers = snapshot.data ?? [];
                final filteredDancers = _filterDancers(allDancers);

                if (filteredDancers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty || _selectedTagId != null
                              ? 'No dancers found with current filters'
                              : 'All dancers are already ranked for this event',
                          style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredDancers.length,
                  itemBuilder: (context, index) {
                    final dancer = filteredDancers[index];
                    final isSelected = _selectedDancerIds.contains(dancer.id);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: CheckboxListTile(
                        title: Text(
                          dancer.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: dancer.notes != null && dancer.notes!.isNotEmpty
                            ? Text(
                                dancer.notes!,
                                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                              )
                            : null,
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedDancerIds.add(dancer.id);
                            } else {
                              _selectedDancerIds.remove(dancer.id);
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedDancerIds.isNotEmpty
          ? SafeFAB(
              onPressed: _isLoading ? null : _addSelectedDancers,
              isExtended: true,
              label: Text(_isLoading ? 'Adding...' : 'Add Selected'),
              icon: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimary),
                      ),
                    )
                  : const Icon(Icons.check),
              child: const Icon(Icons.check), // Required but not used when isExtended is true
            )
          : null,
    );
  }

  Future<List<DancerWithEventInfo>> _getDancersForSelection() async {
    final filterService = DancerFilterService.of(context);
    return filterService.getUnrankedDancersForEvent(
      widget.eventId,
      tagId: _selectedTagId,
    );
  }

  List<DancerWithEventInfo> _filterDancers(List<DancerWithEventInfo> dancers) {
    final filterService = DancerFilterService.of(context);
    return filterService.filterDancersByTextEvent(dancers, _searchQuery);
  }
}
