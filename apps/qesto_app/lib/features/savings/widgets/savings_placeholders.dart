import 'package:flutter/material.dart';

import '../../../core/theme/qesto_theme.dart';

class SavingsHistoryChartPlaceholder extends StatelessWidget {
  const SavingsHistoryChartPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: QestoColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: QestoColors.border),
      ),
      child: CustomPaint(painter: _PlaceholderChartPainter()),
    );
  }
}

class _PlaceholderChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = QestoColors.border
      ..strokeWidth = 1;
    for (var row = 1; row < 4; row++) {
      final y = size.height / 4 * row;
      canvas.drawLine(Offset(18, y), Offset(size.width - 18, y), grid);
    }
    final line = Path()
      ..moveTo(20, size.height * 0.76)
      ..cubicTo(
        size.width * 0.28,
        size.height * 0.70,
        size.width * 0.34,
        size.height * 0.48,
        size.width * 0.52,
        size.height * 0.52,
      )
      ..cubicTo(
        size.width * 0.70,
        size.height * 0.56,
        size.width * 0.76,
        size.height * 0.28,
        size.width - 20,
        size.height * 0.24,
      );
    canvas.drawPath(
      line,
      Paint()
        ..color = QestoColors.green.withValues(alpha: 0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SeriesCalendarPlaceholder extends StatelessWidget {
  const SeriesCalendarPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: QestoColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: QestoColors.border),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 28,
        itemBuilder: (context, index) => DecoratedBox(
          decoration: BoxDecoration(
            color: index < 19
                ? QestoColors.orange.withValues(alpha: 0.65)
                : const Color(0xFFEEF1F6),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
