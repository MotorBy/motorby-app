import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/utils/brand.dart';
import 'package:mobile_auto_drive/utils/currency.dart';

/// A white card with a thin outline: the building block of home.
class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Brand.hairline,
      ),
      child: child,
    );
  }
}

/// A section title with an optional text action on the right.
class HomeSectionHeader extends StatelessWidget {
  const HomeSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 28, 0, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Brand.text(size: 18, weight: FontWeight.w700, letterSpacing: -0.3),
            ),
          ),
          if (actionLabel != null)
            InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Brand.purple.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  actionLabel!,
                  style: Brand.text(size: 13, weight: FontWeight.w600, color: Brand.purple),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Greeting and avatar at the top of home.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.greeting,
    required this.name,
    required this.initial,
    this.onProfile,
  });

  final String greeting;
  final String name;
  final String initial;
  final VoidCallback? onProfile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 0, 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(greeting, style: Brand.text(size: 12, color: Brand.muted)),
                const SizedBox(height: 4),
                Text(
                  name.isEmpty ? 'Welcome back' : 'Hi, $name',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Brand.text(size: 16, weight: FontWeight.w700, letterSpacing: -0.5),
                ),
              ],
            ),
          ),
          Semantics(
            button: true,
            label: 'Profile',
            child: GestureDetector(
              onTap: onProfile,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Brand.orchid, Brand.purple],
                  ),
                  border: Border.all(color: Colors.white, width: 3),
                ),
                alignment: Alignment.center,
                child: initial.isEmpty
                    ? const Icon(Icons.person_rounded, color: Colors.white)
                    : Text(
                        initial,
                        style: Brand.text(size: 18, weight: FontWeight.w700, color: Colors.white),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Today's weather as a compact strip: one line when it fits, two at most.
class WeatherCard extends StatelessWidget {
  const WeatherCard({
    super.key,
    this.temperature,
    this.description,
    this.locationDeclined = false,
    this.onDriveGuide,
    this.onEnableLocation,
  });

  /// Degrees Celsius, or null when weather has not loaded.
  final String? temperature;
  final String? description;
  final bool locationDeclined;
  final VoidCallback? onDriveGuide;
  final VoidCallback? onEnableLocation;

  @override
  Widget build(BuildContext context) {
    final hasWeather = temperature != null;
    final askForLocation = !hasWeather && locationDeclined;

    final InlineSpan summary = hasWeather
        ? TextSpan(children: [
            TextSpan(
              text: '$temperature°C',
              style: Brand.text(size: 15, weight: FontWeight.w700),
            ),
            if (description?.isNotEmpty == true)
              TextSpan(text: '  ·  ${_capitalise(description!)}'),
          ])
        : TextSpan(
            style: Brand.text(size: 15, color: Brand.muted),
            text: askForLocation
                ? 'Turn on location for the weather on your drive'
                : 'Checking the weather near you…',
          );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Brand.hairline,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Brand.purple.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              hasWeather ? _iconFor(description) : Icons.wb_cloudy_rounded,
              size: 20,
              color: Brand.purple,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text.rich(
              summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Brand.text(size: 14, color: Brand.ink, height: 1.35),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: askForLocation ? onEnableLocation : onDriveGuide,
            style: TextButton.styleFrom(
              foregroundColor: Brand.purple,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              minimumSize: const Size(0, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              askForLocation ? 'Turn on' : 'Drive guide',
              style: Brand.text(size: 13, weight: FontWeight.w600, color: Brand.purple),
            ),
          ),
        ],
      ),
    );
  }

  static String _capitalise(String s) => s[0].toUpperCase() + s.substring(1);

  static IconData _iconFor(String? description) {
    final d = description?.toLowerCase() ?? '';
    if (d.contains('thunder') || d.contains('storm')) return Icons.thunderstorm_rounded;
    if (d.contains('rain') || d.contains('drizzle') || d.contains('shower')) return Icons.water_drop_rounded;
    if (d.contains('cloud') || d.contains('overcast')) return Icons.wb_cloudy_rounded;
    if (d.contains('mist') || d.contains('fog') || d.contains('haze')) return Icons.foggy;
    return Icons.wb_sunny_rounded;
  }
}

/// The last spend logged, as one friendly line.
class RecentSpendCard extends StatelessWidget {
  const RecentSpendCard({super.key, this.spend});

  final LastBudget? spend;

  @override
  Widget build(BuildContext context) {
    final spend = this.spend;
    final category = spend?.budgetType?.trim();

    return HomeCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Brand.warning.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_iconFor(category), color: Brand.warning),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: spend == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('No spending logged yet',
                          style: Brand.text(size: 15, weight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('Log fuel, servicing or repairs to see them here.',
                          style: Brand.text(size: 13, color: Brand.muted, height: 1.4)),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: Brand.text(size: 15, height: 1.4),
                          children: [
                            TextSpan(text: spend.isFutureBudget == true ? 'You plan to spend ' : 'You spent '),
                            TextSpan(
                              text: money(spend.price),
                              style: Brand.text(size: 15, weight: FontWeight.w700),
                            ),
                            if (category != null && category.isNotEmpty)
                              TextSpan(text: ' on ${category.toLowerCase()}'),
                          ],
                        ),
                      ),
                      if (spend.date?.isNotEmpty == true) ...[
                        const SizedBox(height: 4),
                        Text(
                          spend.isFutureBudget == true ? 'Planned for ${spend.date}' : spend.date!,
                          style: Brand.text(size: 13, color: Brand.muted),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  static IconData _iconFor(String? category) {
    final c = category?.toLowerCase() ?? '';
    if (c.contains('fuel')) return Icons.local_gas_station_rounded;
    if (c.contains('servic')) return Icons.build_rounded;
    if (c.contains('repair')) return Icons.handyman_rounded;
    if (c.contains('break')) return Icons.car_crash_rounded;
    return Icons.receipt_long_rounded;
  }
}

/// A gentle banner for sections that failed to load.
class HomeNotice extends StatelessWidget {
  const HomeNotice({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Brand.warning.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, size: 18, color: Brand.warning),
          const SizedBox(width: 10),
          Expanded(child: Text(message, style: Brand.text(size: 13, color: Brand.ink))),
        ],
      ),
    );
  }
}

/// Shown when home could not load at all.
class HomeErrorView extends StatelessWidget {
  const HomeErrorView({super.key, this.message, required this.onRetry});

  final String? message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: Brand.purple.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.cloud_off_rounded, size: 40, color: Brand.purple),
          ),
          const SizedBox(height: 20),
          Text("We couldn't load your home",
              textAlign: TextAlign.center,
              style: Brand.text(size: 18, weight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(
            message?.isNotEmpty == true
                ? message!
                : 'Check your connection and try again.',
            textAlign: TextAlign.center,
            style: Brand.text(size: 14, color: Brand.muted, height: 1.5),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text('Try again', style: Brand.text(size: 15, weight: FontWeight.w700, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Brand.purple,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 28),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder blocks while home loads for the first time.
class HomeSkeleton extends StatefulWidget {
  const HomeSkeleton({super.key});

  @override
  State<HomeSkeleton> createState() => _HomeSkeletonState();
}

class _HomeSkeletonState extends State<HomeSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  Widget _block(double height) => Container(
        height: height,
        margin: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          color: Brand.lilac.withOpacity(0.6),
          borderRadius: BorderRadius.circular(24),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.5, end: 1.0).animate(_pulse),
      child: Column(
        children: [_block(150), _block(260), _block(140), _block(90)],
      ),
    );
  }
}
