import 'package:flutter/material.dart';

import '../core/theme/qesto_theme.dart';
import '../core/widgets/qesto_bottom_navigation.dart';
import '../core/widgets/qesto_card.dart';
import '../core/widgets/sticky_app_header.dart';
import '../data/models/qesto_models.dart';
import '../features/benefits/benefits_screen.dart';
import '../features/budget/budget_screen.dart';
import '../features/budget/state/budget_controller.dart';
import '../features/savings/savings_screen.dart';
import '../features/shared/placeholder_screen.dart';

class QestoAppShell extends StatefulWidget {
  const QestoAppShell({required this.data, super.key});

  final QestoAppData data;

  @override
  State<QestoAppShell> createState() => _QestoAppShellState();
}

class _QestoAppShellState extends State<QestoAppShell> {
  final _budgetKey = GlobalKey<BudgetScreenState>();
  final _benefitsKey = GlobalKey<BenefitsScreenState>();
  final _savingsKey = GlobalKey<SavingsScreenState>();
  var _selectedIndex = 0;
  late final BudgetController _budgetController;

  static const _titles = ['Бюджет', 'Выгода', 'Накопления'];

  @override
  void initState() {
    super.initState();
    _budgetController = BudgetController(
      statement: widget.data.budgetStatement,
      accounts: widget.data.accounts,
    );
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  void _selectDestination(int index) {
    if (index == _selectedIndex) {
      switch (index) {
        case 0:
          _budgetKey.currentState?.scrollToTop();
        case 1:
          _benefitsKey.currentState?.scrollToTop();
        case 2:
          _savingsKey.currentState?.scrollToTop();
      }
      return;
    }
    setState(() => _selectedIndex = index);
  }

  void _openNotifications() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const PlaceholderScreen(
          title: 'Уведомления',
          description: 'Новые советы и важные события появятся здесь',
          icon: Icons.notifications_none_rounded,
        ),
      ),
    );
  }

  void _openProfile() {
    final user = widget.data.user;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PlaceholderScreen(
          title: 'Профиль',
          description: 'Настройки профиля будут добавлены позднее',
          icon: Icons.person_outline_rounded,
          child: QestoCard(
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: const BoxDecoration(
                    color: QestoColors.primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: QestoColors.primary,
                    size: 34,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Основная валюта: ${user.defaultCurrency}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    return Scaffold(
      appBar: StickyAppHeader(
        title: _titles[_selectedIndex],
        user: data.user,
        onNotificationsPressed: _openNotifications,
        onProfilePressed: _openProfile,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          BudgetScreen(key: _budgetKey, controller: _budgetController),
          BenefitsScreen(
            key: _benefitsKey,
            coupons: data.coupons,
            promotions: data.promotions,
            trackedProducts: data.trackedProducts,
          ),
          SavingsScreen(key: _savingsKey, goals: data.savingsGoals),
        ],
      ),
      bottomNavigationBar: QestoBottomNavigation(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectDestination,
      ),
    );
  }
}
