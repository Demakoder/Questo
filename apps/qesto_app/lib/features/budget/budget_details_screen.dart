import 'package:flutter/material.dart';

import '../../core/widgets/nested_screen_header.dart';
import '../../data/models/qesto_models.dart';
import 'category_details_screen.dart';
import 'category_plans_screen.dart';
import 'services/category_budget_calculation_service.dart';
import 'state/budget_controller.dart';
import 'upcoming_expense_editor.dart';
import 'upcoming_expenses_screen.dart';
import 'widgets/budget_dynamics_card.dart';
import 'widgets/budget_metrics_card.dart';
import 'widgets/budget_period_selector.dart';
import 'widgets/category_plans_preview_card.dart';
import 'widgets/upcoming_expenses_preview_card.dart';

class BudgetDetailsScreen extends StatefulWidget {
  const BudgetDetailsScreen({
    required this.controller,
    required this.initialPeriodId,
    super.key,
  });

  final BudgetController controller;
  final String initialPeriodId;

  @override
  State<BudgetDetailsScreen> createState() => _BudgetDetailsScreenState();
}

class _BudgetDetailsScreenState extends State<BudgetDetailsScreen> {
  late int _periodIndex;

  BudgetPeriod get _period => widget.controller.periods[_periodIndex];

  @override
  void initState() {
    super.initState();
    final index = widget.controller.periods.indexWhere(
      (period) => period.id == widget.initialPeriodId,
    );
    _periodIndex = index < 0 ? 0 : index;
  }

  void _changePeriod(int delta) {
    final next = (_periodIndex + delta).clamp(
      0,
      widget.controller.periods.length - 1,
    );
    if (next != _periodIndex) setState(() => _periodIndex = next);
  }

  void _openCategory(CategoryPlanStatus status) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => CategoryDetailsScreen(
          controller: widget.controller,
          period: _period,
          categoryId: status.category.id,
        ),
      ),
    );
  }

  void _openAllCategories() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            CategoryPlansScreen(controller: widget.controller, period: _period),
      ),
    );
  }

  void _openUpcomingEditor([UpcomingExpense? expense]) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => UpcomingExpenseEditor(
          controller: widget.controller,
          period: _period,
          expense: expense,
        ),
      ),
    );
  }

  void _openAllUpcoming() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => UpcomingExpensesScreen(
          controller: widget.controller,
          period: _period,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NestedScreenHeader(
        centerTitle: true,
        title: BudgetPeriodSelector(
          period: _period,
          hasPrevious: _periodIndex > 0,
          hasNext: _periodIndex < widget.controller.periods.length - 1,
          onPrevious: () => _changePeriod(-1),
          onNext: () => _changePeriod(1),
          large: true,
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final period = _period;
          final summary = widget.controller.summaryFor(period);
          final activeDate = widget.controller.activeDateFor(period);
          final categoryPlans = widget.controller.categoryPlansFor(period);
          final upcoming = widget.controller.upcomingFor(period);
          return ListView(
            key: PageStorageKey('budget-details-${period.id}'),
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
            children: [
              BudgetMetricsCard(
                period: period,
                currentExpense: summary.currentExpense,
                planAtDate: widget.controller.plannedAtActiveDate(period),
                allowedDailyExpense: widget.controller.allowedDailyExpense(
                  period,
                ),
                activeDate: activeDate,
              ),
              const SizedBox(height: 16),
              BudgetDynamicsCard(
                period: period,
                forecast: widget.controller.forecastFor(period),
              ),
              const SizedBox(height: 16),
              CategoryPlansPreviewCard(
                plans: categoryPlans,
                currency: period.currency,
                onCategoryTap: _openCategory,
                onShowAll: _openAllCategories,
              ),
              const SizedBox(height: 16),
              UpcomingExpensesPreviewCard(
                expenses: upcoming,
                onAdd: _openUpcomingEditor,
                onExpenseTap: _openUpcomingEditor,
                onShowAll: _openAllUpcoming,
              ),
            ],
          );
        },
      ),
    );
  }
}
