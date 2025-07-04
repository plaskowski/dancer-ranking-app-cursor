import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/attendance_service.dart';
import '../../../services/dancer/dancer_tag_service.dart';
import '../../../services/dancer_service.dart';
import '../../../theme/theme_extensions.dart';

class AddExistingDancerScreen extends StatefulWidget {
  final int eventId;
  final String eventName;

  const AddExistingDancerScreen({
    super.key,
    required this.eventId,
    required this.eventName,
  });

  @override
  State<AddExistingDancerScreen> createState() => _AddExistingDancerScreenState();
}

class _AddExistingDancerScreenState extends State<AddExistingDancerScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // New filtering state
  List<int> _selectedTagIds = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onTagsChanged(List<int> tagIds) {
    setState(() {
      _selectedTagIds = tagIds;
    });
  }

  Future<void> _markDancerPresent(int dancerId, String dancerName) async {
    try {
      final attendanceService = Provider.of<AttendanceService>(context, listen: false);

      await attendanceService.markPresent(widget.eventId, dancerId);

      if (mounted) {
        // Show a brief success message without closing the screen
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$dancerName marked as present'),
            backgroundColor: context.danceTheme.success,
            duration: const Duration(seconds: 1), // Shorter duration for efficiency
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error marking dancer as present: $e'),
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
        title: Text('Add to ${widget.eventName}'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Simplified Filter Section
            SimplifiedTagFilter(
              selectedTagIds: _selectedTagIds,
              onTagsChanged: _onTagsChanged,
            ),

            // Search Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search available dancers',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintText: 'Search by name or notes...',
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            // Dancers List (with info block inside scroll)
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Info Banner (now scrollable)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Showing unranked and absent dancers only. Present dancers managed in Present tab.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Dancers List
                  const SizedBox(
                    height: 8,
                  ),
                  ..._buildDancerList(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDancerList(BuildContext context) {
    return [
      StreamBuilder<List<DancerWithEventInfo>>(
        stream: _getAvailableDancersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error: {snapshot.error}'));
          }

          final allDancers = snapshot.data ?? [];
          final filteredDancers = _filterDancers(allDancers);

          if (filteredDancers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_search,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isNotEmpty || _selectedTagIds.isNotEmpty
                        ? 'No dancers found with current filters'
                        : 'No available dancers',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _searchQuery.isNotEmpty || _selectedTagIds.isNotEmpty
                        ? 'Try different search terms or clear filters'
                        : 'All unranked dancers are already present or ranked!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: List.generate(filteredDancers.length, (index) {
              final dancer = filteredDancers[index];
              return Card(
                margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                child: ListTile(
                  title: Text(
                    dancer.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: dancer.notes != null && dancer.notes!.isNotEmpty ? Text(dancer.notes!) : null,
                  trailing: ElevatedButton(
                    onPressed: () => _markDancerPresent(dancer.id, dancer.name),
                    child: const Text('Mark Present'),
                  ),
                ),
              );
            }),
          );
        },
      ),
    ];
  }

  Stream<List<DancerWithEventInfo>> _getAvailableDancersStream() {
    final dancerService = Provider.of<DancerService>(context, listen: false);
    final dancerTagService = Provider.of<DancerTagService>(context, listen: false);

    if (_selectedTagIds.isNotEmpty) {
      // Use tag-filtered stream (for now, just use first tag)
      return dancerTagService.watchAvailableDancersForEventByTag(widget.eventId, _selectedTagIds.first);
    } else {
      // Use existing stream and filter to show only unranked and absent dancers
      return dancerService.watchDancersForEvent(widget.eventId).map((allDancers) {
        return allDancers.where((dancer) {
          // Show dancers who are NOT ranked (no rankName) AND NOT present (no attendanceMarkedAt)
          final isUnranked = dancer.rankName == null;
          final isAbsent = dancer.attendanceMarkedAt == null;
          return isUnranked && isAbsent;
        }).toList();
      });
    }
  }

  List<DancerWithEventInfo> _filterDancers(List<DancerWithEventInfo> dancers) {
    if (_searchQuery.isEmpty) {
      return dancers;
    }

    return dancers.where((dancer) {
      final name = dancer.name.toLowerCase();
      final notes = (dancer.notes ?? '').toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query) || notes.contains(query);
    }).toList();
  }
}
