import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/dancer_with_tags.dart';
import '../../../screens/event/event_screen.dart';
import '../../../services/attendance_service.dart';
import '../../../services/dancer/dancer_filter_service.dart';
import '../../../theme/theme_extensions.dart';
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
  bool _isLoading = false;
  int _refreshKey = 0; // Add refresh key for reactive updates

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

  Future<List<DancerWithTags>> _getAvailableDancers(List<int> tagIds, String searchQuery) async {
    final filterService = DancerFilterService.of(context);

    // Get dancers based on tag filtering
    List<DancerWithTags> dancers;
    if (tagIds.isNotEmpty) {
      // Use tag filtering when tags are selected
      dancers = await filterService.getAvailableDancersWithTagsForEvent(
        widget.eventId,
        tagIds: tagIds.toSet(),
      );
    } else {
      // Get all available dancers when no tags are selected
      dancers = await filterService.getAvailableDancersWithTagsForEvent(
        widget.eventId,
      );
    }

    // Apply search filtering if search query is provided
    if (searchQuery.isNotEmpty) {
      dancers = filterService.filterDancersByText(dancers, searchQuery);
    }

    return dancers;
  }

  Widget _buildDancerTile(DancerWithTags dancer) {
    final isSelected = _selectedDancerIds.contains(dancer.id);

    return Card(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: CheckboxListTile(
        title: Text(
          dancer.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: dancer.notes != null && dancer.notes!.isNotEmpty ? Text(dancer.notes!) : null,
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
      body: _SelectDancersFilterWidget(
        eventId: widget.eventId,
        getDancers: _getAvailableDancers,
        buildDancerTile: _buildDancerTile,
        refreshKey: _refreshKey,
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
}

class _SelectDancersFilterWidget extends StatefulWidget {
  final int eventId;
  final Future<List<DancerWithTags>> Function(List<int> tagIds, String searchQuery) getDancers;
  final Widget Function(DancerWithTags dancer) buildDancerTile;
  final int? refreshKey;

  const _SelectDancersFilterWidget({
    required this.eventId,
    required this.getDancers,
    required this.buildDancerTile,
    this.refreshKey,
  });

  @override
  State<_SelectDancersFilterWidget> createState() => _SelectDancersFilterWidgetState();
}

class _SelectDancersFilterWidgetState extends State<_SelectDancersFilterWidget> {
  List<int> _selectedTagIds = [];
  String _searchQuery = '';

  void _onTagsChanged(List<int> tagIds) {
    setState(() {
      _selectedTagIds = tagIds;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Simplified Filter Section
          SimplifiedTagFilter(
            selectedTagIds: _selectedTagIds,
            onTagsChanged: _onTagsChanged,
            onSearchChanged: _onSearchChanged,
          ),

          // Dancers List
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Info Banner
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
                          'Showing unranked and absent dancers only. Select multiple dancers to add to the event.',
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
                const SizedBox(height: 8),
                ..._buildDancerList(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDancerList(BuildContext context) {
    return [
      FutureBuilder<List<DancerWithTags>>(
        key: ValueKey('${_selectedTagIds.toString()}_$_searchQuery${widget.refreshKey ?? 0}'),
        future: widget.getDancers(_selectedTagIds, _searchQuery),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final allDancers = snapshot.data ?? [];

          if (allDancers.isEmpty) {
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
                    _selectedTagIds.isNotEmpty ? 'No dancers found with current filters' : 'No available dancers',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedTagIds.isNotEmpty ? 'Try different search terms or clear filters' : 'No dancers available',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: List.generate(allDancers.length, (index) {
              final dancer = allDancers[index];
              return widget.buildDancerTile(dancer);
            }),
          );
        },
      ),
    ];
  }
}
