import 'package:flutter/material.dart';
import '../data/mock_events.dart';
import '../models/event.dart';
import '../widgets/empty_state.dart';
import '../widgets/event_card.dart';
import 'event_details_screen.dart';

/// Main screen featuring Explore, Favorites, and My Events tabs
/// with integrated search, category filtering, and capacity management.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Master list of events maintained in memory during the app session
  late List<Event> _allEvents;

  // Navigation tab index: 0 = Explore, 1 = Favorites, 2 = My Events
  int _currentTabIndex = 0;

  // Search and filter state
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Available categories: "All" plus at least three distinct categories
  final List<String> _categories = [
    'All',
    'Technology',
    'Arts',
    'Sports',
    'Career',
  ];

  @override
  void initState() {
    super.initState();
    _allEvents = getInitialMockEvents();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  void _clearSearchAndFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedCategory = 'All';
    });
  }

  void _toggleFavorite(Event event) {
    setState(() {
      event.isFavorite = !event.isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          event.isFavorite
              ? 'Added "${event.title}" to favorites.'
              : 'Removed "${event.title}" from favorites.',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openDetails(Event event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventDetailsScreen(
          event: event,
          onStateChanged: () {
            setState(() {});
          },
        ),
      ),
    );
  }

  /// Filters events based on tab, title search, and selected category.
  List<Event> _getFilteredEvents() {
    // 1. Base list according to selected tab
    List<Event> baseList;
    if (_currentTabIndex == 1) {
      baseList = _allEvents.where((e) => e.isFavorite).toList();
    } else if (_currentTabIndex == 2) {
      baseList = _allEvents.where((e) => e.isJoined).toList();
    } else {
      baseList = _allEvents;
    }

    // 2. Apply category filter
    if (_selectedCategory != 'All') {
      baseList = baseList.where((e) => e.category == _selectedCategory).toList();
    }

    // 3. Apply search query: ignore letter case and surrounding spaces
    final cleanQuery = _searchQuery.trim().toLowerCase();
    if (cleanQuery.isNotEmpty) {
      baseList = baseList.where((e) {
        return e.title.toLowerCase().contains(cleanQuery);
      }).toList();
    }

    return baseList;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredEvents = _getFilteredEvents();

    final totalFavorites = _allEvents.where((e) => e.isFavorite).length;
    final totalJoined = _allEvents.where((e) => e.isJoined).length;

    final isSearchingOrFiltering =
        _searchQuery.trim().isNotEmpty || _selectedCategory != 'All';

    // Title according to active tab
    String tabTitle;
    if (_currentTabIndex == 1) {
      tabTitle = 'Favorites';
    } else if (_currentTabIndex == 2) {
      tabTitle = 'My Events';
    } else {
      tabTitle = 'Explore Campus Events';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tabTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // Total joined events counter chip in app bar
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Chip(
              avatar: const Icon(Icons.check_circle, size: 16, color: Colors.teal),
              label: Text(
                'Joined: $totalJoined',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header (Applies equally to Explore, Favorites, My Events)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            color: theme.colorScheme.surface,
            child: Column(
              children: [
                // Search Input Field
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search events by title...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            tooltip: 'Clear search',
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Category Filter Chips
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      return ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Match Count & Reset Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredEvents.length} event${filteredEvents.length == 1 ? '' : 's'} matching',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (isSearchingOrFiltering)
                  InkWell(
                    onTap: _clearSearchAndFilters,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                      child: Row(
                        children: [
                          Icon(Icons.filter_alt_off, size: 14, color: theme.colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            'Reset Filters',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Scrollable Event List or Empty State
          Expanded(
            child: filteredEvents.isEmpty
                ? _buildEmptyState(isSearchingOrFiltering)
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    itemCount: filteredEvents.length,
                    itemBuilder: (context, index) {
                      final event = filteredEvents[index];
                      return EventCard(
                        event: event,
                        onTap: () => _openDetails(event),
                        onFavoriteToggle: () => _toggleFavorite(event),
                      );
                    },
                  ),
          ),
        ],
      ),

      // Bottom Navigation Bar with 3 tabs
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTabIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: totalFavorites > 0
                ? Badge.count(
                    count: totalFavorites,
                    child: const Icon(Icons.favorite_outline),
                  )
                : const Icon(Icons.favorite_outline),
            selectedIcon: totalFavorites > 0
                ? Badge.count(
                    count: totalFavorites,
                    child: const Icon(Icons.favorite),
                  )
                : const Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: totalJoined > 0
                ? Badge.count(
                    count: totalJoined,
                    child: const Icon(Icons.event_available_outlined),
                  )
                : const Icon(Icons.event_available_outlined),
            selectedIcon: totalJoined > 0
                ? Badge.count(
                    count: totalJoined,
                    child: const Icon(Icons.event_available),
                  )
                : const Icon(Icons.event_available),
            label: 'My Events',
          ),
        ],
      ),
    );
  }

  /// Builds appropriate empty-state message based on search and current tab.
  Widget _buildEmptyState(bool isSearchingOrFiltering) {
    if (isSearchingOrFiltering) {
      return EmptyStateWidget(
        icon: Icons.search_off,
        title: 'No Matching Events',
        message:
            'No events found for "$_searchQuery" in category "$_selectedCategory".\nTry clearing your search query or changing filters.',
        buttonText: 'Clear Search & Filters',
        onButtonPressed: _clearSearchAndFilters,
      );
    }

    if (_currentTabIndex == 1) {
      return EmptyStateWidget(
        icon: Icons.favorite_border,
        title: 'No Favorites Yet',
        message:
            'You haven\'t added any events to your favorites list.\nTap the heart icon on any event card to save it here.',
        buttonText: 'Explore Events',
        onButtonPressed: () {
          setState(() {
            _currentTabIndex = 0;
          });
        },
      );
    }

    if (_currentTabIndex == 2) {
      return EmptyStateWidget(
        icon: Icons.event_busy,
        title: 'No Joined Events',
        message:
            'You haven\'t joined any events yet.\nBrowse the Explore tab, select an event, and confirm your registration to see it here.',
        buttonText: 'Browse Events',
        onButtonPressed: () {
          setState(() {
            _currentTabIndex = 0;
          });
        },
      );
    }

    return const EmptyStateWidget(
      icon: Icons.event_note,
      title: 'No Events Available',
      message: 'There are currently no events to display.',
    );
  }
}
