import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/formatters/qesto_formatters.dart';
import '../../../../core/theme/qesto_theme.dart';
import '../../../../core/widgets/qesto_card.dart';
import '../../../../core/widgets/states.dart';
import '../../../../data/models/qesto_models.dart';
import '../../domain/models/statistics_models.dart';
import '../screens/statistics_drilldown_screens.dart';
import '../state/statistics_controller.dart';
import '../widgets/statistics_charts.dart';
import '../widgets/statistics_components.dart';

class OverviewStatisticsSection extends StatelessWidget {
  const OverviewStatisticsSection({
    required this.controller,
    required this.scrollController,
    super.key,
  });

  final StatisticsController controller;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final snapshot = controller.snapshot;
    if (snapshot.transactions.isEmpty) {
      return _empty(scrollController);
    }
    return ListView(
      controller: scrollController,
      key: const PageStorageKey('statistics-overview'),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
      children: [
        StatisticsMetricStrip(
          items: [
            StatisticsMetricItem(
              label: 'Расходы',
              value: formatMoney(snapshot.summary.expenses, 'RUB'),
              caption: statisticsRangeLabel(controller.query.period),
              icon: Icons.account_balance_wallet_outlined,
            ),
            StatisticsMetricItem(
              label: 'Доходы',
              value: formatMoney(snapshot.summary.income, 'RUB'),
              caption: 'без возвратов',
              icon: Icons.trending_up_rounded,
              valueColor: const Color(0xFF168C4A),
            ),
            StatisticsMetricItem(
              label: 'Остаток',
              value: formatMoney(snapshot.summary.balance, 'RUB'),
              caption: 'доходы − расходы − накопления',
              icon: Icons.savings_outlined,
            ),
            StatisticsMetricItem(
              label: 'Обычный чек',
              value: formatMoney(snapshot.summary.medianCheck.round(), 'RUB'),
              caption: 'половина покупок дешевле',
              icon: Icons.receipt_long_outlined,
            ),
          ],
        ),
        const SizedBox(height: 16),
        StatisticsPeriodBarsCard(
          title: 'Финансовая динамика',
          points: snapshot.periods,
        ),
        const SizedBox(height: 16),
        _ChangeReasonsCard(controller: controller),
        const SizedBox(height: 16),
        StatisticsGroupList(
          title: 'Крупнейшие категории',
          items: snapshot.categories,
          onTap: (item) => _openCategory(context, item.id),
          onShowAll: () =>
              controller.selectSection(StatisticsSection.categories),
        ),
        const SizedBox(height: 16),
        StatisticsGroupList(
          title: 'Крупнейшие продавцы',
          items: snapshot.merchants,
          onTap: (item) => _openMerchant(context, item.id),
          onShowAll: () =>
              controller.selectSection(StatisticsSection.merchants),
        ),
        const SizedBox(height: 16),
        StatisticsInsightsCard(
          insights: snapshot.insights,
          onDetails: (insight) => showInsightCalculation(context, insight),
        ),
      ],
    );
  }

  Widget _empty(ScrollController scrollController) => ListView(
    controller: scrollController,
    padding: const EdgeInsets.all(18),
    children: const [
      EmptyState(message: 'В выбранном периоде пока нет операций'),
    ],
  );

  void _openCategory(BuildContext context, String id) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            StatisticsCategoryScreen(controller: controller, categoryId: id),
      ),
    );
  }

  void _openMerchant(BuildContext context, String id) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            StatisticsMerchantScreen(controller: controller, merchant: id),
      ),
    );
  }
}

class ExpensesStatisticsSection extends StatelessWidget {
  const ExpensesStatisticsSection({
    required this.controller,
    required this.scrollController,
    super.key,
  });

  final StatisticsController controller;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final snapshot = controller.snapshot;
    if (snapshot.summary.purchaseCount == 0) {
      return ListView(
        controller: scrollController,
        padding: const EdgeInsets.all(18),
        children: const [
          EmptyState(message: 'В выбранном периоде пока нет расходов'),
        ],
      );
    }
    final change = snapshot.summary.changePercent;
    final avgChange = snapshot.summary.averageCheckChange;
    return ListView(
      controller: scrollController,
      key: const PageStorageKey('statistics-expenses'),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 30),
      children: [
        StatisticsMetricStrip(
          items: [
            StatisticsMetricItem(
              label: 'Расходы',
              value: formatMoney(snapshot.summary.expenses, 'RUB'),
              caption: 'за выбранный период',
              icon: Icons.account_balance_wallet_outlined,
            ),
            StatisticsMetricItem(
              label: 'Изменение',
              value: change == null
                  ? '—'
                  : '${change >= 0 ? '↑' : '↓'} ${change.abs().toStringAsFixed(1)}%',
              caption: 'к периоду такой же длины',
              icon: Icons.trending_up_rounded,
              valueColor: change == null
                  ? QestoColors.secondaryText
                  : const Color(0xFF168C4A),
            ),
            StatisticsMetricItem(
              label: 'Средний чек',
              value: formatMoney(snapshot.summary.averageCheck.round(), 'RUB'),
              caption: avgChange == null
                  ? 'нет сравнения'
                  : '${avgChange >= 0 ? '↑' : '↓'} ${avgChange.abs().toStringAsFixed(1)}% к периоду',
              icon: Icons.receipt_long_outlined,
            ),
          ],
        ),
        const SizedBox(height: 16),
        StatisticsLineChartCard(
          title: 'Динамика расходов',
          points: snapshot.daily,
          comparison: snapshot.comparisonDaily,
        ),
        const SizedBox(height: 16),
        StatisticsGroupList(
          title: 'Расходы по категориям',
          items: snapshot.categories,
          onTap: (item) => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => StatisticsCategoryScreen(
                controller: controller,
                categoryId: item.id,
              ),
            ),
          ),
          onShowAll: () =>
              controller.selectSection(StatisticsSection.categories),
        ),
        const SizedBox(height: 16),
        _ChangeReasonsCard(controller: controller),
        const SizedBox(height: 16),
        _LargePurchasesCard(controller: controller),
        const SizedBox(height: 16),
        _AmountBucketsCard(snapshot: snapshot),
        const SizedBox(height: 16),
        _LargestTransactionsCard(controller: controller),
      ],
    );
  }
}

class _ChangeReasonsCard extends StatelessWidget {
  const _ChangeReasonsCard({required this.controller});

  final StatisticsController controller;

  @override
  Widget build(BuildContext context) {
    final categories =
        controller.snapshot.categories
            .where((item) => item.changePercent != null)
            .toList()
          ..sort(
            (a, b) => _difference(b).abs().compareTo(_difference(a).abs()),
          );
    final totalChange = controller.snapshot.summary.changePercent;
    return QestoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StatisticsSectionHeader(title: 'Почему показатель изменился'),
          const SizedBox(height: 5),
          Text(
            totalChange == null
                ? 'Для сравнения недостаточно данных'
                : 'Расходы ${totalChange >= 0 ? 'выросли' : 'снизились'} на ${totalChange.abs().toStringAsFixed(1)}%',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          if (categories.isEmpty)
            const StatisticsInfoBanner(
              message:
                  'Добавьте данные предыдущего периода, чтобы увидеть причины',
            )
          else
            for (final category in categories.take(4))
              InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => StatisticsCategoryScreen(
                      controller: controller,
                      categoryId: category.id,
                    ),
                  ),
                ),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 9,
                        height: 9,
                        decoration: BoxDecoration(
                          color: Color(
                            category.colorValue ??
                                QestoColors.primary.toARGB32(),
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          category.label,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        formatMoney(
                          _difference(category),
                          'RUB',
                          showSign: true,
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: _difference(category) >= 0
                              ? const Color(0xFF168C4A)
                              : QestoColors.danger,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: QestoColors.secondaryText,
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }

  int _difference(StatisticsGroupStat item) {
    final change = item.changePercent;
    if (change == null || change <= -100) return 0;
    final previous = item.amount / (1 + change / 100);
    return (item.amount - previous).round();
  }
}

class _LargePurchasesCard extends StatelessWidget {
  const _LargePurchasesCard({required this.controller});
  final StatisticsController controller;

  @override
  Widget build(BuildContext context) {
    final all = controller.snapshot.transactions;
    final large = all
        .where(
          (item) =>
              item.type == TransactionType.expense &&
              controller.calculationService.isLargePurchase(item, all),
        )
        .toList();
    final largeAmount = large.fold<int>(0, (sum, item) => sum + item.amount);
    final ordinary = math.max(
      controller.snapshot.summary.expenses - largeAmount,
      0,
    );
    final total = math.max(largeAmount + ordinary, 1);
    return QestoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StatisticsSectionHeader(title: 'Крупные и обычные покупки'),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Expanded(
                  flex: math.max(ordinary, 1),
                  child: Container(height: 15, color: QestoColors.primary),
                ),
                Expanded(
                  flex: math.max(largeAmount, 1),
                  child: Container(height: 15, color: QestoColors.orange),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _LegendAmount(
            color: QestoColors.primary,
            label: 'Обычные',
            amount: ordinary,
            share: ordinary / total,
          ),
          const SizedBox(height: 8),
          _LegendAmount(
            color: QestoColors.orange,
            label: 'Крупные',
            amount: largeAmount,
            share: largeAmount / total,
          ),
          const SizedBox(height: 12),
          Text(
            'Автоматическая отметка крупной покупки используется только для подтверждённых операций.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _LegendAmount extends StatelessWidget {
  const _LegendAmount({
    required this.color,
    required this.label,
    required this.amount,
    required this.share,
  });
  final Color color;
  final String label;
  final int amount;
  final double share;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 8),
      Expanded(child: Text(label)),
      Text(
        '${formatMoney(amount, 'RUB')} · ${(share * 100).round()}%',
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ],
  );
}

class _AmountBucketsCard extends StatelessWidget {
  const _AmountBucketsCard({required this.snapshot});
  final StatisticsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final maxCount = snapshot.buckets.fold<int>(
      1,
      (value, item) => math.max(value, item.count),
    );
    return QestoCard(
      child: Column(
        children: [
          const StatisticsSectionHeader(title: 'Покупки по сумме'),
          const SizedBox(height: 10),
          for (final bucket in snapshot.buckets)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                children: [
                  SizedBox(
                    width: 108,
                    child: Text(
                      bucket.label,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: LinearProgressIndicator(
                        value: bucket.count / maxCount,
                        minHeight: 8,
                        backgroundColor: QestoColors.border,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 32,
                    child: Text(
                      '${bucket.count}',
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          StatisticsInfoBanner(
            message: snapshot.buckets.isEmpty
                ? 'Недостаточно данных'
                : '${snapshot.buckets.first.count} покупок дешевле 300 ₽ составили ${formatMoney(snapshot.buckets.first.amount, 'RUB')}',
          ),
        ],
      ),
    );
  }
}

class _LargestTransactionsCard extends StatelessWidget {
  const _LargestTransactionsCard({required this.controller});
  final StatisticsController controller;

  @override
  Widget build(BuildContext context) {
    final items = controller.snapshot.largestTransactions;
    return QestoCard(
      child: Column(
        children: [
          StatisticsSectionHeader(
            title: 'Крупнейшие операции',
            actionLabel: 'Все',
            onAction: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => StatisticsOperationsScreen(
                  controller: controller,
                  title: 'Все расходы',
                  transactions: controller.snapshot.transactions
                      .where((item) => item.type == TransactionType.expense)
                      .toList(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          for (final transaction in items)
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => StatisticsOperationsScreen(
                    controller: controller,
                    title: transaction.title ?? 'Операция',
                    transactions: [transaction],
                  ),
                ),
              ),
              leading: const CircleAvatar(
                backgroundColor: QestoColors.primarySoft,
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: QestoColors.primary,
                ),
              ),
              title: Text(
                controller.calculationService.merchantName(transaction),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(formatDate(transaction.date)),
              trailing: Text(
                formatMoney(transaction.amount, transaction.currency),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
        ],
      ),
    );
  }
}

Future<void> showInsightCalculation(
  BuildContext context,
  StatisticsInsight insight,
) => showModalBottomSheet<void>(
  context: context,
  useSafeArea: true,
  showDragHandle: true,
  builder: (context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(insight.title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Text(insight.explanation, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        const Text(
          'Как рассчитано',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        Text(
          insight.calculation,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: QestoColors.secondaryText),
        ),
      ],
    ),
  ),
);
