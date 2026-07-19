import 'package:flutter/material.dart';

import '../theme/qesto_theme.dart';
import 'qesto_card.dart';

enum QestoButtonStyle { primary, secondary }

class QestoButton extends StatelessWidget {
  const QestoButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.style = QestoButtonStyle.primary,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final QestoButtonStyle style;

  @override
  Widget build(BuildContext context) {
    final primary = style == QestoButtonStyle.primary;
    final foreground = primary ? Colors.white : QestoColors.primary;
    final background = primary ? QestoColors.primary : QestoColors.primarySoft;
    final borderRadius = BorderRadius.circular(17);

    return PressableScale(
      onTap: onPressed,
      borderRadius: borderRadius,
      semanticsLabel: label,
      child: Container(
        constraints: const BoxConstraints(minHeight: 58),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: background,
          borderRadius: borderRadius,
          border: Border.all(
            color: primary ? QestoColors.primary : const Color(0xFFD7E5FF),
          ),
          boxShadow: primary
              ? const [
                  BoxShadow(
                    color: Color(0x363478F6),
                    blurRadius: 18,
                    offset: Offset(0, 7),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: foreground, size: 24),
              const SizedBox(width: 9),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: foreground,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QestoProgressBar extends StatelessWidget {
  const QestoProgressBar({
    required this.value,
    this.color = QestoColors.primary,
    this.backgroundColor = const Color(0xFFEEF1F6),
    this.height = 9,
    super.key,
  });

  final double value;
  final Color color;
  final Color backgroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: backgroundColor),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value.clamp(0, 1),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, Color.lerp(color, Colors.white, 0.22)!],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AmountText extends StatelessWidget {
  const AmountText(this.value, {this.color = QestoColors.text, super.key});

  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: TextStyle(
        color: color,
        fontSize: 28,
        fontWeight: FontWeight.w800,
        height: 1.1,
        letterSpacing: -0.7,
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        ?trailing,
      ],
    );
  }
}

class QestoActionTile extends StatelessWidget {
  const QestoActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor = QestoColors.primary,
    super.key,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return QestoCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.13),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 27),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: QestoColors.secondaryText,
          ),
        ],
      ),
    );
  }
}
