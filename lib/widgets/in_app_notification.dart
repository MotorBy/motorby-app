import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/utils/colors.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

/// A notification banner shown inside the app, for alerts that arrive while
/// the user is already looking at Motorby.
///
/// Slides in from the top, stays for a few seconds, and can be tapped to open
/// what it is about or swiped up to dismiss. Only one is shown at a time; a
/// newer alert replaces the one on screen.
class InAppNotification extends StatefulWidget {
  const InAppNotification({
    super.key,
    required this.title,
    required this.body,
    required this.icon,
    required this.onDismissed,
    this.onTap,
  });

  final String title;
  final String body;
  final IconData icon;
  final VoidCallback? onTap;
  final VoidCallback onDismissed;

  static OverlayEntry? _current;

  static const visibleFor = Duration(seconds: 5);

  static void show(
    OverlayState overlay, {
    required String title,
    required String body,
    IconData icon = Icons.notifications_rounded,
    VoidCallback? onTap,
  }) {
    dismissCurrent();

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => InAppNotification(
        title: title,
        body: body,
        icon: icon,
        onTap: onTap,
        onDismissed: () {
          if (_current == entry) _current = null;
          if (entry.mounted) entry.remove();
        },
      ),
    );
    _current = entry;
    overlay.insert(entry);
  }

  static void dismissCurrent() {
    final entry = _current;
    _current = null;
    if (entry != null && entry.mounted) entry.remove();
  }

  @override
  State<InAppNotification> createState() => _InAppNotificationState();
}

class _InAppNotificationState extends State<InAppNotification>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
  );
  late final Animation<Offset> _slide = Tween(
    begin: const Offset(0, -1.2),
    end: Offset.zero,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

  Timer? _autoHide;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _autoHide = Timer(InAppNotification.visibleFor, _close);
  }

  Future<void> _close() async {
    if (_closing) return;
    _closing = true;
    _autoHide?.cancel();
    if (mounted) await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _autoHide?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top + 8;

    return Positioned(
      top: top,
      left: 12,
      right: 12,
      child: SlideTransition(
        position: _slide,
        child: Dismissible(
          key: const ValueKey('in-app-notification'),
          direction: DismissDirection.up,
          onDismissed: (_) {
            _closing = true;
            _autoHide?.cancel();
            widget.onDismissed();
          },
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                widget.onTap?.call();
                _close();
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: XColors.primaryColor().withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(widget.icon, color: XColors.primaryColor(), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          NormalText(
                            text: widget.title,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            textColor: Colors.black,
                            maxLines: 1,
                          ),
                          if (widget.body.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            NormalText(
                              text: widget.body,
                              fontSize: 12,
                              textColor: Colors.grey[700]!,
                              maxLines: 2,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (widget.onTap != null)
                      const Icon(Icons.chevron_right, color: Colors.black38),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
