import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/services/drive_session_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/drive/drive_mode_viewmodel.dart';
import 'package:mobile_auto_drive/ui/new_ui/mileage/mileage_details_screen.dart';
import 'package:mobile_auto_drive/utils/brand.dart';
import 'package:stacked/stacked.dart';

/// Opens the live drive view; resolves when the user leaves it.
Future<void> openDriveMode(BuildContext context) => Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DriveModeScreen()),
    );

class DriveModeScreen extends StatelessWidget {
  const DriveModeScreen({super.key, this.driveService});

  /// Lets tests hand in a service. The app uses the shared one.
  final DriveSessionService? driveService;

  Future<void> _confirmEnd(BuildContext context, DriveModeViewModel model) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('End drive?', style: Brand.text(size: 18, weight: FontWeight.w700)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Keep driving', style: Brand.text(weight: FontWeight.w600, color: Brand.muted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('End', style: Brand.text(weight: FontWeight.w700, color: Brand.purple)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final hasSummary = await model.endDrive();
    // The car never moved, so there is nothing to show: just go back.
    if (!hasSummary && context.mounted) {
      ScaffoldMessenger.maybeOf(context)
          ?.showSnackBar(const SnackBar(content: Text('No movement detected. Drive not saved.')));
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DriveModeViewModel>.reactive(
      viewModelBuilder: () => DriveModeViewModel(driveService: driveService),
      onViewModelReady: (model) => model.init(),
      builder: (context, model, child) {
        if (model.showSummary) return _DriveSummaryView(model: model);
        if (!model.isDriving) return _NoDriveView(model: model);
        return _LiveDriveView(model: model, onEnd: () => _confirmEnd(context, model));
      },
    );
  }
}

class _LiveDriveView extends StatelessWidget {
  const _LiveDriveView({required this.model, required this.onEnd});

  final DriveModeViewModel model;
  final VoidCallback onEnd;

  @override
  Widget build(BuildContext context) {
    final mood = model.mood;
    final stats = model.stats;

    return Scaffold(
      backgroundColor: Brand.deepPurple,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Brand.deepPurple, Brand.purple, Color(0xFF9B3FD0)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Minimise',
                      onPressed: () => Navigator.maybePop(context),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 30),
                    ),
                    const Spacer(),
                    _LiveChip(label: model.carName),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(mood.title,
                  style: Brand.text(size: 24, weight: FontWeight.w800, color: Colors.white, letterSpacing: -0.4)),
              const SizedBox(height: 16),
              SpeedGauge(speedKmh: stats.currentSpeedKmh, alert: model.isAlert),
              if (model.gpsIssue != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.gps_not_fixed_rounded, color: Color(0xFFFFC56B), size: 16),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(model.gpsIssue!,
                            textAlign: TextAlign.center,
                            style: Brand.text(size: 12, weight: FontWeight.w600, color: const Color(0xFFFFE2B0))),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                      children: [
                        _StatGrid(stats: stats),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 54,
                          child: FilledButton.icon(
                            onPressed: model.isEnding ? null : onEnd,
                            style: FilledButton.styleFrom(
                              backgroundColor: Brand.ink,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
                            ),
                            icon: const Icon(Icons.flag_rounded),
                            label: Text('End drive',
                                style: Brand.text(size: 16, weight: FontWeight.w700, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A pill with a pulsing dot: shows the drive is live.
class _LiveChip extends StatefulWidget {
  const _LiveChip({required this.label});

  final String label;

  @override
  State<_LiveChip> createState() => _LiveChipState();
}

class _LiveChipState extends State<_LiveChip> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: Tween(begin: 0.35, end: 1.0).animate(_pulse),
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(color: Color(0xFF4ADE80), shape: BoxShape.circle),
            ),
          ),
          const SizedBox(width: 6),
          Text('LIVE', style: Brand.text(size: 11, weight: FontWeight.w800, color: Colors.white, letterSpacing: 1)),
          const SizedBox(width: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160),
            child: Text(widget.label,
                overflow: TextOverflow.ellipsis,
                style: Brand.text(size: 13, weight: FontWeight.w600, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

/// A 240° speedometer arc with the speed in the middle.
class SpeedGauge extends StatelessWidget {
  const SpeedGauge({super.key, required this.speedKmh, this.alert = false, this.maxKmh = 160});

  final double? speedKmh;
  final bool alert;
  final double maxKmh;

  @override
  Widget build(BuildContext context) {
    final speed = speedKmh;
    return SizedBox(
      width: 230,
      height: 210,
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: ((speed ?? 0) / maxKmh).clamp(0.0, 1.0)),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, fraction, _) => CustomPaint(
          painter: _GaugePainter(fraction: fraction, alert: alert),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    speed == null ? '--' : speed.round().toString(),
                    style: Brand.text(size: 64, weight: FontWeight.w800, color: Colors.white, height: 1),
                  ),
                  const SizedBox(height: 4),
                  Text('km/h',
                      style: Brand.text(size: 14, weight: FontWeight.w600, color: Colors.white.withOpacity(0.75))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({required this.fraction, required this.alert});

  final double fraction;
  final bool alert;

  static const _start = math.pi * 5 / 6; // 150°, bottom-left
  static const _sweep = math.pi * 4 / 3; // 240°

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 6);
    final radius = math.min(size.width, size.height) / 2 - 12;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Ticks every 20 km/h.
    final tick = Paint()
      ..color = Colors.white.withOpacity(0.35)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i <= 8; i++) {
      final a = _start + _sweep * i / 8;
      final dir = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(center + dir * (radius - 22), center + dir * (radius - 16), tick);
    }

    final track = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, _start, _sweep, false, track);

    if (fraction <= 0) return;
    final colors = alert ? const [Color(0xFFFFC56B), Brand.danger] : const [Brand.orchid, Colors.white];
    final progress = Paint()
      ..shader = SweepGradient(startAngle: _start, endAngle: _start + _sweep, colors: colors).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, _start, _sweep * fraction, false, progress);

    // A bright dot at the tip of the arc.
    final tipAngle = _start + _sweep * fraction;
    canvas.drawCircle(center + Offset(math.cos(tipAngle), math.sin(tipAngle)) * radius, 5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(_GaugePainter old) => old.fraction != fraction || old.alert != alert;
}

class _StatGrid extends StatelessWidget {
  const _StatGrid({required this.stats});

  final DriveStats stats;

  @override
  Widget build(BuildContext context) {
    final tiles = [
      _StatTile(
          icon: Icons.timer_rounded,
          color: Brand.purple,
          label: 'Time',
          value: DriveModeViewModel.formatClock(stats.duration)),
      _StatTile(
          icon: Icons.route_rounded,
          color: Brand.info,
          label: 'Distance',
          value: '${stats.distanceKm.toStringAsFixed(1)} km'),
      _StatTile(
          icon: Icons.av_timer_rounded,
          color: Brand.success,
          label: 'Avg speed',
          value: '${stats.averageSpeedKmh.round()} km/h'),
      _StatTile(
          icon: Icons.bolt_rounded,
          color: Brand.warning,
          label: 'Top speed',
          value: '${stats.topSpeedKmh.round()} km/h'),
    ];
    return Column(
      children: [
        Row(children: [Expanded(child: tiles[0]), const SizedBox(width: 12), Expanded(child: tiles[1])]),
        const SizedBox(height: 12),
        Row(children: [Expanded(child: tiles[2]), const SizedBox(width: 12), Expanded(child: tiles[3])]),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.icon, required this.color, required this.label, required this.value});

  final IconData icon;
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(11)),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(height: 10),
          Text(label, style: Brand.text(size: 12, color: Brand.muted)),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, style: Brand.text(size: 20, weight: FontWeight.w800, letterSpacing: -0.3)),
          ),
        ],
      ),
    );
  }
}

class _DriveSummaryView extends StatelessWidget {
  const _DriveSummaryView({required this.model});

  final DriveModeViewModel model;

  @override
  Widget build(BuildContext context) {
    final stats = model.summary!.stats;
    final calm = model.isCalmDrive;
    final budgetIndex = model.summaryBudgetIndex;
    final odometer = model.estimatedOdometer;
    final noteColor = calm ? Brand.success : Brand.warning;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(gradient: Brand.backdrop()),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
            children: [
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [Brand.orchid, Brand.purple]),
                  ),
                  child: const Icon(Icons.flag_rounded, color: Colors.white, size: 36),
                ),
              ),
              const SizedBox(height: 16),
              Text('Drive complete',
                  textAlign: TextAlign.center,
                  style: Brand.text(size: 26, weight: FontWeight.w800, letterSpacing: -0.5)),
              const SizedBox(height: 4),
              Text(model.summaryLine,
                  textAlign: TextAlign.center, style: Brand.text(size: 15, color: Brand.muted)),
              const SizedBox(height: 24),
              _StatGrid(stats: stats),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: noteColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Icon(calm ? Icons.verified_rounded : Icons.speed_rounded, color: noteColor),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(model.summaryNote, style: Brand.text(size: 14, weight: FontWeight.w600)),
                    ),
                    Text('${stats.smoothnessScore}/100',
                        style: Brand.text(size: 16, weight: FontWeight.w800, color: noteColor)),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              if (budgetIndex != null) ...[
                if (odometer != null) ...[
                  Text('Odometer ≈ ${_thousands(odometer)} km',
                      textAlign: TextAlign.center, style: Brand.text(size: 13, color: Brand.muted)),
                  const SizedBox(height: 8),
                ],
                SizedBox(
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (_) => MileageDetailsScreen(budgetIndex: budgetIndex),
                    )),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Brand.purple,
                      side: const BorderSide(color: Brand.lilac),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                    ),
                    icon: const Icon(Icons.speed_rounded),
                    label: Text('Update mileage',
                        style: Brand.text(size: 15, weight: FontWeight.w600, color: Brand.purple)),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: () => Navigator.maybePop(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: Brand.purple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                  ),
                  child: Text('Done', style: Brand.text(size: 15, weight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _thousands(int n) =>
      n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
}

class _NoDriveView extends StatelessWidget {
  const _NoDriveView({required this.model});

  final DriveModeViewModel model;

  @override
  Widget build(BuildContext context) {
    final drives = model.recentDrives;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, foregroundColor: Brand.ink),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          const Icon(Icons.directions_car_rounded, size: 48, color: Brand.purple),
          const SizedBox(height: 12),
          Text('No active drive',
              textAlign: TextAlign.center, style: Brand.text(size: 18, weight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Start one from Quick actions.',
              textAlign: TextAlign.center, style: Brand.text(size: 14, color: Brand.muted)),
          if (drives.isNotEmpty) ...[
            const SizedBox(height: 28),
            Text('Recent drives', style: Brand.text(size: 18, weight: FontWeight.w700)),
            const SizedBox(height: 8),
            for (final drive in drives) _RecentDriveTile(drive: drive),
          ],
        ],
      ),
    );
  }
}

class _RecentDriveTile extends StatelessWidget {
  const _RecentDriveTile({required this.drive});

  final DriveRecord drive;

  @override
  Widget build(BuildContext context) {
    final s = drive.stats;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Brand.hairline),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: Brand.lavender, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.route_rounded, color: Brand.purple, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(DriveModeViewModel.carNameFor(drive.car),
                      style: Brand.text(size: 15, weight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(
                    '${DriveModeViewModel.formatWhen(drive.startedAt)} · ${DriveModeViewModel.formatLength(s.duration)}',
                    style: Brand.text(size: 12, color: Brand.muted),
                  ),
                ],
              ),
            ),
            Text('${s.distanceKm.toStringAsFixed(1)} km', style: Brand.text(size: 15, weight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
