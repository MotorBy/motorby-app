import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/brand.dart';

/// A kind of place the map can search nearby for.
class NearbyCategory {
  const NearbyCategory({
    required this.type,
    required this.label,
    required this.title,
    required this.icon,
    required this.color,
  });

  /// The place type sent to the nearby search.
  final String type;
  final String label;

  /// Title of the results screen.
  final String title;
  final IconData icon;
  final Color color;

  static const all = [
    NearbyCategory(
      type: 'gas_station',
      label: 'Gas stations',
      title: 'Nearest Gas Stations',
      icon: Icons.local_gas_station_rounded,
      color: Brand.warning,
    ),
    NearbyCategory(
      type: 'car_repair',
      label: 'Repair shops',
      title: 'Nearest Repair Shops',
      icon: Icons.car_repair_rounded,
      color: Brand.purple,
    ),
    NearbyCategory(
      type: 'car_wash',
      label: 'Car wash',
      title: 'Nearest Car Washes',
      icon: Icons.local_car_wash_rounded,
      color: Brand.info,
    ),
    NearbyCategory(
      type: 'parking',
      label: 'Parking',
      title: 'Nearest Parking',
      icon: Icons.local_parking_rounded,
      color: Brand.success,
    ),
  ];

  static NearbyCategory? byType(String type) {
    for (final c in all) {
      if (c.type == type) return c;
    }
    return null;
  }
}

/// A sideways-scrolling row of nearby place chips that floats on the map,
/// with a close chip that hides it.
class NearbyChipsBar extends StatelessWidget {
  const NearbyChipsBar({super.key, required this.onSelected, required this.onClose});

  final ValueChanged<NearbyCategory> onSelected;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          for (final c in NearbyCategory.all) ...[
            _MapChip(
              onTap: () => onSelected(c),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(color: c.color.withOpacity(0.14), shape: BoxShape.circle),
                    child: Icon(c.icon, color: c.color, size: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(c.label, style: Brand.text(size: 13, weight: FontWeight.w600)),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
          _MapChip(
            tooltip: 'Hide nearby',
            onTap: onClose,
            child: const Icon(Icons.close_rounded, size: 18, color: Brand.muted),
          ),
        ],
      ),
    );
  }
}

/// A small pill that brings the nearby chips back after they were hidden.
class ShowNearbyChip extends StatelessWidget {
  const ShowNearbyChip({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: _MapChip(
          onTap: onTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.near_me_rounded, size: 16, color: Brand.purple),
              const SizedBox(width: 6),
              Text('Nearby', style: Brand.text(size: 13, weight: FontWeight.w600, color: Brand.purple)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MapChip extends StatelessWidget {
  const _MapChip({required this.child, required this.onTap, this.tooltip});

  final Widget child;
  final VoidCallback onTap;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final chip = Material(
      color: Colors.white,
      shape: const StadiumBorder(),
      elevation: 3,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
    return Padding(
      // Room for the shadow inside the scroll view.
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: tooltip == null ? chip : Tooltip(message: tooltip!, child: chip),
    );
  }
}
