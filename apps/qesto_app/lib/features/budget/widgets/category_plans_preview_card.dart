import 'package:flutter/material.dart';

import '../../../core/widgets/qesto_card.dart';
import '../../../core/widgets/states.dart';
import '../services/category_budget_calculation_service.dart';
import 'category_plan_row.dart';

class CategoryPlansPreviewCard extends StatelessWidget {
  const CategoryPlansPreviewCard({
    required this.plans,
    required this.currency,
    required this.onCategoryTap,
    required this.onShowAll,
    super.key,
  });

  final List<CategoryPlanStatus> plans;
  final String currency;
  final ValueChanged<CategoryPlanStatus> onCategoryTap;
  final VoidCallback onShowAll;

  @override
  Widget build(BuildContext context) {
    return QestoCard(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Планы по категориям',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          if (plans.isEmpty)
            const EmptyState(message: 'Планы по категориям ещё не настроены')
          else
            for (var index = 0; index < plans.take(4).length; index++) ...[
              CategoryPlanRow(
                status: plans[index],
                currency: currency,
                onTap: () => onCategoryTap(plans[index]),
              ),
              if (index < plans.take(4).length - 1) const Divider(height: 1),
            ],
          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              key: const Key('show-all-category-plans'),
              onPressed: onShowAll,
              child: const Text('Показать все'),
            ),
          ),
        ],
      ),
    );
  }
}
