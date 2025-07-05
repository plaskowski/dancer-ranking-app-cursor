import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/dancer_with_tags.dart';
import '../../../services/ranking_service.dart';
import '../../../widgets/simplified_tag_filter.dart';
import 'event_dancer_selection_mixin.dart';

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

class _SelectDancersScreenState extends State<SelectDancersScreen> with EventDancerSelectionMixin {
  bool _isLoading = false;

  @override
  int get eventId => widget.eventId;

  Future<void> _addDancerToEvent(int dancerId, String dancerName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final rankingService = Provider.of<RankingService>(context, listen: false);
      await rankingService.setRankNeutral(widget.eventId, dancerId);

      if (mounted) {
        showSuccessMessage('$dancerName added to event');
        triggerRefresh();

        // Return true to indicate dancers were added (this will trigger refresh in Planning tab)
        Navigator.pop(context, true);
      }
    } catch (e) {
      showErrorMessage('Error adding dancer to event: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildDancerTile(DancerWithTags dancer) {
    return Card(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      child: ListTile(
        title: Text(
          dancer.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: dancer.notes != null && dancer.notes!.isNotEmpty ? Text(dancer.notes!) : null,
        trailing: ElevatedButton(
          onPressed: _isLoading ? null : () => _addDancerToEvent(dancer.id, dancer.name),
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Add to Event'),
        ),
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
            Navigator.pop(context, false);
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
      ),
      body: _SelectDancersFilterWidget(
        eventId: widget.eventId,
        getDancers: getAvailableDancers,
        buildDancerTile: _buildDancerTile,
        refreshKey: refreshKey,
      ),
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
