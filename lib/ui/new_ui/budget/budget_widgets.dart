import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/budget/budget_snapshot.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/home_widgets.dart';
import 'package:mobile_auto_drive/utils/brand.dart';
import 'package:mobile_auto_drive/utils/currency.dart';
import 'package:mobile_auto_drive/utils/get_svg_png.dart';

/// Colour for a budget status: purple while on track, amber near the limit,
/// red once over.
Color budgetStatusColor(BudgetStatus status) {
  switch (status) {
    case BudgetStatus.over:
      return Brand.danger;
    case BudgetStatus.nearLimit:
      return Brand.warning;
    case BudgetStatus.onTrack:
    case BudgetStatus.notSet:
      return Brand.purple;
  }
}

IconData budgetStatusIcon(BudgetStatus status) {
  switch (status) {
    case BudgetStatus.over:
      return Icons.error_outline_rounded;
    case BudgetStatus.nearLimit:
      return Icons.info_outline_rounded;
    case BudgetStatus.onTrack:
      return Icons.check_circle_outline_rounded;
    case BudgetStatus.notSet:
      return Icons.savings_outlined;
  }
}

/// A short, friendly line about where the spending stands.
String budgetStatusMessage(BudgetSnapshot snapshot) {
  switch (snapshot.status) {
    case BudgetStatus.notSet:
      return 'Set a budget to keep your car costs in check.';
    case BudgetStatus.onTrack:
      return "${money(snapshot.remaining)} left. You're on track!";
    case BudgetStatus.nearLimit:
      return 'Heads up, only ${money(snapshot.remaining)} left.';
    case BudgetStatus.over:
      return "You're ${money(-snapshot.remaining)} over budget.";
  }
}

/// A rounded progress bar that animates to [value] (0 to 1).
class BudgetProgressBar extends StatelessWidget {
  const BudgetProgressBar({
    super.key,
    required this.value,
    required this.color,
    this.height = 10,
  });

  final double value;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value.clamp(0.0, 1.0)),
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        builder: (context, animated, _) => LinearProgressIndicator(
          value: animated,
          minHeight: height,
          backgroundColor: Brand.lavender,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ),
    );
  }
}

/// The compact budget card on home: spent against budget, a progress bar and
/// a friendly status line. Tapping it opens the full budget screen.
class BudgetSummaryCard extends StatelessWidget {
  const BudgetSummaryCard({
    super.key,
    required this.snapshot,
    this.hasCar = true,
    this.onTap,
  });

  final BudgetSnapshot snapshot;
  final bool hasCar;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (!hasCar) {
      return const HomeCard(
        child: _MessageRow(
          icon: 'assets/images/nav_icons/report.svg',
          title: 'No budget yet',
          message: 'Add a car to start tracking what you spend on it.',
        ),
      );
    }

    final status = snapshot.status;
    final color = budgetStatusColor(status);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: HomeCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purple.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const GetSvgImage(
                      image: 'assets/images/nav_icons/report.svg',
                      color: Colors.purple,
                      width: 20,
                      height: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('Spent so far',
                        style: Brand.text(size: 14, weight: FontWeight.w600, color: Brand.muted)),
                  ),
                  if (snapshot.hasLimit)
                    _Pill(label: '${snapshot.percentUsed}% used', color: color),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded, color: Brand.muted),
                ],
              ),
              const SizedBox(height: 14),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: money(snapshot.spent),
                      style: Brand.text(size: 26, weight: FontWeight.w800, letterSpacing: -0.5),
                    ),
                    if (snapshot.hasLimit)
                      TextSpan(
                        text: '  of ${money(snapshot.limit)}',
                        style: Brand.text(size: 14, weight: FontWeight.w500, color: Brand.muted),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              BudgetProgressBar(value: snapshot.progress, color: color),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(budgetStatusIcon(status), size: 16, color: color),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      budgetStatusMessage(snapshot),
                      style: Brand.text(size: 13, color: Brand.ink.withOpacity(0.8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: Brand.text(size: 12, weight: FontWeight.w600, color: color)),
    );
  }
}

class _MessageRow extends StatelessWidget {
  const _MessageRow({required this.icon, required this.title, required this.message});

  final String icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: GetSvgImage(
            image: icon,
            color: Colors.purple,
            width: 20,
            height: 20,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Brand.text(size: 15, weight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(message, style: Brand.text(size: 13, color: Brand.muted, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}
