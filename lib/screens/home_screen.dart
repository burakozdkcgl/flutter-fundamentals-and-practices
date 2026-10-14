import 'package:flutter/material.dart';
import '../data/mock_events.dart';
import '../main.dart';
import '../models/event.dart';
import '../theme/app_theme.dart';
import '../widgets/empty_state.dart';
import '../widgets/event_card.dart';
import 'event_details_screen.dart';

/// Sorting options available for campus events.
enum EventSortOption {
  dateAsc('Upcoming Date', Icons.event_available_rounded),
  alphabetical('Alphabetical (A - Z)', Icons.sort_by_alpha_rounded),
  capacityDesc('Most Spots Left', Icons.event_seat_rounded),
  occupancyDesc('Most Popular', Icons.trending_up_rounded);

  final String label;
  final IconData icon;
  const EventSortOption(this.label, this.icon);
}

/// Main screen featuring Explore, Favorites, and My Events tabs
/// with integrated search, category filtering, theme toggle, sorting, and capacity management.
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

  // Search, filter, and sort state
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'All';
  EventSortOption _selectedSort = EventSortOption.dateAsc;

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

    // Deep linking support via web query parameters
    try {
      final themeParam = Uri.base.queryParameters['theme'];
      if (themeParam == 'dark') {
        CampusEventExplorerApp.themeModeNotifier.value = ThemeMode.dark;
      } else if (themeParam == 'light') {
        CampusEventExplorerApp.themeModeNotifier.value = ThemeMode.light;
      }

      final tabParam = Uri.base.queryParameters['tab'];
      if (tabParam != null) {
        final parsed = int.tryParse(tabParam);
        if (parsed != null && parsed >= 0 && parsed <= 2) {
          _currentTabIndex = parsed;
        }
      }

      final presetParam = Uri.base.queryParameters['preset'];
      if (presetParam == 'favorites6') {
        const favIds = {'ev-4', 'ev-6', 'ev-13', 'ev-14', 'ev-15', 'ev-17'};
        for (final e in _allEvents) {
          if (favIds.contains(e.id)) {
            e.isFavorite = true;
          }
        }
      } else if (presetParam == 'sports4') {
        const sportIds = {'ev-18', 'ev-19', 'ev-20', 'ev-21'};
        for (final e in _allEvents) {
          if (sportIds.contains(e.id)) {
            e.isJoined = true;
            e.availablePlaces =
                (e.availablePlaces - 1).clamp(0, e.totalCapacity);
          }
        }
      } else if (Uri.base.queryParameters['sample'] == 'true') {
        if (_allEvents.isNotEmpty) {
          _allEvents[0].isFavorite = true;
          _allEvents[0].isJoined = true;
          _allEvents[0].availablePlaces =
              (_allEvents[0].availablePlaces - 1).clamp(0, _allEvents[0].totalCapacity);
        }
      }

      final categoryParam = Uri.base.queryParameters['category'];
      if (categoryParam != null && _categories.contains(categoryParam)) {
        _selectedCategory = categoryParam;
      }

      final searchParam = Uri.base.queryParameters['search'];
      if (searchParam != null && searchParam.isNotEmpty) {
        _searchController.text = searchParam;
        _searchQuery = searchParam;
      }

      if (Uri.base.queryParameters['dialog'] == 'sort') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showSortBottomSheet();
          }
        });
      }

      final eventId = Uri.base.queryParameters['event'];
      if (eventId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          final target = _allEvents.firstWhere(
            (e) => e.id == eventId,
            orElse: () => _allEvents.first,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => EventDetailsScreen(
                event: target,
                onStateChanged: () => setState(() {}),
              ),
            ),
          );
        });
      }
    } catch (_) {}
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
      _selectedSort = EventSortOption.dateAsc;
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

  void _showSortBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext sheetContext) {
        final isDark = Theme.of(sheetContext).brightness == Brightness.dark;
        return Material(
          color: isDark ? AppTheme.darkSurface : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                width: 1,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: isDark ? AppTheme.darkBorder : const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sort Events By',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isDark ? AppTheme.darkTextPrimary : const Color(0xFF0F172A),
                      ),
                    ),
                    if (_selectedSort != EventSortOption.dateAsc)
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedSort = EventSortOption.dateAsc;
                          });
                          Navigator.pop(sheetContext);
                        },
                        child: const Text('Reset'),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                ...EventSortOption.values.map((option) {
                  final isSelected = _selectedSort == option;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? (isDark ? AppTheme.estuCrimson : AppTheme.estuBurgundy)
                            : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
                        width: 1,
                      ),
                    ),
                    child: Material(
                      color: isSelected
                          ? (isDark
                              ? const Color(0xFF381014)
                              : const Color(0xFFFFE4E6))
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        dense: true,
                        leading: Icon(
                          option.icon,
                          color: isSelected
                              ? (isDark ? AppTheme.estuCrimson : AppTheme.estuBurgundy)
                              : (isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
                        ),
                        title: Text(
                          option.label,
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? (isDark ? AppTheme.estuCrimson : AppTheme.estuBurgundy)
                                : (isDark ? AppTheme.darkTextPrimary : const Color(0xFF0F172A)),
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle_rounded,
                                size: 18,
                                color: isDark ? AppTheme.estuCrimson : AppTheme.estuBurgundy,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedSort = option;
                          });
                          Navigator.pop(sheetContext);
                        },
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Filters events based on tab, title search, selected category, and sort option.
  List<Event> _getFilteredEvents() {
    // 1. Base list according to selected tab
    List<Event> baseList;
    if (_currentTabIndex == 1) {
      baseList = _allEvents.where((e) => e.isFavorite).toList();
    } else if (_currentTabIndex == 2) {
      baseList = _allEvents.where((e) => e.isJoined).toList();
    } else {
      baseList = List<Event>.from(_allEvents);
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

    // 4. Apply sorting
    switch (_selectedSort) {
      case EventSortOption.dateAsc:
        baseList.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        break;
      case EventSortOption.alphabetical:
        baseList.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case EventSortOption.capacityDesc:
        baseList.sort((a, b) => b.availablePlaces.compareTo(a.availablePlaces));
        break;
      case EventSortOption.occupancyDesc:
        baseList.sort((a, b) => a.availablePlaces.compareTo(b.availablePlaces));
        break;
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
        _searchQuery.trim().isNotEmpty ||
        _selectedCategory != 'All' ||
        _selectedSort != EventSortOption.dateAsc;

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
              color: isDark ? AppTheme.darkScaffoldBg : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                  width: 0.8,
                ),
              ),
            ),
            child: Column(
              children: [
                // Modern Search Input Field & Sort Button
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppTheme.darkSurfaceHigher : AppTheme.lightSurfaceHigher,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search events by title...',
                            hintStyle: TextStyle(
                              color: isDark ? AppTheme.darkTextMuted : AppTheme.lightTextSecondary,
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
                    ),
                    const SizedBox(width: 8),
                    Tooltip(
                      message: 'Sort events: ${_selectedSort.label}',
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          key: const Key('sort-button'),
                          onTap: _showSortBottomSheet,
                          borderRadius: BorderRadius.circular(16),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: _selectedSort != EventSortOption.dateAsc
                                  ? (isDark ? const Color(0xFF381014) : const Color(0xFFFFE4E6))
                                  : (isDark ? AppTheme.darkSurfaceHigher : AppTheme.lightSurfaceHigher),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _selectedSort != EventSortOption.dateAsc
                                    ? (isDark ? AppTheme.estuCrimson : AppTheme.estuBurgundy)
                                    : (isDark ? AppTheme.darkBorder : AppTheme.lightBorder),
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.tune_rounded,
                                  size: 20,
                                  color: _selectedSort != EventSortOption.dateAsc
                                      ? (isDark ? AppTheme.estuCrimson : AppTheme.estuBurgundy)
                                      : (isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
                                ),
                                if (_selectedSort != EventSortOption.dateAsc) ...[
                                  const SizedBox(width: 4),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: isDark ? AppTheme.estuCrimson : AppTheme.estuBurgundy,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
                                    ? (isDark ? AppTheme.estuCrimson : AppTheme.estuBurgundy)
                                    : catMeta.color)
                                : (isDark
                                    ? AppTheme.darkSurface
                                    : AppTheme.lightSurfaceHigher),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.transparent
                                  : (isDark
                                      ? AppTheme.darkBorder
                                      : AppTheme.lightBorder),
                              width: 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: (category == 'All'
                                              ? (isDark ? AppTheme.estuCrimson : AppTheme.estuBurgundy)
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
                                    : (isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                category,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark
                                          ? AppTheme.darkTextSecondary
                                          : AppTheme.lightTextPrimary),
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
              color: isDark ? AppTheme.darkSurface : AppTheme.lightSurfaceHigher,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
                  width: 0.6,
                ),
              ),
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
                      '${filteredEvents.length} event${filteredEvents.length == 1 ? '' : 's'} matching',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
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
          color: isDark ? AppTheme.darkSurface : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
              width: 0.8,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
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
