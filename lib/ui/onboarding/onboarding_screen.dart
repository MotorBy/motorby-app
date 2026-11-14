import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/utils/brand.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/navigator.dart';

/// One page of the onboarding slider.
class OnboardingSlide {
  const OnboardingSlide({
    required this.title,
    required this.body,
    required this.icon,
    required this.accent,
    required this.topChip,
    required this.bottomChip,
  });

  final String title;
  final String body;
  final IconData icon;
  final Color accent;
  final OnboardingChip topChip;
  final OnboardingChip bottomChip;
}

/// A small floating card in a slide's illustration.
class OnboardingChip {
  const OnboardingChip({
    required this.icon,
    required this.label,
    required this.caption,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String caption;
  final Color color;
}

const onboardingSlides = [
  OnboardingSlide(
    title: 'Your garage,\nin your pocket',
    body: 'Keep every car you own in one place, with its photos, '
        'documents and details always a tap away.',
    icon: Icons.directions_car_filled_rounded,
    accent: Brand.purple,
    topChip: OnboardingChip(
      icon: Icons.verified_rounded,
      label: 'Documents',
      caption: 'All up to date',
      color: Color(0xFF12B76A),
    ),
    bottomChip: OnboardingChip(
      icon: Icons.speed_rounded,
      label: 'Mileage',
      caption: 'Logged this week',
      color: Color(0xFF2E90FA),
    ),
  ),
  OnboardingSlide(
    title: 'Know where your\nmoney goes',
    body: 'Log fuel, servicing and repairs as you go, and see exactly '
        'what your car costs you each month.',
    icon: Icons.account_balance_wallet_rounded,
    accent: Brand.orchid,
    topChip: OnboardingChip(
      icon: Icons.local_gas_station_rounded,
      label: 'Fuel',
      caption: '3 refills this month',
      color: Color(0xFFF79009),
    ),
    bottomChip: OnboardingChip(
      icon: Icons.trending_down_rounded,
      label: 'Spending',
      caption: 'Under budget',
      color: Color(0xFF12B76A),
    ),
  ),
  OnboardingSlide(
    title: 'Never miss\na service again',
    body: 'Friendly reminders for oil changes, insurance and renewals, '
        'so your car stays road-ready.',
    icon: Icons.notifications_active_rounded,
    accent: Brand.deepPurple,
    topChip: OnboardingChip(
      icon: Icons.build_rounded,
      label: 'Oil change',
      caption: 'Due tomorrow',
      color: Color(0xFFF04438),
    ),
    bottomChip: OnboardingChip(
      icon: Icons.shield_rounded,
      label: 'Insurance',
      caption: 'Renews in 14 days',
      color: Color(0xFF7A5AF8),
    ),
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  late final AnimationController _float;
  int _page = 0;

  bool get _isLast => _page == onboardingSlides.length - 1;

  @override
  void initState() {
    super.initState();
    // Drives the gentle bob of the floating chips.
    _float = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _float.dispose();
    super.dispose();
  }

  void _finish() {
    serviceLocator<PersistenceService>().setOnboarding(true);
    navigateReplace(context, SignInScreen());
  }

  void _next() {
    if (_isLast) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final accent = onboardingSlides[_page].accent;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          gradient: Brand.backdrop(accent),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _TopBar(onSkip: _isLast ? null : _finish),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: onboardingSlides.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, index) => AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      // How far this page is from the centre, 0 when settled.
                      double offset = 0;
                      if (_pageController.position.haveDimensions) {
                        offset = (_pageController.page ?? 0) - index;
                      } else {
                        offset = (_page - index).toDouble();
                      }
                      return _SlideView(
                        slide: onboardingSlides[index],
                        offset: offset.clamp(-1.0, 1.0),
                        float: _float,
                      );
                    },
                  ),
                ),
              ),
              _PageDots(count: onboardingSlides.length, current: _page),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: _PrimaryButton(
                  label: _isLast ? 'Get started' : 'Next',
                  showArrow: !_isLast,
                  color: accent,
                  onPressed: _next,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({this.onSkip});

  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 8, 0),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Brand.hairline,
            ),
            child: SvgPicture.asset('assets/images/motorby_m.svg'),
          ),
          const SizedBox(width: 10),
          const Text(
            'Motorby',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Brand.ink,
            ),
          ),
          const Spacer(),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: onSkip == null ? 0 : 1,
            child: TextButton(
              onPressed: onSkip,
              style: TextButton.styleFrom(foregroundColor: Brand.muted),
              child: const Text(
                'Skip',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  const _SlideView({
    required this.slide,
    required this.offset,
    required this.float,
  });

  final OnboardingSlide slide;

  /// -1..1, how far the page has been dragged away from the centre.
  final double offset;
  final Animation<double> float;

  @override
  Widget build(BuildContext context) {
    final fade = (1 - offset.abs()).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = math.min(constraints.maxWidth, constraints.maxHeight) * 0.92;
                return Center(
                  child: Transform.translate(
                    // The illustration lags behind the swipe for a little depth.
                    offset: Offset(offset * -60, 0),
                    child: Transform.scale(
                      scale: 0.85 + 0.15 * fade,
                      child: _Illustration(slide: slide, size: size, float: float),
                    ),
                  ),
                );
              },
            ),
          ),
          Opacity(
            opacity: fade,
            child: Transform.translate(
              offset: Offset(offset * -24, 0),
              child: Column(
                children: [
                  Text(
                    slide.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 28,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                      color: Brand.ink,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    slide.body,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      height: 1.5,
                      color: Brand.muted,
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Illustration extends StatelessWidget {
  const _Illustration({
    required this.slide,
    required this.size,
    required this.float,
  });

  final OnboardingSlide slide;
  final double size;
  final Animation<double> float;

  @override
  Widget build(BuildContext context) {
    final accent = slide.accent;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Soft halo rings.
          _Ring(size: size, color: accent.withOpacity(0.06)),
          _Ring(size: size * 0.74, color: accent.withOpacity(0.09)),
          _Ring(size: size * 0.50, color: accent.withOpacity(0.12)),

          // Sparkles.
          Positioned(
            top: size * 0.10,
            left: size * 0.16,
            child: _Dot(size: 10, color: accent.withOpacity(0.5)),
          ),
          Positioned(
            bottom: size * 0.16,
            right: size * 0.12,
            child: _Dot(size: 14, color: Brand.lilac),
          ),
          Positioned(
            top: size * 0.30,
            right: size * 0.06,
            child: _Dot(size: 6, color: accent.withOpacity(0.35)),
          ),

          // The hero tile.
          Container(
            width: size * 0.36,
            height: size * 0.36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * 0.11),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color.lerp(accent, Colors.white, 0.15)!, accent],
              ),
            ),
            child: Icon(slide.icon, color: Colors.white, size: size * 0.17),
          ),

          // Floating cards that bob in opposite directions.
          AnimatedBuilder(
            animation: float,
            builder: (context, child) {
              final t = Curves.easeInOut.transform(float.value);
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: size * 0.08 + t * 8,
                    right: -size * 0.02,
                    child: _ChipCard(chip: slide.topChip),
                  ),
                  Positioned(
                    bottom: size * 0.08 + (1 - t) * 8,
                    left: -size * 0.02,
                    child: _ChipCard(chip: slide.bottomChip),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  const _Ring({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _ChipCard extends StatelessWidget {
  const _ChipCard({required this.chip});

  final OnboardingChip chip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Brand.hairline,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: chip.color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(chip.icon, size: 18, color: chip.color),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                chip.label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Brand.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                chip.caption,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: Brand.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: active ? 28 : 8,
          decoration: BoxDecoration(
            color: active ? onboardingSlides[current].accent : Brand.lilac,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.color,
    required this.onPressed,
    this.showArrow = false,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;
  final bool showArrow;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  label,
                  key: ValueKey(label),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              if (showArrow) ...[
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
