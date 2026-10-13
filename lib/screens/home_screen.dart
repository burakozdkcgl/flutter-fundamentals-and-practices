import 'package:flutter/material.dart';
import '../data/mock_events.dart';
import '../main.dart';
import '../models/event.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/event_card.dart';
import 'event_details_screen.dart';

/// Main screen featuring Explore, Favorites, and My Events tabs
/// with integrated search, category filtering, theme toggle, and capacity management.
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
        content: Row(
          children: [
            Icon(
              event.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                event.isFavorite
                    ? 'Added "${event.title}" to favorites.'
                    : 'Removed "${event.title}" from favorites.',
              ),
            ),
          ],
        ),
        backgroundColor: event.isFavorite ? const Color(0xFFE11D48) : const Color(0xFF475569),
        duration: const Duration(seconds: 2),
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

  void _showEstuInfoDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.estuBurgundy.withValues(alpha: 0.18),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/estu_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Eskişehir Teknik Üniversitesi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: AppTheme.estuBurgundy,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Campus Event Explorer',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.estuBurgundy.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'BIM493 - Mobile Programming I',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.estuBurgundy,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Discover campus events, save your favorites, and manage registrations for university life.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.estuBurgundy,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        );
      },
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
    final isDark = theme.brightness == Brightness.dark;
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
      tabTitle = 'Explore Campus';
    }

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 14.0, top: 8.0, bottom: 8.0),
          child: Tooltip(
            message: 'Eskişehir Teknik Üniversitesi',
            child: InkWell(
              onTap: _showEstuInfoDialog,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/estu_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.school_rounded,
                      size: 20,
                      color: AppTheme.estuBurgundy,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Text(
          tabTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.3),
        ),
        actions: [
          // Theme Mode Switcher
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              size: 20,
            ),
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () {
              CampusEventExplorerApp.themeModeNotifier.value =
                  isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header (Applies equally to Explore, Favorites, My Events)
          Container(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  width: 0.8,
                ),
              ),
            ),
            child: Column(
              children: [
                // Modern Search Input Field
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Search events by title...',
                      hintStyle: TextStyle(
                        color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: theme.colorScheme.primary,
                        size: 22,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.cancel_rounded, size: 18),
                              tooltip: 'Clear search',
                              onPressed: () {
                                _searchController.clear();
                              },
                            )
                          : null,
                      filled: false,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Category Filter Chips with Icons
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      final catMeta = AppTheme.getCategoryMeta(category, isDark);

                      return InkWell(
                        key: Key('filter-chip-$category'),
                        onTap: () {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (category == 'All'
                                    ? theme.colorScheme.primary
                                    : catMeta.color)
                                : (isDark
                                    ? const Color(0xFF0F172A)
                                    : const Color(0xFFF8FAFC)),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : (isDark
                                      ? const Color(0xFF334155)
                                      : const Color(0xFFE2E8F0)),
                              width: 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: (category == 'All'
                                              ? theme.colorScheme.primary
                                              : catMeta.color)
                                          .withValues(alpha: 0.35),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                catMeta.icon,
                                size: 15,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                category,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark
                                          ? const Color(0xFFE2E8F0)
                                          : const Color(0xFF334155)),
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Match Count & Reset Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      !isSearchingOrFiltering && _currentTabIndex == 2
                          ? 'Total Joined: $totalJoined event${totalJoined == 1 ? '' : 's'}'
                          : '${filteredEvents.length} event${filteredEvents.length == 1 ? '' : 's'} matching',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
                if (isSearchingOrFiltering)
                  InkWell(
                    onTap: _clearSearchAndFilters,
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_alt_off_rounded,
                            size: 14,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Reset Filters',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
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
                    physics: const BouncingScrollPhysics(),
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

      // Bottom Navigation Bar with 3 tabs and Live Badges
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
              blurRadius: 14,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentTabIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _currentTabIndex = index;
            });
          },
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore_rounded),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: totalFavorites > 0
                  ? Badge.count(
                      count: totalFavorites,
                      backgroundColor: const Color(0xFFE11D48),
                      child: const Icon(Icons.favorite_outline_rounded),
                    )
                  : const Icon(Icons.favorite_outline_rounded),
              selectedIcon: totalFavorites > 0
                  ? Badge.count(
                      count: totalFavorites,
                      backgroundColor: const Color(0xFFE11D48),
                      child: const Icon(Icons.favorite_rounded),
                    )
                  : const Icon(Icons.favorite_rounded),
              label: 'Favorites',
            ),
            NavigationDestination(
              icon: totalJoined > 0
                  ? Badge.count(
                      count: totalJoined,
                      backgroundColor: const Color(0xFF059669),
                      child: const Icon(Icons.event_available_outlined),
                    )
                  : const Icon(Icons.event_available_outlined),
              selectedIcon: totalJoined > 0
                  ? Badge.count(
                      count: totalJoined,
                      backgroundColor: const Color(0xFF059669),
                      child: const Icon(Icons.event_available_rounded),
                    )
                  : const Icon(Icons.event_available_rounded),
              label: 'My Events',
            ),
          ],
        ),
      ),
    );
  }

  /// Builds appropriate empty-state message based on search and current tab.
  Widget _buildEmptyState(bool isSearchingOrFiltering) {
    if (isSearchingOrFiltering) {
      return EmptyStateWidget(
        icon: Icons.search_off_rounded,
        title: 'No Matching Events',
        message:
            'No events found for "$_searchQuery" in category "$_selectedCategory".\nTry clearing your search query or changing filters.',
        buttonText: 'Clear Search & Filters',
        onButtonPressed: _clearSearchAndFilters,
      );
    }

    if (_currentTabIndex == 1) {
      return EmptyStateWidget(
        icon: Icons.favorite_border_rounded,
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
        icon: Icons.event_busy_rounded,
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
      icon: Icons.event_note_rounded,
      title: 'No Events Available',
      message: 'There are currently no events to display.',
    );
  }
}
