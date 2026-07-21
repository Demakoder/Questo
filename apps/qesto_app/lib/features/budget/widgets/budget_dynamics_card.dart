import 'package:flutter/material.dart';

import '../../../core/formatters/qesto_formatters.dart';
import '../../../core/theme/qesto_theme.dart';
import '../../../core/widgets/qesto_card.dart';
import '../../../data/models/qesto_models.dart';
import 'budget_dynamics_chart.dart';

class BudgetDynamicsCard extends StatelessWidget {
  const BudgetDynamicsCard({
    required this.period,
    required this.forecast,
    super.key,
  });

  final BudgetPeriod period;
  final BudgetForecast forecast;

  @override
  Widget build(BuildContext context) {
    return QestoCard(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Динамика бюджета',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          BudgetDynamicsChart(period: period, forecast: forecast),
          const SizedBox(height: 14),
          _ForecastMessage(period: period, forecast: forecast),
        ],
      ),
    );
  }
}

class _ForecastMessage extends StatelessWidget {
  const _ForecastMessage({required this.period, required this.forecast});

  final BudgetPeriod period;
  final BudgetForecast forecast;

  @override
  Widget build(BuildContext context) {
    final (icon, color, message) = switch (forecast.state) {
      BudgetForecastState.projectedOverLimit => (
        Icons.info_outline_rounded,
        QestoColors.primary,
        'При текущем темпе лимит будет достигнут ${formatDate(forecast.crossingDate!)}.',
      ),
      BudgetForecastState.underPlan => (
        Icons.check_circle_outline_rounded,
        QestoColors.green,
        'Текущий темп укладывается в план.',
      ),
      BudgetForecastState.exceeded => (
        Icons.warning_amber_rounded,
        QestoColors.danger,
        'План уже превышен.',
      ),
      BudgetForecastState.noForecast => (
        Icons.query_stats_rounded,
        QestoColors.secondaryText,
        'Недостаточно данных для прогноза.',
      ),
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(fontSize: 13.5, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
