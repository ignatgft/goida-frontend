import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Goida AI'**
  String get appTitle;

  /// No description provided for @processingReceipt.
  ///
  /// In en, this message translates to:
  /// **'Processing receipt...'**
  String get processingReceipt;

  /// No description provided for @askAi.
  ///
  /// In en, this message translates to:
  /// **'Ask AI anything...'**
  String get askAi;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Goida AI'**
  String get welcome;

  /// No description provided for @loginDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your finances with the help of artificial intelligence'**
  String get loginDescription;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @tryDemoMode.
  ///
  /// In en, this message translates to:
  /// **'Try Demo Mode'**
  String get tryDemoMode;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Tracked assets'**
  String get currentBalance;

  /// No description provided for @availableBalances.
  ///
  /// In en, this message translates to:
  /// **'Currencies'**
  String get availableBalances;

  /// No description provided for @exchangeRate.
  ///
  /// In en, this message translates to:
  /// **'Exchange rate'**
  String get exchangeRate;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @historySubtitle.
  ///
  /// In en, this message translates to:
  /// **'All operations from backend grouped by categories.'**
  String get historySubtitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @addExpenseAction.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get addExpenseAction;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addExpense;

  /// No description provided for @expenseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Log what you spent, where, and keep it grouped by category.'**
  String get expenseSubtitle;

  /// No description provided for @expenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Expense title'**
  String get expenseTitle;

  /// No description provided for @enterExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'For example: Coffee, Taxi, Groceries'**
  String get enterExpenseTitle;

  /// No description provided for @expenseCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get expenseCategory;

  /// No description provided for @spendingAccount.
  ///
  /// In en, this message translates to:
  /// **'Spending account'**
  String get spendingAccount;

  /// No description provided for @noAccountSelected.
  ///
  /// In en, this message translates to:
  /// **'Without specific account'**
  String get noAccountSelected;

  /// No description provided for @expenseNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get expenseNote;

  /// No description provided for @expenseNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Optional comment'**
  String get expenseNoteHint;

  /// No description provided for @expenseAdded.
  ///
  /// In en, this message translates to:
  /// **'Expense synced with backend'**
  String get expenseAdded;

  /// No description provided for @expenseSavedLocally.
  ///
  /// In en, this message translates to:
  /// **'Expense saved locally for now'**
  String get expenseSavedLocally;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @topUp.
  ///
  /// In en, this message translates to:
  /// **'Top Up'**
  String get topUp;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategories;

  /// No description provided for @aiChat.
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get aiChat;

  /// No description provided for @charts.
  ///
  /// In en, this message translates to:
  /// **'Charts'**
  String get charts;

  /// No description provided for @assets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get assets;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get thisMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get thisYear;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'Spent'**
  String get spent;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get remaining;

  /// No description provided for @addAsset.
  ///
  /// In en, this message translates to:
  /// **'Add asset'**
  String get addAsset;

  /// No description provided for @assetName.
  ///
  /// In en, this message translates to:
  /// **'Asset name'**
  String get assetName;

  /// No description provided for @enterAssetName.
  ///
  /// In en, this message translates to:
  /// **'For example: Main card'**
  String get enterAssetName;

  /// No description provided for @assetType.
  ///
  /// In en, this message translates to:
  /// **'Asset type'**
  String get assetType;

  /// No description provided for @trackAssets.
  ///
  /// In en, this message translates to:
  /// **'Track how much money you have available for the selected period.'**
  String get trackAssets;

  /// No description provided for @saveAsset.
  ///
  /// In en, this message translates to:
  /// **'Save asset'**
  String get saveAsset;

  /// No description provided for @assetSaved.
  ///
  /// In en, this message translates to:
  /// **'Asset synced with backend'**
  String get assetSaved;

  /// No description provided for @assetSavedLocally.
  ///
  /// In en, this message translates to:
  /// **'Asset saved locally for now'**
  String get assetSavedLocally;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @bankAccount.
  ///
  /// In en, this message translates to:
  /// **'Bank account'**
  String get bankAccount;

  /// No description provided for @savings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savings;

  /// No description provided for @investments.
  ///
  /// In en, this message translates to:
  /// **'Investments'**
  String get investments;

  /// No description provided for @crypto.
  ///
  /// In en, this message translates to:
  /// **'Crypto'**
  String get crypto;

  /// No description provided for @chooseCurrency.
  ///
  /// In en, this message translates to:
  /// **'Choose currency'**
  String get chooseCurrency;

  /// No description provided for @enterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get enterAmount;

  /// No description provided for @changeAvatar.
  ///
  /// In en, this message translates to:
  /// **'Change avatar'**
  String get changeAvatar;

  /// No description provided for @chooseAvatarFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose your photo from gallery'**
  String get chooseAvatarFromGallery;

  /// No description provided for @avatarUploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading avatar...'**
  String get avatarUploading;

  /// No description provided for @avatarUpdated.
  ///
  /// In en, this message translates to:
  /// **'Avatar updated'**
  String get avatarUpdated;

  /// No description provided for @avatarUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update avatar'**
  String get avatarUpdateFailed;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @totalAssets.
  ///
  /// In en, this message translates to:
  /// **'Total assets'**
  String get totalAssets;

  /// No description provided for @selectedFiat.
  ///
  /// In en, this message translates to:
  /// **'Selected fiat'**
  String get selectedFiat;

  /// No description provided for @portfolioMix.
  ///
  /// In en, this message translates to:
  /// **'Portfolio mix'**
  String get portfolioMix;

  /// No description provided for @marketSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Market snapshot'**
  String get marketSnapshot;

  /// No description provided for @spendingVelocity.
  ///
  /// In en, this message translates to:
  /// **'Spending velocity'**
  String get spendingVelocity;

  /// No description provided for @templateStatisticsHint.
  ///
  /// In en, this message translates to:
  /// **'Template block for the future stats screen and backend analytics.'**
  String get templateStatisticsHint;

  /// No description provided for @fiatAssets.
  ///
  /// In en, this message translates to:
  /// **'Fiat assets'**
  String get fiatAssets;

  /// No description provided for @cryptoAssets.
  ///
  /// In en, this message translates to:
  /// **'Crypto assets'**
  String get cryptoAssets;

  /// No description provided for @fiatCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Fiat currencies'**
  String get fiatCurrencies;

  /// No description provided for @cryptoCurrencies.
  ///
  /// In en, this message translates to:
  /// **'Crypto currencies'**
  String get cryptoCurrencies;

  /// No description provided for @searchFiatCurrency.
  ///
  /// In en, this message translates to:
  /// **'Search fiat currency'**
  String get searchFiatCurrency;

  /// No description provided for @searchCryptoCurrency.
  ///
  /// In en, this message translates to:
  /// **'Search cryptocurrency'**
  String get searchCryptoCurrency;

  /// No description provided for @editAsset.
  ///
  /// In en, this message translates to:
  /// **'Edit asset'**
  String get editAsset;

  /// No description provided for @deleteAsset.
  ///
  /// In en, this message translates to:
  /// **'Delete asset'**
  String get deleteAsset;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @assetUpdated.
  ///
  /// In en, this message translates to:
  /// **'Asset updated'**
  String get assetUpdated;

  /// No description provided for @assetDeleted.
  ///
  /// In en, this message translates to:
  /// **'Asset deleted'**
  String get assetDeleted;

  /// No description provided for @noTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsYet;

  /// No description provided for @reviewReceipt.
  ///
  /// In en, this message translates to:
  /// **'Review scanned receipt'**
  String get reviewReceipt;

  /// No description provided for @reviewReceiptSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check OCR details before saving the expense to your history.'**
  String get reviewReceiptSubtitle;

  /// No description provided for @receiptConfidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get receiptConfidence;

  /// No description provided for @receiptItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get receiptItems;

  /// No description provided for @receiptDate.
  ///
  /// In en, this message translates to:
  /// **'Purchase date'**
  String get receiptDate;

  /// No description provided for @receiptNoteHint.
  ///
  /// In en, this message translates to:
  /// **'OCR note or your comment'**
  String get receiptNoteHint;

  /// No description provided for @receiptLineItems.
  ///
  /// In en, this message translates to:
  /// **'Receipt line items'**
  String get receiptLineItems;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @saveReceiptExpense.
  ///
  /// In en, this message translates to:
  /// **'Save receipt expense'**
  String get saveReceiptExpense;

  /// No description provided for @receiptProcessingFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to process receipt'**
  String get receiptProcessingFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
