import '../../../../core/formatters/qesto_formatters.dart';
import '../models/statistics_models.dart';

class StatisticsInsightsService {
  const StatisticsInsightsService();

  List<StatisticsInsight> build({
    required StatisticsSummary summary,
    required List<StatisticsGroupStat> categories,
    required List<StatisticsGroupStat> merchants,
    required DataQualityReport quality,
    required int largePurchaseAmount,
  }) {
    final result = <StatisticsInsight>[];
    final change = summary.changePercent;
    if (change != null) {
      final direction = change >= 0 ? 'выросли' : 'снизились';
      result.add(
        StatisticsInsight(
          title: 'Расходы $direction на ${change.abs().toStringAsFixed(1)}%',
          explanation:
              'Сравниваются периоды одинаковой длины с учётом возвратов.',
          calculation:
              'Текущий расход ${formatMoney(summary.expenses, 'RUB')} сопоставлен с предыдущим периодом такой же длины.',
          type: StatisticsInsightType.change,
          priority: 100,
        ),
      );
    }
    if (categories.isNotEmpty && categories.first.changePercent != null) {
      final category = categories.first;
      result.add(
        StatisticsInsight(
          title: 'Наибольшая категория — ${category.label}',
          explanation:
              'На неё приходится ${(category.share * 100).toStringAsFixed(0)}% расходов периода.',
          calculation:
              '${formatMoney(category.amount, 'RUB')} из ${formatMoney(summary.expenses, 'RUB')}.',
          type: StatisticsInsightType.category,
          priority: 80,
          targetId: category.id,
        ),
      );
    }
    if (largePurchaseAmount > 0) {
      result.add(
        StatisticsInsight(
          title: 'Крупные покупки повлияли на период',
          explanation: 'Без них общая динамика могла бы выглядеть иначе.',
          calculation:
              'Подтверждённые крупные покупки: ${formatMoney(largePurchaseAmount, 'RUB')}.',
          type: StatisticsInsightType.largePurchase,
          priority: 70,
        ),
      );
    }
    if (merchants.isNotEmpty) {
      final merchant = merchants.first;
      result.add(
        StatisticsInsight(
          title: '${merchant.label}: ${merchant.count} покупок',
          explanation:
              'Средний чек — ${formatMoney(merchant.averageCheck.round(), 'RUB')}.',
          calculation:
              'Сумма ${formatMoney(merchant.amount, 'RUB')} разделена на ${merchant.count} операций.',
          type: StatisticsInsightType.merchant,
          priority: 60,
          targetId: merchant.id,
        ),
      );
    }
    if (quality.score < 90) {
      result.add(
        StatisticsInsight(
          title: 'Полнота статистики — ${quality.score}%',
          explanation:
              '${quality.issues.length} операций или признаков требуют проверки.',
          calculation: 'Оценка учитывает вес каждой проблемы качества данных.',
          type: StatisticsInsightType.quality,
          priority: 90,
        ),
      );
    }
    result.sort((a, b) => b.priority.compareTo(a.priority));
    return result;
  }
}
