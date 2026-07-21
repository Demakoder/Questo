import '../domain/parsed_bank_transaction.dart';

class MerchantCategoryClassifier {
  const MerchantCategoryClassifier();

  CategorySuggestion classify(String merchant) {
    final value = _normalize(merchant);

    if (_containsAny(value, const [
      'burger king',
      'бургер кинг',
      'kfc',
      'ростикс',
      'вкусно и точка',
      'mcdonald',
    ])) {
      return const CategorySuggestion(
        categoryId: 'cafes',
        subcategoryId: 'Фастфуд',
      );
    }

    if (_containsAny(value, const [
      'пятерочка',
      'перекресток',
      'вкусвилл',
      'магнит',
    ])) {
      return const CategorySuggestion(
        categoryId: 'groceries',
        subcategoryId: 'Супермаркеты',
      );
    }

    return const CategorySuggestion(categoryId: 'other');
  }

  bool _containsAny(String value, List<String> patterns) =>
      patterns.any(value.contains);

  String _normalize(String value) => value
      .toLowerCase()
      .replaceAll('ё', 'е')
      .replaceAll(RegExp('[^a-zа-я0-9]+'), ' ')
      .trim();
}
