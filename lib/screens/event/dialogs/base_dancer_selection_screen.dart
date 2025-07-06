import 'package:flutter/material.dart';

import '../../../models/dancer_with_tags.dart';
import '../../../widgets/dancer_selection_tile.dart';
import '../../../widgets/simplified_tag_filter.dart';
import 'event_dancer_selection_mixin.dart';

/// Base class for dancer selection screens that share common UI patterns
class BaseDancerSelectionScreen extends StatefulWidget {
  final int eventId;
  final String eventName;
  final Future<void> Function(int dancerId, String dancerName) onDancerSelected;
  final String actionButtonText;
  final String infoMessage;
  final String screenTitle;
  final bool shouldCloseAfterSelection;
  final bool returnValueOnClose;

  const BaseDancerSelectionScreen({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.onDancerSelected,
    required this.actionButtonText,
    required this.infoMessage,
    required this.screenTitle,
    this.shouldCloseAfterSelection = false,
    this.returnValueOnClose = false,
  });

  @override
  State<BaseDancerSelectionScreen> createState() => _BaseDancerSelectionScreenState();
}

class _BaseDancerSelectionScreenState extends State<BaseDancerSelectionScreen> with EventDancerSelectionMixin {
  bool _isLoading = false;

  @override
  int get eventId => widget.eventId;

  Future<void> _handleDancerSelection(int dancerId, String dancerName) async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onDancerSelected(dancerId, dancerName);

      if (mounted) {
        if (widget.shouldCloseAfterSelection) {
          Navigator.pop(context, widget.returnValueOnClose);
        }
      }
    } catch (e) {
      showErrorMessage('Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildDancerTile(DancerWithTags dancer) {
    return DancerSelectionTile(
      dancer: dancer,
      buttonText: widget.actionButtonText,
      onPressed: () => _handleDancerSelection(dancer.id, dancer.name),
      isLoading: _isLoading,
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
            Text(widget.screenTitle),
            Text(
              widget.eventName,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: _DancerSelectionFilterWidget(
        eventId: widget.eventId,
        getDancers: getAvailableDancers,
        buildDancerTile: _buildDancerTile,
        refreshKey: refreshKey,
        infoMessage: widget.infoMessage,
      ),
    );
  }
}

/// Generic base class for dancer list screens with filtering and actions
class BaseDancerListScreen extends StatefulWidget {
  final String screenTitle;
  final Stream<List<DancerWithTags>> Function(List<int> tagIds, String searchQuery, [String? activityFilter])
      getDancers;
  final Widget Function(DancerWithTags dancer) buildDancerTile;
  final String? infoMessage;
  final Widget? floatingActionButton;
  final List<Widget>? appBarActions;

  const BaseDancerListScreen({
    super.key,
    required this.screenTitle,
    required this.getDancers,
    required this.buildDancerTile,
    this.infoMessage,
    this.floatingActionButton,
    this.appBarActions,
  });

  @override
  State<BaseDancerListScreen> createState() => _BaseDancerListScreenState();
}

class _BaseDancerListScreenState extends State<BaseDancerListScreen> {
  int _refreshKey = 0;

  void _triggerRefresh() {
    setState(() {
      _refreshKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.screenTitle),
        actions: widget.appBarActions,
      ),
      body: _DancerListFilterWidget(
        getDancers: widget.getDancers,
        buildDancerTile: widget.buildDancerTile,
        refreshKey: _refreshKey,
        infoMessage: widget.infoMessage,
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }
}

class _DancerSelectionFilterWidget extends StatefulWidget {
  final int eventId;
  final Future<List<DancerWithTags>> Function(List<int> tagIds, String searchQuery, [String? activityFilter])
      getDancers;
  final Widget Function(DancerWithTags dancer) buildDancerTile;
  final int? refreshKey;
  final String infoMessage;

  const _DancerSelectionFilterWidget({
    required this.eventId,
    required this.getDancers,
    required this.buildDancerTile,
    this.refreshKey,
    required this.infoMessage,
  });

  @override
  State<_DancerSelectionFilterWidget> createState() => _DancerSelectionFilterWidgetState();
}

class _DancerListFilterWidget extends StatefulWidget {
  final Stream<List<DancerWithTags>> Function(List<int> tagIds, String searchQuery, [String? activityFilter])
      getDancers;
  final Widget Function(DancerWithTags dancer) buildDancerTile;
  final int? refreshKey;
  final String? infoMessage;

  const _DancerListFilterWidget({
    required this.getDancers,
    required this.buildDancerTile,
    this.refreshKey,
    this.infoMessage,
  });

  @override
  State<_DancerListFilterWidget> createState() => _DancerListFilterWidgetState();
}

class _DancerSelectionFilterWidgetState extends State<_DancerSelectionFilterWidget> {
  List<int> _selectedTagIds = [];
  String _searchQuery = '';
  String _activityFilter = 'Regular';

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

  void _onActivityChanged(String activity) {
    setState(() {
      _activityFilter = activity;
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
            onActivityChanged: _onActivityChanged,
            initialActivityLevel: _activityFilter,
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
                          widget.infoMessage,
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
        key: ValueKey('${_selectedTagIds.toString()}_${_searchQuery}_$_activityFilter${widget.refreshKey ?? 0}'),
        future: widget.getDancers(_selectedTagIds, _searchQuery, _activityFilter),
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
                    _selectedTagIds.isNotEmpty || _activityFilter != 'Regular' 
                        ? 'No dancers found with current filters' 
                        : 'No regular dancers available',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedTagIds.isNotEmpty || _activityFilter != 'Regular' 
                        ? 'Try different search terms or clear filters' 
                        : 'Try changing activity level to "All"',
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

class _DancerListFilterWidgetState extends State<_DancerListFilterWidget> {
  List<int> _selectedTagIds = [];
  String _searchQuery = '';
  String _activityFilter = 'Regular';

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

  void _onActivityChanged(String activity) {
    setState(() {
      _activityFilter = activity;
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
            onActivityChanged: _onActivityChanged,
            initialActivityLevel: _activityFilter,
          ),

          // Dancers List
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Info Banner
                if (widget.infoMessage != null)
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
                            widget.infoMessage!,
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
      StreamBuilder<List<DancerWithTags>>(
        key: ValueKey('${_selectedTagIds.toString()}_${_searchQuery}_$_activityFilter${widget.refreshKey ?? 0}'),
        stream: widget.getDancers(_selectedTagIds, _searchQuery, _activityFilter),
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
                    Icons.people,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _selectedTagIds.isNotEmpty || _activityFilter != 'Regular' 
                        ? 'No dancers found with current filters' 
                        : 'No regular dancers yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedTagIds.isNotEmpty || _activityFilter != 'Regular' 
                        ? 'Try adjusting your filters' 
                        : 'Try changing activity level to "All" or add dancers',
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
