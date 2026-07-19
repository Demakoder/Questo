import '../../data/models/qesto_models.dart';

final mockSavingsGoals = <SavingsGoal>[
  SavingsGoal(
    id: 'goal-home',
    userId: 'demo-user',
    title: 'Первоначальный взнос на дом',
    targetAmount: 600000,
    savedAmount: 467000,
    currency: 'RUB',
    streakWeeks: 64,
    isActive: true,
    history: [
      SavingsHistoryPoint(date: DateTime(2026, 3, 1), amount: 340000),
      SavingsHistoryPoint(date: DateTime(2026, 4, 1), amount: 378000),
      SavingsHistoryPoint(date: DateTime(2026, 5, 1), amount: 412000),
      SavingsHistoryPoint(date: DateTime(2026, 6, 1), amount: 441000),
      SavingsHistoryPoint(date: DateTime(2026, 7, 1), amount: 467000),
    ],
  ),
  const SavingsGoal(
    id: 'goal-travel',
    userId: 'demo-user',
    title: 'Путешествие',
    targetAmount: 180000,
    savedAmount: 24000,
    currency: 'RUB',
    streakWeeks: 8,
    isActive: false,
    history: [],
  ),
];
