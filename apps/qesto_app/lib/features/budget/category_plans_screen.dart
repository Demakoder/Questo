import 'package:flutter/material.dart';

import '../../core/widgets/nested_screen_header.dart';
import '../../core/widgets/qesto_card.dart';
import '../../core/widgets/states.dart';
import '../../data/models/qesto_models.dart';
import 'category_details_screen.dart';
import 'services/category_budget_calculation_service.dart';
import 'state/budget_controller.dart';
import 'widgets/category_plan_row.dart';

enum CategoryPlanSort { spending, progress, exceeded, alphabet }

class CategoryPlansScreen extends StatefulWidget {
  const CategoryPlansScreen({
    required this.controller,
    required this.period,
    super.key,
  });

  final BudgetController controller;
  final BudgetPeriod period;

  @override
  State<CategoryPlansScreen> createState() => _CategoryPlansScreenState();
}

class _CategoryPlansScreenState extends State<CategoryPlansScreen> {
  var _sort = CategoryPlanSort.spending;

  List<CategoryPlanStatus> _sorted(List<CategoryPlanStatus> input) {
    final result = List.of(input);
    switch (_sort) {
      case CategoryPlanSort.spending:
        result.sort((a, b) => b.spentAmount.compareTo(a.spentAmount));
      case CategoryPlanSort.progress:
        result.sort((a, b) => b.progress.compareTo(a.progress));
      case CategoryPlanSort.exceeded:
        result.sort((a, b) {
          final comparison = b.isExceeded.toString().compareTo(
            a.isExceeded.toString(),
          );
          return comparison == 0
              ? b.progress.compareTo(a.progress)
              : comparison;
        });
      case CategoryPlanSort.alphabet:
        result.sort((a, b) => a.category.name.compareTo(b.category.name));
    }
    return result;
  }

  void _openCategory(BuildContext context, CategoryPlanStatus status) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CategoryDetailsScreen(
          controller: widget.controller,
          period: widget.period,
          categoryId: status.category.id,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NestedScreenHeader(
        title: Text(
          'Планы по категориям',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final plans = _sorted(
            widget.controller.categoryPlansFor(widget.period),
          );
          return ListView(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
            children: [
              DropdownButtonFormField<CategoryPlanSort>(
                initialValue: _sort,
                decoration: const InputDecoration(
                  labelText: 'Сортировка',
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: CategoryPlanSort.spending,
                    child: Text('По размеру расходов'),
                  ),
                  DropdownMenuItem(
                    value: CategoryPlanSort.progress,
                    child: Text('По проценту выполнения'),
                  ),
                  DropdownMenuItem(
                    value: CategoryPlanSort.exceeded,
                    child: Text('Сначала превышения'),
                  ),
                  DropdownMenuItem(
                    value: CategoryPlanSort.alphabet,
                    child: Text('По алфавиту'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _sort = value);
                },
              ),
              const SizedBox(height: 14),
              if (plans.isEmpty)
                const EmptyState(
                  message: 'Планы по категориям ещё не настроены',
                )
              else
                QestoCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  child: Column(
                    children: [
                      for (var index = 0; index < plans.length; index++) ...[
                        CategoryPlanRow(
                          status: plans[index],
                          currency: widget.period.currency,
                          onTap: () => _openCategory(context, plans[index]),
                        ),
                        if (index < plans.length - 1) const Divider(height: 1),
                      ],
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
