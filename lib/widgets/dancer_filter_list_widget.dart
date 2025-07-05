import 'dart:async';

import 'package:flutter/material.dart';

import '../models/dancer_with_tags.dart';
import 'simplified_tag_filter.dart';

class DancerFilterListWidget extends StatefulWidget {
  final String title;
  final String infoMessage;
  final Future<List<DancerWithTags>> Function(
      List<int> tagIds, String searchQuery) getDancers;
  final Widget Function(DancerWithTags dancer) buildDancerTile;
  final Widget? Function(List<DancerWithTags> dancers)? buildEmptyState;
  final bool showInfoBanner;

  const DancerFilterListWidget({
    super.key,
    required this.title,
    required this.infoMessage,
    required this.getDancers,
    required this.buildDancerTile,
    this.buildEmptyState,
    this.showInfoBanner = true,
  });

  @override
  State<DancerFilterListWidget> createState() => _DancerFilterListWidgetState();
}

class _DancerFilterListWidgetState extends State<DancerFilterListWidget> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Simplified Filter Section
            SimplifiedTagFilter(
              selectedTagIds: _selectedTagIds,
              onTagsChanged: _onTagsChanged,
              onSearchChanged: _onSearchChanged,
            ),

            // Dancers List (with info block inside scroll)
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Info Banner (now scrollable)
                  if (widget.showInfoBanner)
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.infoMessage,
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
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
      ),
    );
  }

  List<Widget> _buildDancerList(BuildContext context) {
    return [
      FutureBuilder<List<DancerWithTags>>(
        key: ValueKey('${_selectedTagIds.toString()}_$_searchQuery'),
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
            if (widget.buildEmptyState != null) {
              final customEmptyState = widget.buildEmptyState!(allDancers);
              if (customEmptyState != null) {
                return customEmptyState;
              }
            }

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
                    _selectedTagIds.isNotEmpty
                        ? 'No dancers found with current filters'
                        : 'No available dancers',
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _selectedTagIds.isNotEmpty
                        ? 'Try different search terms or clear filters'
                        : 'No dancers available',
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
