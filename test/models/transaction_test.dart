import 'package:flutter_test/flutter_test.dart';
import 'package:demo2/data/models/transaction.dart';
import 'package:demo2/data/models/balance.dart';

void main() {
  group('TransactionType', () {
    test('apiValue возвращает корректные значения', () {
      expect(TransactionType.expense.apiValue, 'expense');
      expect(TransactionType.income.apiValue, 'income');
      expect(TransactionType.transfer.apiValue, 'transfer');
    });

    test('fromValue парсит значения', () {
      expect(TransactionTypeX.fromValue('expense'), TransactionType.expense);
      expect(TransactionTypeX.fromValue('income'), TransactionType.income);
      expect(TransactionTypeX.fromValue('transfer'), TransactionType.transfer);
    });

    test('fromValue возвращает expense для отрицательной суммы по умолчанию', () {
      expect(TransactionTypeX.fromValue(null, amount: -100), TransactionType.expense);
    });

    test('fromValue возвращает income для положительной суммы по умолчанию', () {
      expect(TransactionTypeX.fromValue(null, amount: 100), TransactionType.income);
    });

    test('fromValue возвращает transfer для нулевой суммы по умолчанию', () {
      expect(TransactionTypeX.fromValue(null, amount: 0), TransactionType.transfer);
    });
  });

  group('TransactionCategory', () {
    test('apiValue возвращает корректные значения', () {
      expect(TransactionCategory.food.apiValue, 'food');
      expect(TransactionCategory.transport.apiValue, 'transport');
      expect(TransactionCategory.salary.apiValue, 'salary');
    });

    test('fromValue находит категорию', () {
      expect(TransactionCategoryX.fromValue('food'), TransactionCategory.food);
      expect(TransactionCategoryX.fromValue('transport'), TransactionCategory.transport);
    });

    test('fromValue возвращает other для неизвестного значения', () {
      expect(TransactionCategoryX.fromValue('unknown'), TransactionCategory.other);
    });

    test('localizedLabel возвращает русский перевод', () {
      expect(TransactionCategory.food.localizedLabel('ru'), 'Еда');
      expect(TransactionCategory.transport.localizedLabel('ru'), 'Транспорт');
      expect(TransactionCategory.salary.localizedLabel('ru'), 'Доход');
    });

    test('localizedLabel возвращает английский перевод', () {
      expect(TransactionCategory.food.localizedLabel('en'), 'Food');
      expect(TransactionCategory.transport.localizedLabel('en'), 'Transport');
    });

    test('expenseValues содержит только категории расходов', () {
      expect(TransactionCategoryX.expenseValues, isNot(contains(TransactionCategory.salary)));
      expect(TransactionCategoryX.expenseValues, contains(TransactionCategory.food));
      expect(TransactionCategoryX.expenseValues, contains(TransactionCategory.other));
    });
  });

  group('TransactionModel', () {
    test('создается из JSON с обязательными полями', () {
      final json = {
        'id': 'tx_123',
        'title': 'Coffee Shop',
        'amount': 5.50,
        'currency': 'USD',
        'category': 'food',
        'type': 'expense',
        'createdAt': '2026-03-28T10:00:00.000Z',
      };

      final transaction = TransactionModel.fromJson(json);

      expect(transaction.id, 'tx_123');
      expect(transaction.title, 'Coffee Shop');
      expect(transaction.amount, 5.50);
      expect(transaction.currency, SupportedCurrency.usd);
      expect(transaction.category, TransactionCategory.food);
      expect(transaction.type, TransactionType.expense);
    });

    test('использует merchant как fallback для title', () {
      final json = {
        'id': 'tx_1',
        'merchant': 'Magnum',
        'amount': 100,
        'currency': 'USD',
        'category': 'food',
        'type': 'expense',
        'createdAt': '2026-03-28T10:00:00.000Z',
      };

      final transaction = TransactionModel.fromJson(json);

      expect(transaction.title, 'Magnum');
    });

    test('использует name как fallback для title', () {
      final json = {
        'id': 'tx_1',
        'name': 'Transaction Name',
        'amount': 100,
        'currency': 'USD',
        'category': 'food',
        'type': 'expense',
        'createdAt': '2026-03-28T10:00:00.000Z',
      };

      final transaction = TransactionModel.fromJson(json);

      expect(transaction.title, 'Transaction Name');
    });

    test('использует kind как fallback для type', () {
      final json = {
        'id': 'tx_1',
        'title': 'Test',
        'amount': 100,
        'currency': 'USD',
        'category': 'food',
        'kind': 'income',
        'createdAt': '2026-03-28T10:00:00.000Z',
      };

      final transaction = TransactionModel.fromJson(json);

      expect(transaction.type, TransactionType.income);
    });

    test('использует occurredAt как fallback для createdAt', () {
      final json = {
        'id': 'tx_1',
        'title': 'Test',
        'amount': 100,
        'currency': 'USD',
        'category': 'food',
        'type': 'expense',
        'occurredAt': '2026-03-27T15:00:00.000Z',
      };

      final transaction = TransactionModel.fromJson(json);

      expect(transaction.createdAt, DateTime.parse('2026-03-27T15:00:00.000Z'));
    });

    test('использует текущее время если дата невалидная', () {
      final json = {
        'id': 'tx_1',
        'title': 'Test',
        'amount': 100,
        'currency': 'USD',
        'category': 'food',
        'type': 'expense',
        'createdAt': 'invalid-date',
      };

      final transaction = TransactionModel.fromJson(json);

      expect(transaction.createdAt, isA<DateTime>());
    });

    test('извлекает sourceAssetId из вложенного sourceAsset', () {
      final json = {
        'id': 'tx_1',
        'title': 'Test',
        'amount': 100,
        'currency': 'USD',
        'category': 'food',
        'type': 'expense',
        'createdAt': '2026-03-28T10:00:00.000Z',
        'sourceAsset': {'id': 'asset_1', 'name': 'Main Card'},
      };

      final transaction = TransactionModel.fromJson(json);

      expect(transaction.sourceAssetId, 'asset_1');
      expect(transaction.sourceAssetName, 'Main Card');
    });

    test('извлекает receiptId и receiptConfidence из вложенного receipt', () {
      final json = {
        'id': 'tx_1',
        'title': 'Test',
        'amount': 100,
        'currency': 'USD',
        'category': 'food',
        'type': 'expense',
        'createdAt': '2026-03-28T10:00:00.000Z',
        'receipt': {'id': 'receipt_1', 'confidence': 0.95},
      };

      final transaction = TransactionModel.fromJson(json);

      expect(transaction.receiptId, 'receipt_1');
      expect(transaction.receiptConfidence, 0.95);
    });

    test('copyWith создает новую копию', () {
      final original = TransactionModel(
        id: 'tx_1',
        title: 'Original',
        amount: 100,
        currency: SupportedCurrency.usd,
        category: TransactionCategory.food,
        type: TransactionType.expense,
        createdAt: DateTime.now(),
      );

      final updated = original.copyWith(
        title: 'Updated',
        amount: 200,
        note: 'New note',
      );

      expect(updated.title, 'Updated');
      expect(updated.amount, 200);
      expect(updated.note, 'New note');
      expect(original.title, 'Original'); // оригинал не изменен
    });

    test('toJson возвращает корректный JSON', () {
      final now = DateTime(2026, 3, 28, 10, 0, 0);
      final transaction = TransactionModel(
        id: 'tx_123',
        title: 'Coffee',
        amount: 5.50,
        currency: SupportedCurrency.usd,
        category: TransactionCategory.food,
        type: TransactionType.expense,
        createdAt: now,
        note: 'Morning coffee',
        sourceAssetId: 'asset_1',
        sourceAssetName: 'Main Card',
      );

      final json = transaction.toJson();

      expect(json['id'], 'tx_123');
      expect(json['title'], 'Coffee');
      expect(json['amount'], 5.50);
      expect(json['currency'], 'USD');
      expect(json['category'], 'food');
      expect(json['type'], 'expense');
      expect(json['note'], 'Morning coffee');
      expect(json['sourceAssetId'], 'asset_1');
      expect(json['sourceAssetName'], 'Main Card');
    });

    test('demoList возвращает список демо транзакций', () {
      final transactions = TransactionModel.demoList();

      expect(transactions.length, 6);
      expect(transactions.every((t) => t.id.isNotEmpty), isTrue);
      expect(transactions.every((t) => t.title.isNotEmpty), isTrue);
    });

    test('demoList содержит разные типы транзакций', () {
      final transactions = TransactionModel.demoList();

      final types = transactions.map((t) => t.type).toSet();
      expect(types, contains(TransactionType.expense));
      expect(types, contains(TransactionType.income));
      expect(types, contains(TransactionType.transfer));
    });
  });
}
