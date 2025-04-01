import 'package:flutter/material.dart';
import 'package:mobile_auto_drive/widgets/texts.dart';

enum SnackBarPosition { top, bottom }

class FloatingSnackBar extends StatelessWidget {
  final String message;
  final bool isError;
  final SnackBarPosition position;

  const FloatingSnackBar({
    Key? key,
    required this.message,
    this.isError = true,
    this.position = SnackBarPosition.top,
  }) : super(key: key);

  static void show(
    BuildContext context,
    String message, {
    bool isError = true,
    SnackBarPosition position = SnackBarPosition.top,
  }) {
    OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: position == SnackBarPosition.top
            ? MediaQuery.of(context).padding.top + 50
            : null,
        bottom: position == SnackBarPosition.bottom
            ? MediaQuery.of(context).padding.bottom + 50
            : null,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(
                  0,
                  position == SnackBarPosition.top
                      ? -50 * (1 - value)
                      : 50 * (1 - value),
                ),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: FloatingSnackBar(
              message: message,
              isError: isError,
              position: position,
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isError ? Colors.red : Colors.green,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: NormalText(
              text: message,
              fontSize: 14,
              maxLines: 4,
              fontWeight: FontWeight.w500,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
