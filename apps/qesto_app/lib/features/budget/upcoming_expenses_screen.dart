import 'package:flutter/material.dart';

import '../../core/widgets/nested_screen_header.dart';
import '../../core/widgets/states.dart';
import '../../data/models/qesto_models.dart';
import 'state/budget_controller.dart';
import 'upcoming_expense_editor.dart';
import 'widgets/upcoming_expense_row.dart';

class UpcomingExpensesScreen extends StatelessWidget {
  const UpcomingExpensesScreen({
    required this.controller,
    required this.period,
    super.key,
  });

  final BudgetController controller;
  final BudgetPeriod period;

  void _openEditor(BuildContext context, [UpcomingExpense? expense]) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => UpcomingExpenseEditor(
          controller: controller,
          period: period,
          expense: expense,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NestedScreenHeader(
        title: Text(
          'Предстоящие траты',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Добавить'),
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          final expenses = controller.upcomingFor(period);
          if (expenses.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(18),
              child: EmptyState(
                message: 'Предстоящих трат пока нет',
                icon: Icons.event_available_outlined,
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(18, 12, 18, 100),
            itemCount: expenses.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return UpcomingExpenseRow(
                expense: expense,
                onTap: () => _openEditor(context, expense),
              );
            },
          );
        },
      ),
    );
  }
}
