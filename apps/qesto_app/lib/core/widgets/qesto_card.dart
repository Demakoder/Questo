import 'package:flutter/material.dart';

import '../theme/qesto_theme.dart';

class PressableScale extends StatefulWidget {
  const PressableScale({
    required this.child,
    required this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.semanticsLabel,
    super.key,
  });

  final Widget child;
  final VoidCallback onTap;
  final BorderRadius borderRadius;
  final String? semanticsLabel;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  var _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.semanticsLabel,
      child: AnimatedScale(
        scale: _pressed ? 0.985 : 1,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: _pressed ? 0.88 : 1,
          duration: const Duration(milliseconds: 110),
          child: Material(
            color: Colors.transparent,
            borderRadius: widget.borderRadius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: widget.onTap,
              onHighlightChanged: (pressed) {
                if (_pressed != pressed) setState(() => _pressed = pressed);
              },
              borderRadius: widget.borderRadius,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

class QestoCard extends StatelessWidget {
  const QestoCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.radius = 22,
    this.color = QestoColors.surface,
    this.semanticsLabel,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double radius;
  final Color color;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(radius);
    final card = DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: Border.all(color: QestoColors.border.withValues(alpha: 0.72)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D26324A),
            blurRadius: 20,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Padding(
        padding: padding,
        child: Material(type: MaterialType.transparency, child: child),
      ),
    );

    if (onTap == null) return card;
    return PressableScale(
      onTap: onTap!,
      borderRadius: borderRadius,
      semanticsLabel: semanticsLabel,
      child: card,
    );
  }
}
