import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/attendance_service.dart';
import '../services/dancer_service.dart';
import '../theme/theme_extensions.dart';

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _markDancerPresent(int dancerId, String dancerName) async {
    try {
      final attendanceService = Provider.of<AttendanceService>(context, listen: false);

      await attendanceService.markPresent(widget.eventId, dancerId);

      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$dancerName marked as present'),
            backgroundColor: context.danceTheme.success,
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
      body: Column(
        children: [
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

          // Info Banner
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
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

          const SizedBox(height: 16),

          // Dancers List
          Expanded(
            child: FutureBuilder<List<DancerWithEventInfo>>(
              future: _getAvailableDancers(),
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
                        Icon(
                          Icons.person_search,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty ? 'No available dancers' : 'No dancers found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isEmpty
                              ? 'All unranked dancers are already present or ranked!'
                              : 'Try a different search term',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
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

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(
                          dancer.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: dancer.notes != null && dancer.notes!.isNotEmpty
                            ? Text(
                                dancer.notes!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              )
                            : null,
                        trailing: ElevatedButton.icon(
                          onPressed: () => _markDancerPresent(dancer.id, dancer.name),
                          icon: const Icon(Icons.location_on, size: 18),
                          label: const Text('Mark Present'),
                        ),
                        onTap: () => _markDancerPresent(dancer.id, dancer.name),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<DancerWithEventInfo>> _getAvailableDancers() async {
    final dancerService = Provider.of<DancerService>(context, listen: false);

    // Get unranked and absent dancers for this event (dancers not ranked and not present)
    return dancerService.getUnrankedDancersForEvent(widget.eventId);
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
