import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'The Oracle'**
  String get appTitle;

  /// No description provided for @bottomNavChoice.
  ///
  /// In en, this message translates to:
  /// **'Choice'**
  String get bottomNavChoice;

  /// No description provided for @bottomNavMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get bottomNavMap;

  /// No description provided for @bottomNavQuick.
  ///
  /// In en, this message translates to:
  /// **'Quick'**
  String get bottomNavQuick;

  /// No description provided for @bottomNavAiDraw.
  ///
  /// In en, this message translates to:
  /// **'AI Draw'**
  String get bottomNavAiDraw;

  /// No description provided for @bottomNavOracle.
  ///
  /// In en, this message translates to:
  /// **'Oracle'**
  String get bottomNavOracle;

  /// No description provided for @bottomNavMe.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get bottomNavMe;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsPreferences;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageChinese.
  ///
  /// In en, this message translates to:
  /// **'简体中文'**
  String get settingsLanguageChinese;

  /// No description provided for @settingsLanguageTraditionalChinese.
  ///
  /// In en, this message translates to:
  /// **'繁體中文'**
  String get settingsLanguageTraditionalChinese;

  /// No description provided for @settingsLanguageJapanese.
  ///
  /// In en, this message translates to:
  /// **'日本語'**
  String get settingsLanguageJapanese;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @quickPickTitle.
  ///
  /// In en, this message translates to:
  /// **'Make a Choice'**
  String get quickPickTitle;

  /// No description provided for @quickPickCoinFlip.
  ///
  /// In en, this message translates to:
  /// **'Coin Flip'**
  String get quickPickCoinFlip;

  /// No description provided for @quickPickDiceRoll.
  ///
  /// In en, this message translates to:
  /// **'Dice Roll'**
  String get quickPickDiceRoll;

  /// No description provided for @quickPickDrawCard.
  ///
  /// In en, this message translates to:
  /// **'Draw Card'**
  String get quickPickDrawCard;

  /// No description provided for @quickPickFortuneSticks.
  ///
  /// In en, this message translates to:
  /// **'Fortune Sticks'**
  String get quickPickFortuneSticks;

  /// No description provided for @oraclePickTitle.
  ///
  /// In en, this message translates to:
  /// **'Tarot Workshop'**
  String get oraclePickTitle;

  /// No description provided for @oraclePickLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get oraclePickLibrary;

  /// No description provided for @oraclePickDailyDraw.
  ///
  /// In en, this message translates to:
  /// **'Daily Draw'**
  String get oraclePickDailyDraw;

  /// No description provided for @oraclePickClassicSpread.
  ///
  /// In en, this message translates to:
  /// **'Classic Spread'**
  String get oraclePickClassicSpread;

  /// No description provided for @tarotDisplayTitle.
  ///
  /// In en, this message translates to:
  /// **'Tarot'**
  String get tarotDisplayTitle;

  /// No description provided for @tarotDisplaySelectCard.
  ///
  /// In en, this message translates to:
  /// **'Select Tarot Card'**
  String get tarotDisplaySelectCard;

  /// No description provided for @tarotDisplayUprightMeaning.
  ///
  /// In en, this message translates to:
  /// **'Upright Meaning'**
  String get tarotDisplayUprightMeaning;

  /// No description provided for @tarotDisplayReversedMeaning.
  ///
  /// In en, this message translates to:
  /// **'Reversed Meaning'**
  String get tarotDisplayReversedMeaning;

  /// No description provided for @tarotDisplayKeywords.
  ///
  /// In en, this message translates to:
  /// **'Keywords: {keywords}'**
  String tarotDisplayKeywords(Object keywords);

  /// No description provided for @singleDrawTitle.
  ///
  /// In en, this message translates to:
  /// **'Reveal Fate'**
  String get singleDrawTitle;

  /// No description provided for @singleDrawReversed.
  ///
  /// In en, this message translates to:
  /// **'REVERSED'**
  String get singleDrawReversed;

  /// No description provided for @singleDrawTapToReveal.
  ///
  /// In en, this message translates to:
  /// **'TAP CARD TO REVEAL'**
  String get singleDrawTapToReveal;

  /// No description provided for @singleDrawShowMeaning.
  ///
  /// In en, this message translates to:
  /// **'SHOW MEANING'**
  String get singleDrawShowMeaning;

  /// No description provided for @pastPresentFutureTitle.
  ///
  /// In en, this message translates to:
  /// **'Three Fates'**
  String get pastPresentFutureTitle;

  /// No description provided for @pastPresentFuturePast.
  ///
  /// In en, this message translates to:
  /// **'THE PAST'**
  String get pastPresentFuturePast;

  /// No description provided for @pastPresentFuturePresent.
  ///
  /// In en, this message translates to:
  /// **'THE PRESENT'**
  String get pastPresentFuturePresent;

  /// No description provided for @pastPresentFutureFuture.
  ///
  /// In en, this message translates to:
  /// **'THE FUTURE'**
  String get pastPresentFutureFuture;

  /// No description provided for @pastPresentFuturePastDesc.
  ///
  /// In en, this message translates to:
  /// **'Roots of the matter'**
  String get pastPresentFuturePastDesc;

  /// No description provided for @pastPresentFuturePresentDesc.
  ///
  /// In en, this message translates to:
  /// **'Current energy'**
  String get pastPresentFuturePresentDesc;

  /// No description provided for @pastPresentFutureFutureDesc.
  ///
  /// In en, this message translates to:
  /// **'Potential outcome'**
  String get pastPresentFutureFutureDesc;

  /// No description provided for @pastPresentFutureReadFullMeaning.
  ///
  /// In en, this message translates to:
  /// **'READ FULL MEANING'**
  String get pastPresentFutureReadFullMeaning;

  /// No description provided for @readingSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading Summary'**
  String get readingSummaryTitle;

  /// No description provided for @readingSummaryReversedAbbr.
  ///
  /// In en, this message translates to:
  /// **'REV'**
  String get readingSummaryReversedAbbr;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear History'**
  String get clearHistory;

  /// No description provided for @clearHistoryConfirmation.
  ///
  /// In en, this message translates to:
  /// **'This will delete all non-favorited entries. This action cannot be undone.'**
  String get clearHistoryConfirmation;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No history yet.'**
  String get noHistory;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @deleteRecord.
  ///
  /// In en, this message translates to:
  /// **'Delete Record?'**
  String get deleteRecord;

  /// No description provided for @deleteRecordConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove the record for \'{cardName}\'? This action cannot be undone.'**
  String deleteRecordConfirmation(Object cardName);

  /// No description provided for @recordDeleted.
  ///
  /// In en, this message translates to:
  /// **'Record deleted'**
  String get recordDeleted;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editDecision.
  ///
  /// In en, this message translates to:
  /// **'Edit Decision'**
  String get editDecision;

  /// No description provided for @editQuestion.
  ///
  /// In en, this message translates to:
  /// **'Edit Question'**
  String get editQuestion;

  /// No description provided for @editQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'What was your question?'**
  String get editQuestionHint;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @tripleCardHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Three Card Spread History'**
  String get tripleCardHistoryTitle;

  /// No description provided for @choiceScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Make Your Choice'**
  String get choiceScreenTitle;

  /// No description provided for @decisionMapScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Decision Map'**
  String get decisionMapScreenTitle;

  /// No description provided for @noDecisionsYet.
  ///
  /// In en, this message translates to:
  /// **'No decisions recorded yet. Make a choice and save it to see your map!'**
  String get noDecisionsYet;

  /// No description provided for @appIntroductionTitle.
  ///
  /// In en, this message translates to:
  /// **'What is The Oracle?'**
  String get appIntroductionTitle;

  /// No description provided for @appIntroductionContent.
  ///
  /// In en, this message translates to:
  /// **'This app deeply connects your random decisions with your current physical environment (weather, location, time). Each choice you make is a unique point on your personal \'Decision Map\', creating a narrative of your journey.'**
  String get appIntroductionContent;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @saveToMap.
  ///
  /// In en, this message translates to:
  /// **'Save to Decision Map'**
  String get saveToMap;

  /// No description provided for @saveToMapResult.
  ///
  /// In en, this message translates to:
  /// **'Result: {result}'**
  String saveToMapResult(String result);

  /// No description provided for @saveToMapQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'What was your question or dilemma?'**
  String get saveToMapQuestionHint;

  /// No description provided for @saveToMapMood.
  ///
  /// In en, this message translates to:
  /// **'How do you feel?'**
  String get saveToMapMood;

  /// No description provided for @saveToMapFinalDecision.
  ///
  /// In en, this message translates to:
  /// **'My final decision is...'**
  String get saveToMapFinalDecision;

  /// No description provided for @saveToMapSolutionHint.
  ///
  /// In en, this message translates to:
  /// **'What did you decide to do?'**
  String get saveToMapSolutionHint;

  /// No description provided for @savedToMapSuccess.
  ///
  /// In en, this message translates to:
  /// **'Saved to your Decision Map!'**
  String get savedToMapSuccess;

  /// No description provided for @settingsDataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get settingsDataManagement;

  /// No description provided for @settingsYourUserId.
  ///
  /// In en, this message translates to:
  /// **'Your User ID'**
  String get settingsYourUserId;

  /// No description provided for @settingsCopyId.
  ///
  /// In en, this message translates to:
  /// **'Copy ID'**
  String get settingsCopyId;

  /// No description provided for @settingsUserIdCopied.
  ///
  /// In en, this message translates to:
  /// **'User ID copied to clipboard!'**
  String get settingsUserIdCopied;

  /// No description provided for @settingsRestoreData.
  ///
  /// In en, this message translates to:
  /// **'Restore Data'**
  String get settingsRestoreData;

  /// No description provided for @settingsRestoreDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Data from ID'**
  String get settingsRestoreDataTitle;

  /// No description provided for @settingsRestoreDataWarning.
  ///
  /// In en, this message translates to:
  /// **'WARNING: This will delete all current data on this device and attempt to load data associated with the provided ID. This action cannot be undone for current data.'**
  String get settingsRestoreDataWarning;

  /// No description provided for @settingsRestoreDataHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the User ID to restore from'**
  String get settingsRestoreDataHint;

  /// No description provided for @settingsRestoreDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get settingsRestoreDataConfirm;

  /// No description provided for @settingsRestoreDataSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data restoration initiated. Please restart the app.'**
  String get settingsRestoreDataSuccess;

  /// No description provided for @settingsRestoreDataError.
  ///
  /// In en, this message translates to:
  /// **'Failed to restore data. Please check the ID and try again.'**
  String get settingsRestoreDataError;

  /// No description provided for @settingsDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete My Account'**
  String get settingsDeleteAccount;

  /// No description provided for @settingsDeleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'WARNING: This will permanently delete your account and all associated data. This action cannot be undone.'**
  String get settingsDeleteAccountWarning;

  /// No description provided for @settingsDeleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get settingsDeleteAccountConfirm;

  /// No description provided for @settingsDeleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account deleted. Restarting app...'**
  String get settingsDeleteAccountSuccess;

  /// No description provided for @settingsDeleteAccountError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account. Please try again.'**
  String get settingsDeleteAccountError;

  /// No description provided for @coinFlipTitle.
  ///
  /// In en, this message translates to:
  /// **'Coin Flip'**
  String get coinFlipTitle;

  /// No description provided for @coinFlipResultHeads.
  ///
  /// In en, this message translates to:
  /// **'It\'s Heads!'**
  String get coinFlipResultHeads;

  /// No description provided for @coinFlipResultTails.
  ///
  /// In en, this message translates to:
  /// **'It\'s Tails!'**
  String get coinFlipResultTails;

  /// No description provided for @coinFlipResultEdge.
  ///
  /// In en, this message translates to:
  /// **'It landed on the Edge!'**
  String get coinFlipResultEdge;

  /// No description provided for @coinFlipTapToFlip.
  ///
  /// In en, this message translates to:
  /// **'Tap or shake to flip the coin'**
  String get coinFlipTapToFlip;

  /// No description provided for @coinToolName.
  ///
  /// In en, this message translates to:
  /// **'Coin Flip'**
  String get coinToolName;

  /// No description provided for @coinResultHeads.
  ///
  /// In en, this message translates to:
  /// **'Heads'**
  String get coinResultHeads;

  /// No description provided for @coinResultTails.
  ///
  /// In en, this message translates to:
  /// **'Tails'**
  String get coinResultTails;

  /// No description provided for @coinResultEdge.
  ///
  /// In en, this message translates to:
  /// **'Edge'**
  String get coinResultEdge;

  /// No description provided for @coinResultUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get coinResultUnknown;

  /// No description provided for @diceRollTitle.
  ///
  /// In en, this message translates to:
  /// **'Dice Roll'**
  String get diceRollTitle;

  /// No description provided for @diceRollResult.
  ///
  /// In en, this message translates to:
  /// **'You rolled a {result}'**
  String diceRollResult(String result);

  /// No description provided for @diceRollTapToRoll.
  ///
  /// In en, this message translates to:
  /// **'Tap or shake to roll'**
  String get diceRollTapToRoll;

  /// No description provided for @diceToolName.
  ///
  /// In en, this message translates to:
  /// **'Dice Roll'**
  String get diceToolName;

  /// No description provided for @fortuneStickTitle.
  ///
  /// In en, this message translates to:
  /// **'Fortune Stick'**
  String get fortuneStickTitle;

  /// No description provided for @fortuneStickShort.
  ///
  /// In en, this message translates to:
  /// **'Short Stick'**
  String get fortuneStickShort;

  /// No description provided for @fortuneStickMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium Stick'**
  String get fortuneStickMedium;

  /// No description provided for @fortuneStickLong.
  ///
  /// In en, this message translates to:
  /// **'Long Stick'**
  String get fortuneStickLong;

  /// No description provided for @fortuneStickTapToDraw.
  ///
  /// In en, this message translates to:
  /// **'Tap or shake to draw a stick'**
  String get fortuneStickTapToDraw;

  /// No description provided for @fortuneToolName.
  ///
  /// In en, this message translates to:
  /// **'Fortune Stick'**
  String get fortuneToolName;

  /// No description provided for @fortuneResultUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get fortuneResultUnknown;

  /// No description provided for @mood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get mood;

  /// No description provided for @myFinalDecision.
  ///
  /// In en, this message translates to:
  /// **'My final decision is...'**
  String get myFinalDecision;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @solution.
  ///
  /// In en, this message translates to:
  /// **'Solution'**
  String get solution;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @unknownLocation.
  ///
  /// In en, this message translates to:
  /// **'Unknown Location'**
  String get unknownLocation;

  /// No description provided for @addImage.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get addImage;

  /// No description provided for @addImageSource.
  ///
  /// In en, this message translates to:
  /// **'Choose image source'**
  String get addImageSource;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @deleteImage.
  ///
  /// In en, this message translates to:
  /// **'Delete Photo'**
  String get deleteImage;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
