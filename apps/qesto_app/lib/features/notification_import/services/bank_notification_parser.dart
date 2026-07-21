import '../data/notification_capture_service.dart';
import '../domain/parsed_bank_transaction.dart';
import 'merchant_category_classifier.dart';

abstract interface class BankNotificationParser {
  ParsedBankTransaction? parse(CapturedNotification notification);
}

class SberbankNotificationParser implements BankNotificationParser {
  const SberbankNotificationParser({
    this.classifier = const MerchantCategoryClassifier(),
  });

  final MerchantCategoryClassifier classifier;

  static final _purchaseTitle = RegExp(
    r'^покупка\s+(.+)$',
    caseSensitive: false,
  );
  static final _money = RegExp(
    r'(\d[\d\s\u00A0\u202F]*)(?:[,.](\d{1,2}))?\s*(?:₽|руб\.?|RUB)',
    caseSensitive: false,
  );
  static final _account = RegExp(
    r'сч[её]т\s+карты\s+([^\r\n]+)',
    caseSensitive: false,
  );

  @override
  ParsedBankTransaction? parse(CapturedNotification notification) {
    if (notification.packageName.toLowerCase() != 'ru.sberbankmobile') {
      return null;
    }

    final titleMatch = _purchaseTitle.firstMatch(notification.title.trim());
    final merchant = titleMatch?.group(1)?.trim();
    if (merchant == null || merchant.isEmpty) return null;

    final lowerText = notification.text.toLowerCase();
    final balanceIndex = lowerText.indexOf('баланс:');
    final transactionPart = balanceIndex < 0
        ? notification.text
        : notification.text.substring(0, balanceIndex);
    final amountMatch = _money.firstMatch(transactionPart);
    if (amountMatch == null) return null;

    final whole = int.tryParse(
      amountMatch.group(1)!.replaceAll(RegExp(r'[\s\u00A0\u202F]'), ''),
    );
    if (whole == null) return null;

    final fractionText = amountMatch.group(2);
    final fraction = switch (fractionText?.length) {
      null || 0 => 0,
      1 => int.parse(fractionText!) * 10,
      _ => int.parse(fractionText!),
    };
    final suggestion = classifier.classify(merchant);
    final accountHint = _account
        .firstMatch(notification.text)
        ?.group(1)
        ?.trim();

    return ParsedBankTransaction(
      notificationKey: notification.notificationKey,
      sourcePackage: notification.packageName,
      date: notification.postedAt,
      amountMinor: whole * 100 + fraction,
      currency: 'RUB',
      merchant: merchant,
      categoryId: suggestion.categoryId,
      subcategoryId: suggestion.subcategoryId,
      accountHint: accountHint,
      confidence: suggestion.categoryId == 'other' ? 0.82 : 0.98,
    );
  }
}
