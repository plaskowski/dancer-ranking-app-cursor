import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/dancer/dancer_tag_service.dart';
import '../../../services/dancer_service.dart';
import '../../../services/ranking_service.dart';
import '../../../theme/theme_extensions.dart';
import '../../../widgets/tag_filter_chips.dart';

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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = false;

  // New tag filtering state
  int? _selectedTagId; // null = show all

  @override
  void dispose() {
    _searchController.dispose();
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
      final rankingService = Provider.of<RankingService>(context, listen: false);

      // Get the default rank (Neutral - ordinal 3)
      final defaultRank = await rankingService.getDefaultRank();
      if (defaultRank == null) {
        throw Exception('Default rank not found');
      }

      // Add ranking for each selected dancer
      for (final dancerId in _selectedDancerIds) {
        await rankingService.setRanking(
          eventId: widget.eventId,
          dancerId: dancerId,
          rankId: defaultRank.id,
        );
      }

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${_selectedDancerIds.length} dancers to event ranking'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
          // Tag Filters Section
          TagFilterChips(
            selectedTagId: _selectedTagId,
            onTagChanged: _onTagChanged,
          ),

          // Search Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search dancers',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
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
          ? FloatingActionButton.extended(
              onPressed: _isLoading ? null : _addSelectedDancers,
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
              label: Text(_isLoading ? 'Adding...' : 'Add Selected'),
            )
          : null,
    );
  }

  Future<List<DancerWithEventInfo>> _getDancersForSelection() async {
    final dancerService = Provider.of<DancerService>(context, listen: false);
    final dancerTagService = Provider.of<DancerTagService>(context, listen: false);

    // If tag is selected, use tag-filtered method
    if (_selectedTagId != null) {
      return dancerTagService.getUnrankedDancersForEventByTag(widget.eventId, _selectedTagId!);
    } else {
      // Use existing method for all unranked dancers
      return dancerService.getUnrankedDancersForEvent(widget.eventId);
    }
  }

  List<DancerWithEventInfo> _filterDancers(List<DancerWithEventInfo> dancers) {
    var filtered = dancers;

    // Tag filtering is handled in _getDancersForSelection()
    // Only apply text search here

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((dancer) {
        final name = dancer.name.toLowerCase();
        final notes = (dancer.notes ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || notes.contains(query);
      }).toList();
    }

    return filtered;
  }
}
