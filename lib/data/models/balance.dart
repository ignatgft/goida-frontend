enum SupportedCurrency {
  usd,
  eur,
  rub,
  kzt,
  gbp,
  jpy,
  cny,
  chf,
  cad,
  aud,
  nzd,
  sgd,
  hkd,
  sek,
  nok,
  dkk,
  pln,
  czk,
  huf,
  try_,
  aed,
  sar,
  qar,
  kwd,
  bhd,
  omr,
  inr,
  pkr,
  idr,
  myr,
  php,
  thb,
  vnd,
  krw,
  zar,
  brl,
  mxn,
  ars,
  clp,
  cop,
  pen,
  uah,
  ron,
  bgn,
  gel,
  amd,
  azn,
  uzs,
  mdl,
  rsd,
  byn,
  kgs,
  tjs,
  tmt,
  ngn,
  egp,
  ils,
  mad,
  kes,
  tnd,
  lkr,
  bdt,
  dop,
  crc,
  isk,
  mop,
  jod,
  lbp,
  bob,
  uyu,
  btc,
  eth,
  usdt,
  usdc,
  bnb,
  xrp,
  sol,
  ada,
  doge,
  trx,
  ton,
  avax,
  dot,
  link,
  bch,
  ltc,
  xlm,
  etc,
  atom,
  xmr,
  near,
  apt,
  sui,
  op,
  arb,
  inj,
  shib,
  fil,
  hbar,
  icp,
  vet,
  algo,
  aave,
  mkr,
  eos,
  sand,
  mana,
  uni,
  jup,
  kas,
  tao,
  cro,
  pepe,
  wif,
  bonk,
  stx,
  theta,
  gala,
  flow,
  xtz,
  zec,
  comp,
  snx,
  jto,
  tia,
  kcs,
  qnt,
  // Дополнительные популярные криптовалюты
  matic,
  ldo,
  imx,
  grt,
  rpl,
  flr,
  egld,
  kava,
  chz,
  bat,
  enj,
  zrx,
  inch,
  crv,
  bal,
  yfi,
  sushi,
  ren,
  lrc,
  knc,
  ant,
  storj,
  omg,
  qtum,
  icx,
  zilliqa,
  ont,
  vet2,
  theta2,
  tfuel,
  hnt,
  egld2,
  klay,
  btt,
  hot,
  win,
  dgb,
  sc,
  zen,
  rvn,
  dcr,
  lsks,
  waves,
  ardr,
  strax,
  nano,
  iotx,
  ckb,
  ank,
  celr,
  ct,
  fun,
  req,
  poly,
  audio,
  ash,
  mask,
  per,
  super,
  ilv,
  rad,
  bnt,
  alpha,
  dydx,
  gmx,
  magic,
  rdnt,
  gns,
  pendle,
  blur,
  pepe2,
  floki,
  babydoge,
  akita,
  kishu,
  safemoon,
  elon,
  dogelon,
  catgirl,
  shib2,
  leash,
  bone,
  tlos,
  wemix,
  rose,
  one,
  harmony,
  celo,
  ar,
  fil2,
  iotex,
  skale,
  audio2,
  ren2,
  lpt,
  nmr,
  bnt2,
  kava2,
  band,
  ocean,
  fet,
  agix,
  rlc,
  nu,
  keep,
  grt2,
  api3,
  badger,
  farm,
  cream,
  bifi,
  alpha2,
  hard,
  kava3,
  swp,
  usdx,
  xrp2,
  beth,
  steth,
  reth,
  cbeth,
  wbeth,
  ankr2,
  sfrxeth,
  frxeth,
  wsteth,
  lusc,
  sdai,
  dai,
  tusd,
  busd,
  gusd,
  pax,
  husd,
  usdp,
  frax,
  lusd,
  usdd,
  usdk,
  rsr,
  ohm,
  time,
  memo,
  klima,
  bct,
  nct,
  ubo,
  nbo,
  mco2,
  toucan,
  karbon,
  c3,
  flow2,
  mint,
  loom,
  man,
  red,
  yield,
  yld,
  idle,
  pickle,
  cover,
  hegic,
  opyn,
  ribbon,
  lyra,
  dopex,
  jones,
  umami,
  glp,
  gmlp,
  qimlp,
  plv,
  rdnt2,
  gns2,
  myc,
  cap,
  myc2,
  sd,
  frax3,
  fx,
  cvx,
  fxs,
  alcx,
  tribe,
  fei,
  rari,
  dola,
  inv,
  mta,
  bpt,
  aura,
  hid,
  aave2,
  stk,
  gho,
  eth2,
  weth,
  beeth,
  ankr3,
  sfrxeth2,
  frxeth2,
  wsteth2,
  lusc2,
  sdai2,
  dai2,
  tusd2,
  busd2,
  gusd2,
  pax2,
  husd2,
  usdp2,
  frax2,
  lusd2,
  usdd2,
  usdk2,
  rsr2,
  ohm2,
  time2,
  memo2,
  klima2,
  bct2,
  nct2,
  ubo2,
  nbo2,
  mco2_2,
  toucan2,
  karbon2,
  c32,
}

extension SupportedCurrencyX on SupportedCurrency {
  static const List<SupportedCurrency> fiatValues = [
    SupportedCurrency.usd,
    SupportedCurrency.eur,
    SupportedCurrency.rub,
    SupportedCurrency.kzt,
    SupportedCurrency.gbp,
    SupportedCurrency.jpy,
    SupportedCurrency.cny,
    SupportedCurrency.chf,
    SupportedCurrency.cad,
    SupportedCurrency.aud,
    SupportedCurrency.nzd,
    SupportedCurrency.sgd,
    SupportedCurrency.hkd,
    SupportedCurrency.sek,
    SupportedCurrency.nok,
    SupportedCurrency.dkk,
    SupportedCurrency.pln,
    SupportedCurrency.czk,
    SupportedCurrency.huf,
    SupportedCurrency.try_,
    SupportedCurrency.aed,
    SupportedCurrency.sar,
    SupportedCurrency.qar,
    SupportedCurrency.kwd,
    SupportedCurrency.bhd,
    SupportedCurrency.omr,
    SupportedCurrency.inr,
    SupportedCurrency.pkr,
    SupportedCurrency.idr,
    SupportedCurrency.myr,
    SupportedCurrency.php,
    SupportedCurrency.thb,
    SupportedCurrency.vnd,
    SupportedCurrency.krw,
    SupportedCurrency.zar,
    SupportedCurrency.brl,
    SupportedCurrency.mxn,
    SupportedCurrency.ars,
    SupportedCurrency.clp,
    SupportedCurrency.cop,
    SupportedCurrency.pen,
    SupportedCurrency.uah,
    SupportedCurrency.ron,
    SupportedCurrency.bgn,
    SupportedCurrency.gel,
    SupportedCurrency.amd,
    SupportedCurrency.azn,
    SupportedCurrency.uzs,
    SupportedCurrency.mdl,
    SupportedCurrency.rsd,
    SupportedCurrency.byn,
    SupportedCurrency.kgs,
    SupportedCurrency.tjs,
    SupportedCurrency.tmt,
    SupportedCurrency.ngn,
    SupportedCurrency.egp,
    SupportedCurrency.ils,
    SupportedCurrency.mad,
    SupportedCurrency.kes,
    SupportedCurrency.tnd,
    SupportedCurrency.lkr,
    SupportedCurrency.bdt,
    SupportedCurrency.dop,
    SupportedCurrency.crc,
    SupportedCurrency.isk,
    SupportedCurrency.mop,
    SupportedCurrency.jod,
    SupportedCurrency.lbp,
    SupportedCurrency.bob,
    SupportedCurrency.uyu,
  ];

  static const List<SupportedCurrency> cryptoValues = [
    SupportedCurrency.btc,
    SupportedCurrency.eth,
    SupportedCurrency.usdt,
    SupportedCurrency.usdc,
    SupportedCurrency.bnb,
    SupportedCurrency.xrp,
    SupportedCurrency.sol,
    SupportedCurrency.ada,
    SupportedCurrency.doge,
    SupportedCurrency.trx,
    SupportedCurrency.ton,
    SupportedCurrency.avax,
    SupportedCurrency.dot,
    SupportedCurrency.link,
    SupportedCurrency.bch,
    SupportedCurrency.ltc,
    SupportedCurrency.xlm,
    SupportedCurrency.etc,
    SupportedCurrency.atom,
    SupportedCurrency.xmr,
    SupportedCurrency.near,
    SupportedCurrency.apt,
    SupportedCurrency.sui,
    SupportedCurrency.op,
    SupportedCurrency.arb,
    SupportedCurrency.inj,
    SupportedCurrency.shib,
    SupportedCurrency.fil,
    SupportedCurrency.hbar,
    SupportedCurrency.icp,
    SupportedCurrency.vet,
    SupportedCurrency.algo,
    SupportedCurrency.aave,
    SupportedCurrency.mkr,
    SupportedCurrency.eos,
    SupportedCurrency.sand,
    SupportedCurrency.mana,
    SupportedCurrency.uni,
    SupportedCurrency.jup,
    SupportedCurrency.kas,
    SupportedCurrency.tao,
    SupportedCurrency.cro,
    SupportedCurrency.pepe,
    SupportedCurrency.wif,
    SupportedCurrency.bonk,
    SupportedCurrency.stx,
    SupportedCurrency.theta,
    SupportedCurrency.gala,
    SupportedCurrency.flow,
    SupportedCurrency.xtz,
    SupportedCurrency.zec,
    SupportedCurrency.comp,
    SupportedCurrency.snx,
    SupportedCurrency.jto,
    SupportedCurrency.tia,
    SupportedCurrency.kcs,
    SupportedCurrency.qnt,
    // Дополнительные криптовалюты
    SupportedCurrency.matic,
    SupportedCurrency.ldo,
    SupportedCurrency.imx,
    SupportedCurrency.grt,
    SupportedCurrency.rpl,
    SupportedCurrency.flr,
    SupportedCurrency.egld,
    SupportedCurrency.kava,
    SupportedCurrency.chz,
    SupportedCurrency.bat,
    SupportedCurrency.enj,
    SupportedCurrency.zrx,
    SupportedCurrency.inch,
    SupportedCurrency.crv,
    SupportedCurrency.bal,
    SupportedCurrency.yfi,
    SupportedCurrency.sushi,
    SupportedCurrency.ren,
    SupportedCurrency.lrc,
    SupportedCurrency.knc,
    SupportedCurrency.ant,
    SupportedCurrency.storj,
    SupportedCurrency.omg,
    SupportedCurrency.qtum,
    SupportedCurrency.icx,
    SupportedCurrency.zilliqa,
    SupportedCurrency.ont,
    SupportedCurrency.vet2,
    SupportedCurrency.theta2,
    SupportedCurrency.tfuel,
    SupportedCurrency.hnt,
    SupportedCurrency.egld2,
    SupportedCurrency.klay,
    SupportedCurrency.btt,
    SupportedCurrency.hot,
    SupportedCurrency.win,
    SupportedCurrency.dgb,
    SupportedCurrency.sc,
    SupportedCurrency.zen,
    SupportedCurrency.rvn,
    SupportedCurrency.dcr,
    SupportedCurrency.lsks,
    SupportedCurrency.waves,
    SupportedCurrency.ardr,
    SupportedCurrency.strax,
    SupportedCurrency.nano,
    SupportedCurrency.iotx,
    SupportedCurrency.ckb,
    SupportedCurrency.ank,
    SupportedCurrency.celr,
    SupportedCurrency.ct,
    SupportedCurrency.fun,
    SupportedCurrency.req,
    SupportedCurrency.poly,
    SupportedCurrency.audio,
    SupportedCurrency.ash,
    SupportedCurrency.mask,
    SupportedCurrency.per,
    SupportedCurrency.super,
    SupportedCurrency.ilv,
    SupportedCurrency.rad,
    SupportedCurrency.bnt,
    SupportedCurrency.alpha,
    SupportedCurrency.dydx,
    SupportedCurrency.gmx,
    SupportedCurrency.magic,
    SupportedCurrency.rdnt,
    SupportedCurrency.gns,
    SupportedCurrency.pendle,
    SupportedCurrency.blur,
    SupportedCurrency.pepe2,
    SupportedCurrency.floki,
    SupportedCurrency.babydoge,
    SupportedCurrency.akita,
    SupportedCurrency.kishu,
    SupportedCurrency.safemoon,
    SupportedCurrency.elon,
    SupportedCurrency.dogelon,
    SupportedCurrency.catgirl,
    SupportedCurrency.shib2,
    SupportedCurrency.leash,
    SupportedCurrency.bone,
    SupportedCurrency.tlos,
    SupportedCurrency.wemix,
    SupportedCurrency.rose,
    SupportedCurrency.one,
    SupportedCurrency.harmony,
    SupportedCurrency.celo,
    SupportedCurrency.ar,
    SupportedCurrency.fil2,
    SupportedCurrency.iotex,
    SupportedCurrency.skale,
    SupportedCurrency.audio2,
    SupportedCurrency.ren2,
    SupportedCurrency.lpt,
    SupportedCurrency.nmr,
    SupportedCurrency.bnt2,
    SupportedCurrency.kava2,
    SupportedCurrency.band,
    SupportedCurrency.ocean,
    SupportedCurrency.fet,
    SupportedCurrency.agix,
    SupportedCurrency.rlc,
    SupportedCurrency.nu,
    SupportedCurrency.keep,
    SupportedCurrency.grt2,
    SupportedCurrency.api3,
    SupportedCurrency.badger,
    SupportedCurrency.farm,
    SupportedCurrency.cream,
    SupportedCurrency.bifi,
    SupportedCurrency.alpha2,
    SupportedCurrency.hard,
    SupportedCurrency.kava3,
    SupportedCurrency.swp,
    SupportedCurrency.usdx,
    SupportedCurrency.xrp2,
    SupportedCurrency.beth,
    SupportedCurrency.steth,
    SupportedCurrency.reth,
    SupportedCurrency.cbeth,
    SupportedCurrency.wbeth,
    SupportedCurrency.ankr2,
    SupportedCurrency.sfrxeth,
    SupportedCurrency.frxeth,
    SupportedCurrency.wsteth,
    SupportedCurrency.lusc,
    SupportedCurrency.sdai,
    SupportedCurrency.dai,
    SupportedCurrency.tusd,
    SupportedCurrency.busd,
    SupportedCurrency.gusd,
    SupportedCurrency.pax,
    SupportedCurrency.husd,
    SupportedCurrency.usdp,
    SupportedCurrency.frax,
    SupportedCurrency.lusd,
    SupportedCurrency.usdd,
    SupportedCurrency.usdk,
    SupportedCurrency.rsr,
    SupportedCurrency.ohm,
    SupportedCurrency.time,
    SupportedCurrency.memo,
    SupportedCurrency.klima,
    SupportedCurrency.bct,
    SupportedCurrency.nct,
    SupportedCurrency.ubo,
    SupportedCurrency.nbo,
    SupportedCurrency.mco2,
    SupportedCurrency.toucan,
    SupportedCurrency.karbon,
    SupportedCurrency.c3,
    SupportedCurrency.flow2,
    SupportedCurrency.mint,
    SupportedCurrency.loom,
    SupportedCurrency.man,
    SupportedCurrency.red,
    SupportedCurrency.yield,
    SupportedCurrency.yld,
    SupportedCurrency.idle,
    SupportedCurrency.pickle,
    SupportedCurrency.cover,
    SupportedCurrency.hegic,
    SupportedCurrency.opyn,
    SupportedCurrency.ribbon,
    SupportedCurrency.lyra,
    SupportedCurrency.dopex,
    SupportedCurrency.jones,
    SupportedCurrency.umami,
    SupportedCurrency.glp,
    SupportedCurrency.gmlp,
    SupportedCurrency.qimlp,
    SupportedCurrency.plv,
    SupportedCurrency.rdnt2,
    SupportedCurrency.gns2,
    SupportedCurrency.myc,
    SupportedCurrency.cap,
    SupportedCurrency.myc2,
    SupportedCurrency.sd,
    SupportedCurrency.frax3,
    SupportedCurrency.fx,
    SupportedCurrency.cvx,
    SupportedCurrency.fxs,
    SupportedCurrency.alcx,
    SupportedCurrency.tribe,
    SupportedCurrency.fei,
    SupportedCurrency.rari,
    SupportedCurrency.dola,
    SupportedCurrency.inv,
    SupportedCurrency.mta,
    SupportedCurrency.bpt,
    SupportedCurrency.aura,
    SupportedCurrency.hid,
    SupportedCurrency.aave2,
    SupportedCurrency.stk,
    SupportedCurrency.gho,
    SupportedCurrency.eth2,
    SupportedCurrency.weth,
    SupportedCurrency.beeth,
    SupportedCurrency.ankr3,
    SupportedCurrency.sfrxeth2,
    SupportedCurrency.frxeth2,
    SupportedCurrency.wsteth2,
    SupportedCurrency.lusc2,
    SupportedCurrency.sdai2,
    SupportedCurrency.dai2,
    SupportedCurrency.tusd2,
    SupportedCurrency.busd2,
    SupportedCurrency.gusd2,
    SupportedCurrency.pax2,
    SupportedCurrency.husd2,
    SupportedCurrency.usdp2,
    SupportedCurrency.frax2,
    SupportedCurrency.lusd2,
    SupportedCurrency.usdd2,
    SupportedCurrency.usdk2,
    SupportedCurrency.rsr2,
    SupportedCurrency.ohm2,
    SupportedCurrency.time2,
    SupportedCurrency.memo2,
    SupportedCurrency.klima2,
    SupportedCurrency.bct2,
    SupportedCurrency.nct2,
    SupportedCurrency.ubo2,
    SupportedCurrency.nbo2,
    SupportedCurrency.mco2_2,
    SupportedCurrency.toucan2,
    SupportedCurrency.karbon2,
    SupportedCurrency.c32,
  ];

  String get code => switch (this) {
    SupportedCurrency.try_ => 'TRY',
    _ => name.toUpperCase(),
  };

  String get symbol => switch (this) {
    SupportedCurrency.usd => r'$',
    SupportedCurrency.eur => 'EUR',
    SupportedCurrency.rub => 'RUB',
    SupportedCurrency.kzt => 'KZT',
    SupportedCurrency.gbp => 'GBP',
    SupportedCurrency.jpy => 'JPY',
    SupportedCurrency.cny => 'CNY',
    SupportedCurrency.inr => 'INR',
    SupportedCurrency.krw => 'KRW',
    SupportedCurrency.thb => 'THB',
    SupportedCurrency.php => 'PHP',
    SupportedCurrency.vnd => 'VND',
    SupportedCurrency.uah => 'UAH',
    SupportedCurrency.try_ => 'TRY',
    SupportedCurrency.ils => 'ILS',
    SupportedCurrency.btc => 'BTC',
    SupportedCurrency.eth => 'ETH',
    SupportedCurrency.usdt => 'USDT',
    SupportedCurrency.usdc => 'USDC',
    _ => code,
  };

  bool get isCrypto => cryptoValues.contains(this);
  bool get isFiat => !isCrypto;

  String get displayName => _currencyDisplayNames[this] ?? code;

  String localizedCategoryLabel(String languageCode) {
    final isRussian = languageCode.toLowerCase().startsWith('ru');
    if (isCrypto) {
      return isRussian ? 'Криптоактив' : 'Crypto asset';
    }
    return isRussian ? 'Фиатная валюта' : 'Fiat currency';
  }

  String localizedDescription(String languageCode) {
    final category = localizedCategoryLabel(languageCode);
    return symbol == code ? category : '$category · $symbol';
  }

  String get searchLabel => '$code $symbol $displayName'.toLowerCase();

  static SupportedCurrency fromCode(String code) {
    return SupportedCurrency.values.firstWhere(
      (currency) => currency.code == code.toUpperCase(),
      orElse: () => SupportedCurrency.usd,
    );
  }
}

enum AssetType { cash, bankAccount, savings, investments, crypto }

extension AssetTypeX on AssetType {
  String get apiValue => switch (this) {
    AssetType.cash => 'cash',
    AssetType.bankAccount => 'bank_account',
    AssetType.savings => 'savings',
    AssetType.investments => 'investments',
    AssetType.crypto => 'crypto',
  };

  static AssetType fromValue(String value) {
    final normalized = value.trim().toLowerCase();
    switch (normalized) {
      case 'cash':
      case 'fiat':
      case 'other':
        return AssetType.cash;
      case 'bank_account':
      case 'bank account':
        return AssetType.bankAccount;
      case 'savings':
        return AssetType.savings;
      case 'investments':
        return AssetType.investments;
      case 'crypto':
        return AssetType.crypto;
      default:
        return AssetType.cash;
    }
  }
}

enum TrackerPeriod { week, month, year }

extension TrackerPeriodX on TrackerPeriod {
  String get apiValue => switch (this) {
    TrackerPeriod.week => 'week',
    TrackerPeriod.month => 'month',
    TrackerPeriod.year => 'year',
  };
}

class TrackedAsset {
  final String id;
  final String name;
  final AssetType type;
  final SupportedCurrency currency;
  final double amount;          // Баланс в исходной валюте
  final double currentValue;    // Стоимость в базовой валюте (с конвертацией)

  const TrackedAsset({
    required this.id,
    required this.name,
    required this.type,
    required this.currency,
    required this.amount,
    this.currentValue = 0.0,
  });

  factory TrackedAsset.fromJson(Map<String, dynamic> json) {
    // Extract values with fallbacks in a single pass
    final idValue = json['id'] as String?;
    final nameValue = json['name'] as String?;
    final typeValue = json['type'] as String?;
    final currencyValue = json['currency'] as String? ?? json['symbol'] as String?;
    final amountValue = json['amount'] as num? ?? json['balance'] as num?;
    // currentValue - это конвертированная стоимость в базовой валюте
    final currentValueNum = json['currentValue'] as num? ?? json['current_value'] as num?;

    return TrackedAsset(
      id: idValue ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameValue ?? 'Asset',
      type: AssetTypeX.fromValue(typeValue ?? 'cash'),
      currency: SupportedCurrencyX.fromCode(currencyValue ?? 'USD'),
      amount: (amountValue?.toDouble() ?? 0.0),
      currentValue: (currentValueNum?.toDouble() ?? 0.0),
    );
  }

  TrackedAsset copyWith({
    String? id,
    String? name,
    AssetType? type,
    SupportedCurrency? currency,
    double? amount,
    double? currentValue,
  }) {
    return TrackedAsset(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      currency: currency ?? this.currency,
      amount: amount ?? this.amount,
      currentValue: currentValue ?? this.currentValue,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.apiValue,
    'currency': currency.code,
    'amount': amount,
    'currentValue': currentValue,
  };
}

class SpendingOverview {
  final double spent;
  final double budget;

  const SpendingOverview({required this.spent, required this.budget});

  factory SpendingOverview.fromJson(Map<String, dynamic> json) {
    return SpendingOverview(
      spent: (json['spent'] as num? ?? 0).toDouble(),
      budget: (json['budget'] as num? ?? 0).toDouble(),
    );
  }

  double get remaining => (budget - spent).clamp(0, double.infinity);

  double get progress {
    if (budget <= 0) {
      // Если бюджета нет, показываем 0 но spent всё равно есть
      return 0;
    }
    return (spent / budget).clamp(0, 1);
  }
  
  // Процент трат для отображения (всегда показывает spent)
  String get progressText {
    if (budget <= 0) {
      return '${spent.toStringAsFixed(0)} spent';
    }
    final percent = (spent / budget * 100).clamp(0, 999).toStringAsFixed(0);
    return '$percent%';
  }

  SpendingOverview copyWith({double? spent, double? budget}) {
    return SpendingOverview(
      spent: spent ?? this.spent,
      budget: budget ?? this.budget,
    );
  }
}

class BalanceOverview {
  final SupportedCurrency baseCurrency;
  final String periodLabel;
  final List<TrackedAsset> assets;
  final SpendingOverview spending;

  const BalanceOverview({
    required this.baseCurrency,
    required this.periodLabel,
    required this.assets,
    required this.spending,
  });

  factory BalanceOverview.fromJson(Map<String, dynamic> json) {
    // Extract values in a single pass
    final baseCurrencyValue = json['baseCurrency'] as String?;
    final periodLabelValue = json['periodLabel'] as String?;
    final assetsJson = json['assets'] as List<dynamic>? ?? const [];
    final spendingJson = json['spending'] as Map<String, dynamic>? ?? const {};
    
    // Process assets efficiently
    final typedAssets = assetsJson.whereType<Map<String, dynamic>>();
    final processedAssets = typedAssets.map(TrackedAsset.fromJson).toList();
    
    return BalanceOverview(
      baseCurrency: SupportedCurrencyX.fromCode(baseCurrencyValue ?? 'USD'),
      periodLabel: periodLabelValue ?? 'This month',
      assets: processedAssets,
      spending: SpendingOverview.fromJson(spendingJson),
    );
  }

  // Расчет чистого баланса: сумма всех активов (с конвертацией) МИНУС расходы
  double get netBalance {
    // Используем currentValue - это сумма уже конвертированная в базовую валюту
    final totalAssets = assets.fold<double>(0, (sum, asset) => 
      sum + (asset.currentValue > 0 ? asset.currentValue : asset.amount)
    );
    return totalAssets - spending.spent;
  }

  factory BalanceOverview.demo(TrackerPeriod period) {
    final periodLabel = switch (period) {
      TrackerPeriod.week => 'This week',
      TrackerPeriod.month => 'This month',
      TrackerPeriod.year => 'This year',
    };

    return const BalanceOverview(
      baseCurrency: SupportedCurrency.usd,
      periodLabel: 'This month',
      assets: [
        TrackedAsset(
          id: '1',
          name: 'Main Card',
          type: AssetType.bankAccount,
          currency: SupportedCurrency.usd,
          amount: 2450.75,
        ),
        TrackedAsset(
          id: '2',
          name: 'EUR Cash',
          type: AssetType.cash,
          currency: SupportedCurrency.eur,
          amount: 820.20,
        ),
        TrackedAsset(
          id: '3',
          name: 'Savings',
          type: AssetType.savings,
          currency: SupportedCurrency.kzt,
          amount: 528400.00,
        ),
        TrackedAsset(
          id: '4',
          name: 'BTC Bag',
          type: AssetType.crypto,
          currency: SupportedCurrency.btc,
          amount: 0.125,
        ),
        TrackedAsset(
          id: '5',
          name: 'ETH Stash',
          type: AssetType.crypto,
          currency: SupportedCurrency.eth,
          amount: 2.7,
        ),
      ],
      spending: SpendingOverview(spent: 1240.0, budget: 2200.0),
    ).copyWith(periodLabel: periodLabel);
  }

  factory BalanceOverview.empty(
    TrackerPeriod period, {
    SupportedCurrency baseCurrency = SupportedCurrency.usd,
  }) {
    final periodLabel = switch (period) {
      TrackerPeriod.week => 'This week',
      TrackerPeriod.month => 'This month',
      TrackerPeriod.year => 'This year',
    };

    return BalanceOverview(
      baseCurrency: baseCurrency,
      periodLabel: periodLabel,
      assets: const [],
      spending: const SpendingOverview(spent: 0, budget: 0),
    );
  }

  BalanceOverview copyWith({
    SupportedCurrency? baseCurrency,
    String? periodLabel,
    List<TrackedAsset>? assets,
    SpendingOverview? spending,
  }) {
    return BalanceOverview(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      periodLabel: periodLabel ?? this.periodLabel,
      assets: assets ?? this.assets,
      spending: spending ?? this.spending,
    );
  }
}

class FiatRates {
  final SupportedCurrency baseCurrency;
  final Map<SupportedCurrency, double> rates;

  const FiatRates({required this.baseCurrency, required this.rates});

  factory FiatRates.fromJson(Map<String, dynamic> json) {
    final baseCurrencyValue = json['baseCurrency'] as String?;
    final rawRates = json['rates'] as Map<String, dynamic>? ?? const {};
    
    // Pre-process rates map for better performance
    final processedRates = <SupportedCurrency, double>{};
    for (final entry in rawRates.entries) {
      final currency = SupportedCurrencyX.fromCode(entry.key);
      final rate = (entry.value as num?)?.toDouble() ?? 1.0;
      processedRates[currency] = rate;
    }
    
    return FiatRates(
      baseCurrency: SupportedCurrencyX.fromCode(baseCurrencyValue ?? 'USD'),
      rates: processedRates,
    );
  }

  factory FiatRates.demo(SupportedCurrency baseCurrency) {
    return FiatRates(
      baseCurrency: baseCurrency,
      rates: {
        for (final currency in SupportedCurrencyX.fiatValues)
          currency: _demoFiatRate(baseCurrency, currency),
      },
    );
  }

  factory FiatRates.identity(SupportedCurrency baseCurrency) {
    return FiatRates(baseCurrency: baseCurrency, rates: {baseCurrency: 1});
  }

  double rateFor(SupportedCurrency currency) => rates[currency] ?? 1.0;
}

class CryptoMarketRates {
  final SupportedCurrency quoteCurrency;
  final Map<SupportedCurrency, double> prices;

  const CryptoMarketRates({required this.quoteCurrency, required this.prices});

  factory CryptoMarketRates.fromJson(Map<String, dynamic> json) {
    final quoteCurrencyValue = json['quoteCurrency'] as String?;
    final rawPrices = json['prices'] as Map<String, dynamic>? ?? const {};
    
    // Pre-process prices map for better performance
    final processedPrices = <SupportedCurrency, double>{};
    for (final entry in rawPrices.entries) {
      final currency = SupportedCurrencyX.fromCode(entry.key);
      final price = (entry.value as num?)?.toDouble() ?? 0.0;
      processedPrices[currency] = price;
    }
    
    return CryptoMarketRates(
      quoteCurrency: SupportedCurrencyX.fromCode(quoteCurrencyValue ?? 'USD'),
      prices: processedPrices,
    );
  }

  factory CryptoMarketRates.demo(SupportedCurrency quoteCurrency) {
    return CryptoMarketRates(
      quoteCurrency: quoteCurrency,
      prices: {
        for (final entry in _demoCryptoUsdPrices.entries)
          entry.key: _demoCryptoPrice(quoteCurrency, entry.value),
      },
    );
  }

  factory CryptoMarketRates.empty(SupportedCurrency quoteCurrency) {
    return CryptoMarketRates(quoteCurrency: quoteCurrency, prices: const {});
  }

  double priceFor(SupportedCurrency currency) => prices[currency] ?? 0;
}

double _demoFiatRate(SupportedCurrency base, SupportedCurrency quote) {
  if (base == quote) {
    return 1;
  }

  final baseRate = _demoUsdFiatRates[base] ?? 1.0;
  final quoteRate = _demoUsdFiatRates[quote] ?? 1.0;
  return quoteRate / baseRate;
}

double _demoCryptoPrice(SupportedCurrency quoteCurrency, double usdPrice) {
  if (quoteCurrency == SupportedCurrency.usd) {
    return usdPrice;
  }

  final rate = _demoFiatRate(SupportedCurrency.usd, quoteCurrency);
  return usdPrice * rate;
}

const Map<SupportedCurrency, String> _currencyDisplayNames = {
  SupportedCurrency.usd: 'US Dollar',
  SupportedCurrency.eur: 'Euro',
  SupportedCurrency.rub: 'Russian Ruble',
  SupportedCurrency.kzt: 'Kazakhstani Tenge',
  SupportedCurrency.gbp: 'British Pound',
  SupportedCurrency.jpy: 'Japanese Yen',
  SupportedCurrency.cny: 'Chinese Yuan',
  SupportedCurrency.chf: 'Swiss Franc',
  SupportedCurrency.cad: 'Canadian Dollar',
  SupportedCurrency.aud: 'Australian Dollar',
  SupportedCurrency.nzd: 'New Zealand Dollar',
  SupportedCurrency.sgd: 'Singapore Dollar',
  SupportedCurrency.hkd: 'Hong Kong Dollar',
  SupportedCurrency.sek: 'Swedish Krona',
  SupportedCurrency.nok: 'Norwegian Krone',
  SupportedCurrency.dkk: 'Danish Krone',
  SupportedCurrency.pln: 'Polish Zloty',
  SupportedCurrency.czk: 'Czech Koruna',
  SupportedCurrency.huf: 'Hungarian Forint',
  SupportedCurrency.try_: 'Turkish Lira',
  SupportedCurrency.aed: 'UAE Dirham',
  SupportedCurrency.sar: 'Saudi Riyal',
  SupportedCurrency.qar: 'Qatari Riyal',
  SupportedCurrency.kwd: 'Kuwaiti Dinar',
  SupportedCurrency.bhd: 'Bahraini Dinar',
  SupportedCurrency.omr: 'Omani Rial',
  SupportedCurrency.inr: 'Indian Rupee',
  SupportedCurrency.pkr: 'Pakistani Rupee',
  SupportedCurrency.idr: 'Indonesian Rupiah',
  SupportedCurrency.myr: 'Malaysian Ringgit',
  SupportedCurrency.php: 'Philippine Peso',
  SupportedCurrency.thb: 'Thai Baht',
  SupportedCurrency.vnd: 'Vietnamese Dong',
  SupportedCurrency.krw: 'South Korean Won',
  SupportedCurrency.zar: 'South African Rand',
  SupportedCurrency.brl: 'Brazilian Real',
  SupportedCurrency.mxn: 'Mexican Peso',
  SupportedCurrency.ars: 'Argentine Peso',
  SupportedCurrency.clp: 'Chilean Peso',
  SupportedCurrency.cop: 'Colombian Peso',
  SupportedCurrency.pen: 'Peruvian Sol',
  SupportedCurrency.uah: 'Ukrainian Hryvnia',
  SupportedCurrency.ron: 'Romanian Leu',
  SupportedCurrency.bgn: 'Bulgarian Lev',
  SupportedCurrency.gel: 'Georgian Lari',
  SupportedCurrency.amd: 'Armenian Dram',
  SupportedCurrency.azn: 'Azerbaijani Manat',
  SupportedCurrency.uzs: 'Uzbekistani Som',
  SupportedCurrency.mdl: 'Moldovan Leu',
  SupportedCurrency.rsd: 'Serbian Dinar',
  SupportedCurrency.byn: 'Belarusian Ruble',
  SupportedCurrency.kgs: 'Kyrgyzstani Som',
  SupportedCurrency.tjs: 'Tajikistani Somoni',
  SupportedCurrency.tmt: 'Turkmenistani Manat',
  SupportedCurrency.ngn: 'Nigerian Naira',
  SupportedCurrency.egp: 'Egyptian Pound',
  SupportedCurrency.ils: 'Israeli New Shekel',
  SupportedCurrency.mad: 'Moroccan Dirham',
  SupportedCurrency.kes: 'Kenyan Shilling',
  SupportedCurrency.tnd: 'Tunisian Dinar',
  SupportedCurrency.lkr: 'Sri Lankan Rupee',
  SupportedCurrency.bdt: 'Bangladeshi Taka',
  SupportedCurrency.dop: 'Dominican Peso',
  SupportedCurrency.crc: 'Costa Rican Colon',
  SupportedCurrency.isk: 'Icelandic Krona',
  SupportedCurrency.mop: 'Macanese Pataca',
  SupportedCurrency.jod: 'Jordanian Dinar',
  SupportedCurrency.lbp: 'Lebanese Pound',
  SupportedCurrency.bob: 'Bolivian Boliviano',
  SupportedCurrency.uyu: 'Uruguayan Peso',
  SupportedCurrency.btc: 'Bitcoin',
  SupportedCurrency.eth: 'Ethereum',
  SupportedCurrency.usdt: 'Tether',
  SupportedCurrency.usdc: 'USD Coin',
  SupportedCurrency.bnb: 'BNB',
  SupportedCurrency.xrp: 'XRP',
  SupportedCurrency.sol: 'Solana',
  SupportedCurrency.ada: 'Cardano',
  SupportedCurrency.doge: 'Dogecoin',
  SupportedCurrency.trx: 'TRON',
  SupportedCurrency.ton: 'Toncoin',
  SupportedCurrency.avax: 'Avalanche',
  SupportedCurrency.dot: 'Polkadot',
  SupportedCurrency.link: 'Chainlink',
  SupportedCurrency.bch: 'Bitcoin Cash',
  SupportedCurrency.ltc: 'Litecoin',
  SupportedCurrency.xlm: 'Stellar',
  SupportedCurrency.etc: 'Ethereum Classic',
  SupportedCurrency.atom: 'Cosmos',
  SupportedCurrency.xmr: 'Monero',
  SupportedCurrency.near: 'NEAR Protocol',
  SupportedCurrency.apt: 'Aptos',
  SupportedCurrency.sui: 'Sui',
  SupportedCurrency.op: 'Optimism',
  SupportedCurrency.arb: 'Arbitrum',
  SupportedCurrency.inj: 'Injective',
  SupportedCurrency.shib: 'Shiba Inu',
  SupportedCurrency.fil: 'Filecoin',
  SupportedCurrency.hbar: 'Hedera',
  SupportedCurrency.icp: 'Internet Computer',
  SupportedCurrency.vet: 'VeChain',
  SupportedCurrency.algo: 'Algorand',
  SupportedCurrency.aave: 'Aave',
  SupportedCurrency.mkr: 'Maker',
  SupportedCurrency.eos: 'EOS',
  SupportedCurrency.sand: 'The Sandbox',
  SupportedCurrency.mana: 'Decentraland',
  SupportedCurrency.uni: 'Uniswap',
  SupportedCurrency.jup: 'Jupiter',
  SupportedCurrency.kas: 'Kaspa',
  SupportedCurrency.tao: 'Bittensor',
  SupportedCurrency.cro: 'Cronos',
  SupportedCurrency.pepe: 'Pepe',
  SupportedCurrency.wif: 'dogwifhat',
  SupportedCurrency.bonk: 'Bonk',
  SupportedCurrency.stx: 'Stacks',
  SupportedCurrency.theta: 'Theta Network',
  SupportedCurrency.gala: 'Gala',
  SupportedCurrency.flow: 'Flow',
  SupportedCurrency.xtz: 'Tezos',
  SupportedCurrency.zec: 'Zcash',
  SupportedCurrency.comp: 'Compound',
  SupportedCurrency.snx: 'Synthetix',
  SupportedCurrency.jto: 'Jito',
  SupportedCurrency.tia: 'Celestia',
  SupportedCurrency.kcs: 'KuCoin Token',
  SupportedCurrency.qnt: 'Quant',
};

const Map<SupportedCurrency, double> _demoUsdFiatRates = {
  SupportedCurrency.usd: 1.0,
  SupportedCurrency.eur: 0.92,
  SupportedCurrency.rub: 92.4,
  SupportedCurrency.kzt: 503.7,
  SupportedCurrency.gbp: 0.79,
  SupportedCurrency.jpy: 151.2,
  SupportedCurrency.cny: 7.18,
  SupportedCurrency.chf: 0.89,
  SupportedCurrency.cad: 1.35,
  SupportedCurrency.aud: 1.52,
  SupportedCurrency.nzd: 1.64,
  SupportedCurrency.sgd: 1.34,
  SupportedCurrency.hkd: 7.82,
  SupportedCurrency.sek: 10.42,
  SupportedCurrency.nok: 10.63,
  SupportedCurrency.dkk: 6.86,
  SupportedCurrency.pln: 3.95,
  SupportedCurrency.czk: 23.15,
  SupportedCurrency.huf: 361.0,
  SupportedCurrency.try_: 32.1,
  SupportedCurrency.aed: 3.67,
  SupportedCurrency.sar: 3.75,
  SupportedCurrency.qar: 3.64,
  SupportedCurrency.kwd: 0.31,
  SupportedCurrency.bhd: 0.38,
  SupportedCurrency.omr: 0.38,
  SupportedCurrency.inr: 83.2,
  SupportedCurrency.pkr: 278.0,
  SupportedCurrency.idr: 15650.0,
  SupportedCurrency.myr: 4.72,
  SupportedCurrency.php: 56.3,
  SupportedCurrency.thb: 35.9,
  SupportedCurrency.vnd: 24600.0,
  SupportedCurrency.krw: 1338.0,
  SupportedCurrency.zar: 18.7,
  SupportedCurrency.brl: 4.98,
  SupportedCurrency.mxn: 16.8,
  SupportedCurrency.ars: 1070.0,
  SupportedCurrency.clp: 970.0,
  SupportedCurrency.cop: 3920.0,
  SupportedCurrency.pen: 3.72,
  SupportedCurrency.uah: 39.2,
  SupportedCurrency.ron: 4.58,
  SupportedCurrency.bgn: 1.8,
  SupportedCurrency.gel: 2.71,
  SupportedCurrency.amd: 391.0,
  SupportedCurrency.azn: 1.7,
  SupportedCurrency.uzs: 12650.0,
  SupportedCurrency.mdl: 17.7,
  SupportedCurrency.rsd: 107.8,
  SupportedCurrency.byn: 3.27,
  SupportedCurrency.kgs: 89.2,
  SupportedCurrency.tjs: 10.9,
  SupportedCurrency.tmt: 3.5,
  SupportedCurrency.ngn: 1530.0,
  SupportedCurrency.egp: 49.2,
  SupportedCurrency.ils: 3.68,
  SupportedCurrency.mad: 9.98,
  SupportedCurrency.kes: 129.8,
  SupportedCurrency.tnd: 3.11,
  SupportedCurrency.lkr: 301.0,
  SupportedCurrency.bdt: 118.5,
  SupportedCurrency.dop: 59.1,
  SupportedCurrency.crc: 508.0,
  SupportedCurrency.isk: 136.5,
  SupportedCurrency.mop: 8.05,
  SupportedCurrency.jod: 0.71,
  SupportedCurrency.lbp: 89500.0,
  SupportedCurrency.bob: 6.92,
  SupportedCurrency.uyu: 42.3,
};

const Map<SupportedCurrency, double> _demoCryptoUsdPrices = {
  SupportedCurrency.btc: 67250.0,
  SupportedCurrency.eth: 3480.0,
  SupportedCurrency.usdt: 1.0,
  SupportedCurrency.usdc: 1.0,
  SupportedCurrency.bnb: 605.0,
  SupportedCurrency.xrp: 0.61,
  SupportedCurrency.sol: 158.0,
  SupportedCurrency.ada: 0.72,
  SupportedCurrency.doge: 0.16,
  SupportedCurrency.trx: 0.12,
  SupportedCurrency.ton: 6.1,
  SupportedCurrency.avax: 39.8,
  SupportedCurrency.dot: 8.3,
  SupportedCurrency.link: 18.4,
  SupportedCurrency.bch: 485.0,
  SupportedCurrency.ltc: 82.0,
  SupportedCurrency.xlm: 0.14,
  SupportedCurrency.etc: 30.5,
  SupportedCurrency.atom: 11.8,
  SupportedCurrency.xmr: 138.0,
  SupportedCurrency.near: 7.2,
  SupportedCurrency.apt: 12.1,
  SupportedCurrency.sui: 1.8,
  SupportedCurrency.op: 3.2,
  SupportedCurrency.arb: 1.7,
  SupportedCurrency.inj: 32.0,
  SupportedCurrency.shib: 0.000028,
  SupportedCurrency.fil: 8.4,
  SupportedCurrency.hbar: 0.11,
  SupportedCurrency.icp: 12.5,
  SupportedCurrency.vet: 0.047,
  SupportedCurrency.algo: 0.21,
  SupportedCurrency.aave: 104.0,
  SupportedCurrency.mkr: 2950.0,
  SupportedCurrency.eos: 0.95,
  SupportedCurrency.sand: 0.58,
  SupportedCurrency.mana: 0.49,
  SupportedCurrency.uni: 11.2,
  SupportedCurrency.jup: 1.05,
  SupportedCurrency.kas: 0.17,
  SupportedCurrency.tao: 540.0,
  SupportedCurrency.cro: 0.14,
  SupportedCurrency.pepe: 0.000011,
  SupportedCurrency.wif: 2.1,
  SupportedCurrency.bonk: 0.000029,
  SupportedCurrency.stx: 3.0,
  SupportedCurrency.theta: 2.4,
  SupportedCurrency.gala: 0.052,
  SupportedCurrency.flow: 0.89,
  SupportedCurrency.xtz: 1.42,
  SupportedCurrency.zec: 31.0,
  SupportedCurrency.comp: 64.0,
  SupportedCurrency.snx: 3.3,
  SupportedCurrency.jto: 4.1,
  SupportedCurrency.tia: 14.5,
  SupportedCurrency.kcs: 11.1,
  SupportedCurrency.qnt: 118.0,
  // Дополнительные криптовалюты
  SupportedCurrency.matic: 0.72,
  SupportedCurrency.ldo: 2.1,
  SupportedCurrency.imx: 1.8,
  SupportedCurrency.grt: 0.28,
  SupportedCurrency.rpl: 28.5,
  SupportedCurrency.flr: 0.035,
  SupportedCurrency.egld: 42.0,
  SupportedCurrency.kava: 0.55,
  SupportedCurrency.chz: 0.085,
  SupportedCurrency.bat: 0.22,
  SupportedCurrency.enj: 0.28,
  SupportedCurrency.zrx: 0.48,
  SupportedCurrency.inch: 0.42,
  SupportedCurrency.crv: 0.52,
  SupportedCurrency.bal: 2.8,
  SupportedCurrency.yfi: 7200.0,
  SupportedCurrency.sushi: 0.85,
  SupportedCurrency.ren: 0.065,
  SupportedCurrency.lrc: 0.22,
  SupportedCurrency.knc: 0.58,
  SupportedCurrency.ant: 4.2,
  SupportedCurrency.storj: 0.52,
  SupportedCurrency.omg: 0.62,
  SupportedCurrency.qtum: 3.2,
  SupportedCurrency.icx: 0.18,
  SupportedCurrency.zilliqa: 0.025,
  SupportedCurrency.ont: 0.28,
  SupportedCurrency.vet2: 0.047,
  SupportedCurrency.theta2: 2.4,
  SupportedCurrency.tfuel: 0.085,
  SupportedCurrency.hnt: 7.2,
  SupportedCurrency.egld2: 42.0,
  SupportedCurrency.klay: 0.15,
  SupportedCurrency.btt: 0.0000012,
  SupportedCurrency.hot: 0.0022,
  SupportedCurrency.win: 0.000085,
  SupportedCurrency.dgb: 0.012,
  SupportedCurrency.sc: 0.0058,
  SupportedCurrency.zen: 12.5,
  SupportedCurrency.rvn: 0.022,
  SupportedCurrency.dcr: 14.5,
  SupportedCurrency.lsks: 1.2,
  SupportedCurrency.waves: 2.1,
  SupportedCurrency.ardr: 0.085,
  SupportedCurrency.strax: 0.52,
  SupportedCurrency.nano: 1.1,
  SupportedCurrency.iotx: 0.048,
  SupportedCurrency.ckb: 0.012,
  SupportedCurrency.ank: 0.018,
  SupportedCurrency.celr: 0.022,
  SupportedCurrency.ct: 0.035,
  SupportedCurrency.fun: 0.012,
  SupportedCurrency.req: 0.12,
  SupportedCurrency.poly: 0.085,
  SupportedCurrency.audio: 0.15,
  SupportedCurrency.ash: 0.028,
  SupportedCurrency.mask: 3.2,
  SupportedCurrency.per: 0.42,
  SupportedCurrency.super: 0.58,
  SupportedCurrency.ilv: 42.0,
  SupportedCurrency.rad: 1.8,
  SupportedCurrency.bnt: 0.52,
  SupportedCurrency.alpha: 0.12,
  SupportedCurrency.dydx: 2.8,
  SupportedCurrency.gmx: 42.0,
  SupportedCurrency.magic: 0.85,
  SupportedCurrency.rdnt: 0.28,
  SupportedCurrency.gns: 4.2,
  SupportedCurrency.pendle: 5.2,
  SupportedCurrency.blur: 0.42,
  SupportedCurrency.pepe2: 0.000011,
  SupportedCurrency.floki: 0.00018,
  SupportedCurrency.babydoge: 0.0000035,
  SupportedCurrency.akita: 0.0000012,
  SupportedCurrency.kishu: 0.00000085,
  SupportedCurrency.safemoon: 0.00012,
  SupportedCurrency.elon: 0.00000028,
  SupportedCurrency.dogelon: 0.00000042,
  SupportedCurrency.catgirl: 0.00000018,
  SupportedCurrency.shib2: 0.000028,
  SupportedCurrency.leash: 285.0,
  SupportedCurrency.bone: 0.52,
  SupportedCurrency.tlos: 0.42,
  SupportedCurrency.wemix: 1.2,
  SupportedCurrency.rose: 0.085,
  SupportedCurrency.one: 0.018,
  SupportedCurrency.harmony: 0.018,
  SupportedCurrency.celo: 0.58,
  SupportedCurrency.ar: 18.5,
  SupportedCurrency.fil2: 8.4,
  SupportedCurrency.iotex: 0.048,
  SupportedCurrency.skale: 0.058,
  SupportedCurrency.audio2: 0.15,
  SupportedCurrency.ren2: 0.065,
  SupportedCurrency.lpt: 8.5,
  SupportedCurrency.nmr: 15.5,
  SupportedCurrency.bnt2: 0.52,
  SupportedCurrency.kava2: 0.55,
  SupportedCurrency.band: 1.5,
  SupportedCurrency.ocean: 0.58,
  SupportedCurrency.fet: 1.8,
  SupportedCurrency.agix: 0.85,
  SupportedCurrency.rlc: 1.8,
  SupportedCurrency.nu: 0.18,
  SupportedCurrency.keep: 0.15,
  SupportedCurrency.grt2: 0.28,
  SupportedCurrency.api3: 1.5,
  SupportedCurrency.badger: 3.2,
  SupportedCurrency.farm: 4.2,
  SupportedCurrency.cream: 18.5,
  SupportedCurrency.bifi: 285.0,
  SupportedCurrency.alpha2: 0.12,
  SupportedCurrency.hard: 0.15,
  SupportedCurrency.kava3: 0.55,
  SupportedCurrency.swp: 0.42,
  SupportedCurrency.usdx: 1.0,
  SupportedCurrency.xrp2: 0.61,
  SupportedCurrency.beth: 3480.0,
  SupportedCurrency.steth: 3480.0,
  SupportedCurrency.reth: 3650.0,
  SupportedCurrency.cbeth: 3580.0,
  SupportedCurrency.wbeth: 3520.0,
  SupportedCurrency.ankr2: 0.018,
  SupportedCurrency.sfrxeth: 3650.0,
  SupportedCurrency.frxeth: 3480.0,
  SupportedCurrency.wsteth: 3850.0,
  SupportedCurrency.lusc: 1.0,
  SupportedCurrency.sdai: 1.05,
  SupportedCurrency.dai: 1.0,
  SupportedCurrency.tusd: 1.0,
  SupportedCurrency.busd: 1.0,
  SupportedCurrency.gusd: 1.0,
  SupportedCurrency.pax: 1.0,
  SupportedCurrency.husd: 1.0,
  SupportedCurrency.usdp: 1.0,
  SupportedCurrency.frax: 1.0,
  SupportedCurrency.lusd: 1.0,
  SupportedCurrency.usdd: 1.0,
  SupportedCurrency.usdk: 1.0,
  SupportedCurrency.rsr: 0.0058,
  SupportedCurrency.ohm: 12.5,
  SupportedCurrency.time: 8.5,
  SupportedCurrency.memo: 42.0,
  SupportedCurrency.klima: 4.2,
  SupportedCurrency.bct: 0.58,
  SupportedCurrency.nct: 0.18,
  SupportedCurrency.ubo: 1.0,
  SupportedCurrency.nbo: 1.0,
  SupportedCurrency.mco2: 15.5,
  SupportedCurrency.toucan: 0.85,
  SupportedCurrency.karbon: 0.028,
  SupportedCurrency.c3: 0.42,
  SupportedCurrency.flow2: 0.89,
  SupportedCurrency.mint: 0.085,
  SupportedCurrency.loom: 0.058,
  SupportedCurrency.man: 0.49,
  SupportedCurrency.red: 0.028,
  SupportedCurrency.yield: 8.5,
  SupportedCurrency.yld: 0.12,
  SupportedCurrency.idle: 0.42,
  SupportedCurrency.pickle: 0.85,
  SupportedCurrency.cover: 18.5,
  SupportedCurrency.hegic: 0.028,
  SupportedCurrency.opyn: 0.15,
  SupportedCurrency.ribbon: 0.42,
  SupportedCurrency.lyra: 0.58,
  SupportedCurrency.dopex: 42.0,
  SupportedCurrency.jones: 2.8,
  SupportedCurrency.umami: 8.5,
  SupportedCurrency.glp: 1.05,
  SupportedCurrency.gmlp: 1.05,
  SupportedCurrency.qimlp: 1.05,
  SupportedCurrency.plv: 42.0,
  SupportedCurrency.rdnt2: 0.28,
  SupportedCurrency.gns2: 4.2,
  SupportedCurrency.myc: 0.18,
  SupportedCurrency.cap: 18.5,
  SupportedCurrency.myc2: 0.18,
  SupportedCurrency.sd: 2.8,
  SupportedCurrency.frax3: 1.0,
  SupportedCurrency.fx: 0.42,
  SupportedCurrency.cvx: 2.8,
  SupportedCurrency.fxs: 8.5,
  SupportedCurrency.alcx: 18.5,
  SupportedCurrency.tribe: 0.42,
  SupportedCurrency.fei: 1.0,
  SupportedCurrency.rari: 0.85,
  SupportedCurrency.dola: 1.0,
  SupportedCurrency.inv: 42.0,
  SupportedCurrency.mta: 0.58,
  SupportedCurrency.bpt: 0.15,
  SupportedCurrency.aura: 0.85,
  SupportedCurrency.hid: 0.42,
  SupportedCurrency.aave2: 104.0,
  SupportedCurrency.stk: 0.85,
  SupportedCurrency.gho: 1.0,
  SupportedCurrency.eth2: 3480.0,
  SupportedCurrency.weth: 3480.0,
  SupportedCurrency.beeth: 3480.0,
  SupportedCurrency.ankr3: 0.018,
  SupportedCurrency.sfrxeth2: 3650.0,
  SupportedCurrency.frxeth2: 3480.0,
  SupportedCurrency.wsteth2: 3850.0,
  SupportedCurrency.lusc2: 1.0,
  SupportedCurrency.sdai2: 1.05,
  SupportedCurrency.dai2: 1.0,
  SupportedCurrency.tusd2: 1.0,
  SupportedCurrency.busd2: 1.0,
  SupportedCurrency.gusd2: 1.0,
  SupportedCurrency.pax2: 1.0,
  SupportedCurrency.husd2: 1.0,
  SupportedCurrency.usdp2: 1.0,
  SupportedCurrency.frax2: 1.0,
  SupportedCurrency.lusd2: 1.0,
  SupportedCurrency.usdd2: 1.0,
  SupportedCurrency.usdk2: 1.0,
  SupportedCurrency.rsr2: 0.0058,
  SupportedCurrency.ohm2: 12.5,
  SupportedCurrency.time2: 8.5,
  SupportedCurrency.memo2: 42.0,
  SupportedCurrency.klima2: 4.2,
  SupportedCurrency.bct2: 0.58,
  SupportedCurrency.nct2: 0.18,
  SupportedCurrency.ubo2: 1.0,
  SupportedCurrency.nbo2: 1.0,
  SupportedCurrency.mco2_2: 15.5,
  SupportedCurrency.toucan2: 0.85,
  SupportedCurrency.karbon2: 0.028,
  SupportedCurrency.c32: 0.42,
};

/// Модель для сводки по активам: общий баланс и потраченный баланс
class AssetBalanceSummary {
  final double totalAssets;     // Общий баланс всех активов в базовой валюте
  final double spentBalance;    // Потраченный баланс (расходы за период)
  final SupportedCurrency baseCurrency;
  final String periodLabel;

  const AssetBalanceSummary({
    required this.totalAssets,
    required this.spentBalance,
    required this.baseCurrency,
    required this.periodLabel,
  });

  factory AssetBalanceSummary.fromJson(Map<String, dynamic> json) {
    final totalAssetsNum = json['totalAssets'] as num? ?? 0;
    final spentBalanceNum = json['spentBalance'] as num? ?? 0;
    final baseCurrencyCode = json['baseCurrency'] as String? ?? 'USD';
    final periodLabel = json['periodLabel'] as String? ?? '';

    return AssetBalanceSummary(
      totalAssets: totalAssetsNum.toDouble(),
      spentBalance: spentBalanceNum.toDouble(),
      baseCurrency: SupportedCurrencyX.fromCode(baseCurrencyCode),
      periodLabel: periodLabel,
    );
  }

  /// Чистый баланс (активы минус расходы)
  double get netBalance => totalAssets - spentBalance;

  /// Процент расходов от общего баланса
  double get spendingPercent {
    if (totalAssets <= 0) return 0;
    return (spentBalance / totalAssets).clamp(0, 1);
  }

  AssetBalanceSummary copyWith({
    double? totalAssets,
    double? spentBalance,
    SupportedCurrency? baseCurrency,
    String? periodLabel,
  }) {
    return AssetBalanceSummary(
      totalAssets: totalAssets ?? this.totalAssets,
      spentBalance: spentBalance ?? this.spentBalance,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      periodLabel: periodLabel ?? this.periodLabel,
    );
  }

  factory AssetBalanceSummary.empty({
    SupportedCurrency baseCurrency = SupportedCurrency.usd,
    String periodLabel = 'This month',
  }) {
    return const AssetBalanceSummary(
      totalAssets: 0,
      spentBalance: 0,
      baseCurrency: SupportedCurrency.usd,
      periodLabel: 'This month',
    ).copyWith(
      baseCurrency: baseCurrency,
      periodLabel: periodLabel,
    );
  }
}
