export 'budget_models.dart';

import 'budget_models.dart';

enum AccountType {
  cash,
  bankCard,
  savings,
  deposit,
  investment,
  receivable,
  liability,
  other,
}

enum DealKind { coupon, promotion }

class QestoUser {
  const QestoUser({
    required this.id,
    required this.name,
    required this.defaultCurrency,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final String defaultCurrency;
  final String? avatarUrl;
}

class QestoAccount {
  const QestoAccount({
    required this.id,
    required this.userId,
    required this.title,
    required this.balance,
    required this.currency,
    required this.type,
  });

  final String id;
  final String userId;
  final String title;
  final int balance;
  final String currency;
  final AccountType type;
}

class Deal {
  const Deal({
    required this.id,
    required this.userId,
    required this.kind,
    required this.category,
    required this.title,
    required this.description,
    required this.visualKey,
    this.badge,
  });

  final String id;
  final String userId;
  final DealKind kind;
  final String category;
  final String title;
  final String description;
  final String visualKey;
  final String? badge;
}

class TrackedProduct {
  const TrackedProduct({
    required this.id,
    required this.userId,
    required this.title,
    required this.currentPrice,
    required this.currency,
    required this.bestMarketplace,
    required this.changePercent,
    required this.trackedStoresCount,
    required this.visualKey,
  });

  final String id;
  final String userId;
  final String title;
  final int currentPrice;
  final String currency;
  final String bestMarketplace;
  final double changePercent;
  final int trackedStoresCount;
  final String visualKey;
}

class SavingsHistoryPoint {
  const SavingsHistoryPoint({required this.date, required this.amount});

  final DateTime date;
  final int amount;
}

class SavingsGoal {
  const SavingsGoal({
    required this.id,
    required this.userId,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.currency,
    required this.streakWeeks,
    required this.isActive,
    required this.history,
  });

  final String id;
  final String userId;
  final String title;
  final int targetAmount;
  final int savedAmount;
  final String currency;
  final int streakWeeks;
  final bool isActive;
  final List<SavingsHistoryPoint> history;

  double get progress => targetAmount == 0 ? 0 : savedAmount / targetAmount;
}

class QestoAppData {
  const QestoAppData({
    required this.user,
    required this.budgetStatement,
    required this.accounts,
    required this.coupons,
    required this.promotions,
    required this.trackedProducts,
    required this.savingsGoals,
  });

  final QestoUser user;
  final BudgetStatement budgetStatement;
  final List<QestoAccount> accounts;
  final List<Deal> coupons;
  final List<Deal> promotions;
  final List<TrackedProduct> trackedProducts;
  final List<SavingsGoal> savingsGoals;
}
