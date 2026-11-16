import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/ui/new_ui/mileage/mileage_summary.dart';
import 'package:mobile_auto_drive/utils/brand.dart';

/// The shared look of the small stat tiles on home and car details.
class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Brand.lavender,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 10, 6),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(icon, size: 15, color: color),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            label,
                            overflow: TextOverflow.ellipsis,
                            style: Brand.text(size: 12, weight: FontWeight.w600, color: Brand.muted),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value,
                        maxLines: 1,
                        style: Brand.text(size: 18, weight: FontWeight.w700, letterSpacing: -0.3),
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

class ChecklistTileView extends StatelessWidget {
  const ChecklistTileView({super.key, this.checkedItems = 0, this.totalItems = 0, this.onCheckListScreen});

  final int? totalItems;
  final int? checkedItems;
  final Function? onCheckListScreen;

  @override
  Widget build(BuildContext context) {
    final checked = checkedItems ?? 0;
    final total = totalItems ?? 0;
    final progress = total == 0 ? 0.0 : (checked / total).clamp(0.0, 1.0);

    return _StatTile(
      icon: Icons.fact_check_rounded,
      label: 'Checklist',
      value: '$checked/$total',
      color: Brand.purple,
      onTap: onCheckListScreen == null ? null : () => onCheckListScreen!(),
      // trailing: SizedBox(
      //   width: 34,
      //   height: 34,
      //   child: CircularProgressIndicator(
      //     value: progress,
      //     strokeWidth: 5,
      //     strokeCap: StrokeCap.round,
      //     color: Brand.purple,
      //     backgroundColor: Brand.lilac,
      //   ),
      // ),
    );
  }
}

class MileageTileView extends StatelessWidget {
  const MileageTileView({
    super.key, this.totalMileage = "0", this.onMileageUpdate
  });

  final String? totalMileage;
  final Function? onMileageUpdate;

  String get _displayMileage {
    final reading = MileageSummary.parseReading(totalMileage);
    return reading != null ? formatKm(reading) : '${totalMileage ?? 0} km';
  }

  @override
  Widget build(BuildContext context) {
    return _StatTile(
      icon: Icons.speed_rounded,
      label: 'Mileage',
      value: _displayMileage,
      color: Brand.info,
      onTap: onMileageUpdate == null ? null : () => onMileageUpdate!(),
      // trailing: onMileageUpdate == null
      //     ? null
      //     : const Icon(Icons.chevron_right_rounded, color: Brand.purple),
    );
  }
}
