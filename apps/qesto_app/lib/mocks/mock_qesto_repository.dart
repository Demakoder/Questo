import '../data/models/qesto_models.dart';
import '../data/repositories/qesto_repository.dart';
import 'fixtures/mock_accounts.dart';
import 'fixtures/mock_budget_statement.dart';
import 'fixtures/mock_deals.dart';
import 'fixtures/mock_savings.dart';
import 'fixtures/mock_user.dart';

class MockQestoRepository extends QestoRepository {
  const MockQestoRepository({this.delay = const Duration(milliseconds: 220)});

  final Duration delay;

  Future<T> _respond<T>(T value) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    return value;
  }

  @override
  Future<List<QestoAccount>> getAccounts() => _respond(mockAccounts);

  @override
  Future<BudgetStatement> getBudgetStatement() => _respond(mockBudgetStatement);

  @override
  Future<List<Deal>> getCoupons() => _respond(mockCoupons);

  @override
  Future<List<Deal>> getPromotions() => _respond(mockPromotions);

  @override
  Future<List<SavingsGoal>> getSavingsGoals() => _respond(mockSavingsGoals);

  @override
  Future<List<TrackedProduct>> getTrackedProducts() =>
      _respond(mockTrackedProducts);

  @override
  Future<QestoUser> getUser() => _respond(mockUser);
}
