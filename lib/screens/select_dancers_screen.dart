import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../database/database.dart';
import '../services/dancer_service.dart';
import '../services/ranking_service.dart';

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
  bool _showOnlyUnranked = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _addSelectedDancers() async {
    if (_selectedDancerIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one dancer'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final rankingService =
          Provider.of<RankingService>(context, listen: false);

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
          reason: 'Added during planning',
        );
      }

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Added ${_selectedDancerIds.length} dancers to event ranking'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding dancers: $e'),
            backgroundColor: Colors.red,
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
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
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
          // Search and Filter Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
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
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        title: const Text('Show only unranked dancers'),
                        value: _showOnlyUnranked,
                        onChanged: (value) {
                          setState(() {
                            _showOnlyUnranked = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
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
                        const Icon(Icons.people, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No dancers found matching "$_searchQuery"'
                              : _showOnlyUnranked
                                  ? 'All dancers are already ranked for this event'
                                  : 'No dancers available',
                          style:
                              const TextStyle(fontSize: 18, color: Colors.grey),
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
                    final hasRanking = dancer.hasRanking;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: CheckboxListTile(
                        title: Text(
                          dancer.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (dancer.notes != null &&
                                dancer.notes!.isNotEmpty)
                              Text(
                                dancer.notes!,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            if (hasRanking)
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 16, color: Colors.blue),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Already ranked: ${dancer.rankName}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        value: isSelected,
                        onChanged: hasRanking
                            ? null
                            : (bool? value) {
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
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
    return dancerService.getDancersForEvent(widget.eventId);
  }

  List<DancerWithEventInfo> _filterDancers(List<DancerWithEventInfo> dancers) {
    var filtered = dancers;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((dancer) {
        final name = dancer.name.toLowerCase();
        final notes = (dancer.notes ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || notes.contains(query);
      }).toList();
    }

    // Filter to show only unranked dancers if the option is enabled
    if (_showOnlyUnranked) {
      filtered = filtered.where((dancer) => !dancer.hasRanking).toList();
    }

    return filtered;
  }
}
