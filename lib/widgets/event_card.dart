import 'package:flutter/material.dart';
import '../models/event.dart';
import '../theme/app_theme.dart';

/// Reusable card widget displaying event summary information with rich visual styling.
class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const EventCard({
    super.key,
    required this.event,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final catMeta = AppTheme.getCategoryMeta(event.category, isDark);

    // Determine availability badge appearance & colors
    final Color availabilityColor;
    final Color availabilityBg;
    final String availabilityText;
    final IconData availabilityIcon;

    if (event.isFull) {
      availabilityColor = isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626);
      availabilityBg = isDark
          ? const Color(0xFF7F1D1D).withValues(alpha: 0.35)
          : const Color(0xFFFEE2E2);
      availabilityText = 'Full';
      availabilityIcon = Icons.lock_rounded;
    } else if (event.availablePlaces == 1) {
      availabilityColor = isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706);
      availabilityBg = isDark
          ? const Color(0xFF78350F).withValues(alpha: 0.35)
          : const Color(0xFFFEF3C7);
      availabilityText = 'Only 1 place left!';
      availabilityIcon = Icons.local_fire_department_rounded;
    } else {
      availabilityColor = isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A);
      availabilityBg = isDark
          ? const Color(0xFF14532D).withValues(alpha: 0.35)
          : const Color(0xFFDCFCE7);
      availabilityText = '${event.availablePlaces} / ${event.totalCapacity} spots left';
      availabilityIcon = Icons.event_seat_rounded;
    }

    return Container(
      key: Key('event-card-${event.id}'),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppTheme.darkBorder : AppTheme.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : const Color(0xFF64748B).withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.08),
          highlightColor: theme.colorScheme.primary.withValues(alpha: 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image with Category Pill, Favorite Action & Status Overlay
              Stack(
                children: [
                  SizedBox(
                    height: 195,
                    width: double.infinity,
                    child: Hero(
                      tag: 'event-img-${event.id}',
                      child: Image.asset(
                        event.imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Multi-stop Gradient Overlay for Legibility
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.45),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.55),
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Category Pill (Top-Left)
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            catMeta.icon,
                            size: 14,
                            color: catMeta.color,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            event.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Favorite Button (Top-Right)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Material(
                      color: Colors.black.withValues(alpha: 0.45),
                      shape: const CircleBorder(),
                      child: InkWell(
                        key: Key('favorite-btn-${event.id}'),
                        customBorder: const CircleBorder(),
                        onTap: onFavoriteToggle,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AnimatedScale(
                            scale: event.isFavorite ? 1.15 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              event.isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: event.isFavorite
                                  ? const Color(0xFFEF4444)
                                  : Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom Overlay: Date Tag & Joined Badge
                  Positioned(
                    bottom: 12,
                    left: 14,
                    right: 14,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Compact Date Tag
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 0.6,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 12,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${event.shortDate} • ${event.timeOnly}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Joined Badge
                        if (event.isJoined)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF059669), Color(0xFF10B981)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle_rounded, size: 13, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  'Joined',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),

              // Card Body Details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        letterSpacing: -0.2,
                        height: 1.3,
                        color: isDark ? AppTheme.darkTextPrimary : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Full Date String
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 15,
                          color: isDark ? AppTheme.darkTextMuted : const Color(0xFF64748B),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            event.formattedDate,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? AppTheme.darkTextSecondary : const Color(0xFF475569),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Venue
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 15,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            event.venue,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? AppTheme.darkTextSecondary : const Color(0xFF475569),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Occupancy Progress Indicator
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: event.occupancyRate,
                        minHeight: 5,
                        backgroundColor: isDark
                            ? AppTheme.darkSurfaceHigher
                            : const Color(0xFFE2E8F0),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          event.isFull
                              ? const Color(0xFFEF4444)
                              : (event.occupancyRate > 0.8
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFF10B981)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Divider
                    Divider(
                      height: 1,
                      color: isDark ? AppTheme.darkBorder : const Color(0xFFF1F5F9),
                    ),
                    const SizedBox(height: 12),

                    // Availability Badge & View Details Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: availabilityBg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: availabilityColor.withValues(alpha: 0.35),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                availabilityIcon,
                                size: 13,
                                color: availabilityColor,
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  availabilityText,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: availabilityColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Action pill
                      Row(
                          children: [
                            Text(
                              'View Details',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 12,
                              color: theme.colorScheme.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
