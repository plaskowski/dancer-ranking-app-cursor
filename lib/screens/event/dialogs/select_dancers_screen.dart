import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/dancer/dancer_filter_service.dart';
import '../../../services/dancer_service.dart';
import '../../../services/ranking_service.dart';
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
  String _searchQuery = '';
  bool _isLoading = false;

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
      // Add dancers to event with neutral ranking (not marked as present)
      // This allows them to appear in the Planning tab for further ranking adjustments
      final rankingService = Provider.of<RankingService>(context, listen: false);

      for (final dancerId in _selectedDancerIds) {
        await rankingService.setRankNeutral(widget.eventId, dancerId);
      }

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${_selectedDancerIds.length} dancers to event with neutral ranking'),
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
              future: _getDancersForSelection(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
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
