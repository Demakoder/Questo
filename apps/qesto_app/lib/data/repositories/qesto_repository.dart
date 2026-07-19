import '../models/qesto_models.dart';

abstract class QestoRepository {
  const QestoRepository();

  Future<QestoUser> getUser();
  Future<BudgetStatement> getBudgetStatement();
  Future<List<QestoAccount>> getAccounts();
  Future<List<Deal>> getCoupons();
  Future<List<Deal>> getPromotions();
  Future<List<TrackedProduct>> getTrackedProducts();
  Future<List<SavingsGoal>> getSavingsGoals();

  Future<QestoAppData> loadAppData() async {
    final values = await Future.wait<Object>([
      getUser(),
      getBudgetStatement(),
      getAccounts(),
      getCoupons(),
      getPromotions(),
      getTrackedProducts(),
      getSavingsGoals(),
    ]);

    return QestoAppData(
      user: values[0] as QestoUser,
      budgetStatement: values[1] as BudgetStatement,
      accounts: values[2] as List<QestoAccount>,
      coupons: values[3] as List<Deal>,
      promotions: values[4] as List<Deal>,
      trackedProducts: values[5] as List<TrackedProduct>,
      savingsGoals: values[6] as List<SavingsGoal>,
    );
  }
}
