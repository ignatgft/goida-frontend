import 'package:flutter_test/flutter_test.dart';
import 'package:demo2/data/models/balance.dart';

void main() {
  group('SupportedCurrency', () {
    test('code возвращает верхний регистр', () {
      expect(SupportedCurrency.usd.code, 'USD');
      expect(SupportedCurrency.eur.code, 'EUR');
      expect(SupportedCurrency.kzt.code, 'KZT');
    });

    test('code для TRY обрабатывается корректно', () {
      expect(SupportedCurrency.try_.code, 'TRY');
    });

    test('isCrypto возвращает true для криптовалют', () {
      expect(SupportedCurrency.btc.isCrypto, isTrue);
      expect(SupportedCurrency.eth.isCrypto, isTrue);
      expect(SupportedCurrency.usdt.isCrypto, isTrue);
    });

    test('isFiat возвращает true для фиатных валют', () {
      expect(SupportedCurrency.usd.isFiat, isTrue);
      expect(SupportedCurrency.eur.isFiat, isTrue);
      expect(SupportedCurrency.kzt.isFiat, isTrue);
    });

    test('fromCode находит валюту по коду', () {
      expect(SupportedCurrencyX.fromCode('USD'), SupportedCurrency.usd);
      expect(SupportedCurrencyX.fromCode('eur'), SupportedCurrency.eur);
      expect(SupportedCurrencyX.fromCode('KZT'), SupportedCurrency.kzt);
    });

    test('fromCode возвращает USD по умолчанию', () {
      expect(SupportedCurrencyX.fromCode('INVALID'), SupportedCurrency.usd);
    });
  });

  group('TrackedAsset', () {
    test('создается из JSON с обязательными полями', () {
      final json = {
        'id': 'asset_1',
        'name': 'Main Card',
        'type': 'bank_account',
        'currency': 'USD',
        'amount': 1000.50,
      };

      final asset = TrackedAsset.fromJson(json);

      expect(asset.id, 'asset_1');
      expect(asset.name, 'Main Card');
      expect(asset.type, AssetType.bankAccount);
      expect(asset.currency, SupportedCurrency.usd);
      expect(asset.amount, 1000.50);
    });

    test('использует balance как fallback для amount', () {
      final json = {
        'id': 'asset_2',
        'name': 'Savings',
        'type': 'savings',
        'currency': 'EUR',
        'balance': 500,
      };

      final asset = TrackedAsset.fromJson(json);

      expect(asset.amount, 500.0);
    });

    test('использует symbol как fallback для currency', () {
      final json = {
        'id': 'asset_3',
        'name': 'Cash',
        'type': 'cash',
        'symbol': 'KZT',
        'amount': 10000,
      };

      final asset = TrackedAsset.fromJson(json);

      expect(asset.currency, SupportedCurrency.kzt);
    });

    test('генерирует ID если он отсутствует', () {
      final json = {
        'name': 'Auto Asset',
        'type': 'cash',
        'currency': 'USD',
        'amount': 100,
      };

      final asset = TrackedAsset.fromJson(json);

      expect(asset.id, isNotEmpty);
      expect(asset.name, 'Auto Asset');
    });

    test('copyWith создает новую копию', () {
      const asset = TrackedAsset(
        id: 'asset_1',
        name: 'Original',
        type: AssetType.cash,
        currency: SupportedCurrency.usd,
        amount: 100,
      );

      final updated = asset.copyWith(
        name: 'Updated',
        amount: 200,
      );

      expect(updated.id, 'asset_1');
      expect(updated.name, 'Updated');
      expect(updated.amount, 200);
      expect(asset.name, 'Original'); // оригинал не изменен
    });

    test('toJson возвращает корректный JSON', () {
      const asset = TrackedAsset(
        id: 'asset_1',
        name: 'Test Asset',
        type: AssetType.crypto,
        currency: SupportedCurrency.btc,
        amount: 0.5,
      );

      final json = asset.toJson();

      expect(json['id'], 'asset_1');
      expect(json['name'], 'Test Asset');
      expect(json['type'], 'crypto');
      expect(json['currency'], 'BTC');
      expect(json['amount'], 0.5);
    });
  });

  group('SpendingOverview', () {
    test('создается из JSON', () {
      final json = {
        'spent': 500.0,
        'budget': 1000.0,
      };

      final spending = SpendingOverview.fromJson(json);

      expect(spending.spent, 500.0);
      expect(spending.budget, 1000.0);
    });

    test('использует 0 по умолчанию', () {
      final json = <String, dynamic>{};

      final spending = SpendingOverview.fromJson(json);

      expect(spending.spent, 0);
      expect(spending.budget, 0);
    });

    test('remaining вычисляется корректно', () {
      final spending = const SpendingOverview(spent: 300, budget: 1000);

      expect(spending.remaining, 700);
    });

    test('remaining не может быть отрицательным', () {
      final spending = const SpendingOverview(spent: 1500, budget: 1000);

      expect(spending.remaining, 0);
    });

    test('progress вычисляется корректно', () {
      final spending = const SpendingOverview(spent: 500, budget: 1000);

      expect(spending.progress, 0.5);
    });

    test('progress не превышает 1', () {
      final spending = const SpendingOverview(spent: 1500, budget: 1000);

      expect(spending.progress, 1.0);
    });

    test('progress равен 0 если budget 0', () {
      final spending = const SpendingOverview(spent: 500, budget: 0);

      expect(spending.progress, 0);
    });
  });

  group('BalanceOverview', () {
    test('создается из JSON', () {
      final json = {
        'baseCurrency': 'USD',
        'periodLabel': 'This month',
        'assets': [
          {'id': '1', 'name': 'Card', 'type': 'bank_account', 'currency': 'USD', 'amount': 1000},
        ],
        'spending': {'spent': 200, 'budget': 500},
      };

      final overview = BalanceOverview.fromJson(json);

      expect(overview.baseCurrency, SupportedCurrency.usd);
      expect(overview.periodLabel, 'This month');
      expect(overview.assets.length, 1);
      expect(overview.spending.spent, 200);
    });

    test('использует значения по умолчанию', () {
      final json = <String, dynamic>{};

      final overview = BalanceOverview.fromJson(json);

      expect(overview.baseCurrency, SupportedCurrency.usd);
      expect(overview.periodLabel, 'This month');
      expect(overview.assets, isEmpty);
    });

    test('netBalance вычисляется корректно', () {
      final overview = const BalanceOverview(
        baseCurrency: SupportedCurrency.usd,
        periodLabel: 'Test',
        assets: [
          TrackedAsset(id: '1', name: 'A', type: AssetType.cash, currency: SupportedCurrency.usd, amount: 1000),
          TrackedAsset(id: '2', name: 'B', type: AssetType.cash, currency: SupportedCurrency.usd, amount: 500),
        ],
        spending: SpendingOverview(spent: 300, budget: 1000),
      );

      expect(overview.netBalance, 1200); // 1000 + 500 - 300
    });

    test('demo создает демо данные', () {
      final overview = BalanceOverview.demo(TrackerPeriod.month);

      expect(overview.baseCurrency, SupportedCurrency.usd);
      expect(overview.periodLabel, 'This month');
      expect(overview.assets.isNotEmpty, isTrue);
      expect(overview.spending.spent, 1240.0);
      expect(overview.spending.budget, 2200.0);
    });

    test('empty создает пустой обзор', () {
      final overview = BalanceOverview.empty(TrackerPeriod.week);

      expect(overview.baseCurrency, SupportedCurrency.usd);
      expect(overview.periodLabel, 'This week');
      expect(overview.assets, isEmpty);
      expect(overview.spending.spent, 0);
      expect(overview.spending.budget, 0);
    });

    test('copyWith создает новую копию', () {
      final original = const BalanceOverview(
        baseCurrency: SupportedCurrency.usd,
        periodLabel: 'Original',
        assets: [],
        spending: SpendingOverview(spent: 100, budget: 200),
      );

      final updated = original.copyWith(
        periodLabel: 'Updated',
        spending: const SpendingOverview(spent: 300, budget: 400),
      );

      expect(updated.periodLabel, 'Updated');
      expect(updated.spending.spent, 300);
      expect(original.periodLabel, 'Original'); // оригинал не изменен
    });
  });

  group('FiatRates', () {
    test('создается из JSON', () {
      final json = {
        'baseCurrency': 'USD',
        'rates': {'EUR': 0.92, 'KZT': 503.7, 'USD': 1},
      };

      final rates = FiatRates.fromJson(json);

      expect(rates.baseCurrency, SupportedCurrency.usd);
      expect(rates.rateFor(SupportedCurrency.eur), 0.92);
      expect(rates.rateFor(SupportedCurrency.kzt), 503.7);
    });

    test('возвращает 1 для неизвестной валюты', () {
      final rates = FiatRates.fromJson({'baseCurrency': 'USD', 'rates': <String, dynamic>{}});

      expect(rates.rateFor(SupportedCurrency.eur), 1.0);
    });

    test('demo создает демо курсы', () {
      final rates = FiatRates.demo(SupportedCurrency.usd);

      expect(rates.baseCurrency, SupportedCurrency.usd);
      expect(rates.rateFor(SupportedCurrency.eur), isNot(equals(1.0)));
    });

    test('identity создает курс 1 для базовой валюты', () {
      final rates = FiatRates.identity(SupportedCurrency.eur);

      expect(rates.baseCurrency, SupportedCurrency.eur);
      expect(rates.rateFor(SupportedCurrency.eur), 1);
    });
  });

  group('CryptoMarketRates', () {
    test('создается из JSON', () {
      final json = {
        'quoteCurrency': 'USD',
        'prices': {'BTC': 67250, 'ETH': 3480},
      };

      final rates = CryptoMarketRates.fromJson(json);

      expect(rates.quoteCurrency, SupportedCurrency.usd);
      expect(rates.priceFor(SupportedCurrency.btc), 67250);
      expect(rates.priceFor(SupportedCurrency.eth), 3480);
    });

    test('возвращает 0 для неизвестной криптовалюты', () {
      final rates = CryptoMarketRates.fromJson({'quoteCurrency': 'USD', 'prices': <String, dynamic>{}});

      expect(rates.priceFor(SupportedCurrency.btc), 0);
    });

    test('demo создает демо цены', () {
      final rates = CryptoMarketRates.demo(SupportedCurrency.usd);

      expect(rates.quoteCurrency, SupportedCurrency.usd);
      expect(rates.priceFor(SupportedCurrency.btc), greaterThan(0));
    });

    test('empty создает пустые курсы', () {
      final rates = CryptoMarketRates.empty(SupportedCurrency.usd);

      expect(rates.quoteCurrency, SupportedCurrency.usd);
      expect(rates.prices, isEmpty);
    });
  });
}
