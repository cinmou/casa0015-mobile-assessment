// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'The Oracle';

  @override
  String get bottomNavChoice => 'Choice';

  @override
  String get bottomNavMap => 'Map';

  @override
  String get bottomNavQuick => 'Quick';

  @override
  String get bottomNavAiDraw => 'AI Draw';

  @override
  String get bottomNavOracle => 'Oracle';

  @override
  String get bottomNavMe => 'Me';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeSystem => 'System Default';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsPreferences => 'Preferences';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageSystem => 'System Default';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageChinese => '简体中文';

  @override
  String get settingsLanguageTraditionalChinese => '繁體中文';

  @override
  String get settingsLanguageJapanese => '日本語';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get quickPickTitle => 'Make a Choice';

  @override
  String get quickPickCoinFlip => 'Coin Flip';

  @override
  String get quickPickDiceRoll => 'Dice Roll';

  @override
  String get quickPickDrawCard => 'Draw Card';

  @override
  String get quickPickFortuneSticks => 'Fortune Sticks';

  @override
  String get oraclePickTitle => 'Tarot Workshop';

  @override
  String get oraclePickLibrary => 'Library';

  @override
  String get oraclePickDailyDraw => 'Daily Draw';

  @override
  String get oraclePickClassicSpread => 'Classic Spread';

  @override
  String get tarotDisplayTitle => 'Tarot';

  @override
  String get tarotDisplaySelectCard => 'Select Tarot Card';

  @override
  String get tarotDisplayUprightMeaning => 'Upright Meaning';

  @override
  String get tarotDisplayReversedMeaning => 'Reversed Meaning';

  @override
  String tarotDisplayKeywords(Object keywords) {
    return 'Keywords: $keywords';
  }

  @override
  String get singleDrawTitle => 'Reveal Fate';

  @override
  String get singleDrawReversed => 'REVERSED';

  @override
  String get singleDrawTapToReveal => 'TAP CARD TO REVEAL';

  @override
  String get singleDrawShowMeaning => 'SHOW MEANING';

  @override
  String get pastPresentFutureTitle => 'Three Fates';

  @override
  String get pastPresentFuturePast => 'THE PAST';

  @override
  String get pastPresentFuturePresent => 'THE PRESENT';

  @override
  String get pastPresentFutureFuture => 'THE FUTURE';

  @override
  String get pastPresentFuturePastDesc => 'Roots of the matter';

  @override
  String get pastPresentFuturePresentDesc => 'Current energy';

  @override
  String get pastPresentFutureFutureDesc => 'Potential outcome';

  @override
  String get pastPresentFutureReadFullMeaning => 'READ FULL MEANING';

  @override
  String get readingSummaryTitle => 'Reading Summary';

  @override
  String get readingSummaryReversedAbbr => 'REV';

  @override
  String get clearHistory => 'Clear History';

  @override
  String get clearHistoryConfirmation => 'This will delete all non-favorited entries. This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get clear => 'Clear';

  @override
  String get noHistory => 'No history yet.';

  @override
  String get question => 'Question';

  @override
  String get deleteRecord => 'Delete Record?';

  @override
  String deleteRecordConfirmation(Object cardName) {
    return 'Are you sure you want to remove the record for \'$cardName\'? This action cannot be undone.';
  }

  @override
  String get recordDeleted => 'Record deleted';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get editDecision => 'Edit Decision';

  @override
  String get editQuestion => 'Edit Question';

  @override
  String get editQuestionHint => 'What was your question?';

  @override
  String get save => 'Save';

  @override
  String get tripleCardHistoryTitle => 'Three Card Spread History';

  @override
  String get choiceScreenTitle => 'Make Your Choice';

  @override
  String get decisionMapScreenTitle => 'Your Decision Map';

  @override
  String get noDecisionsYet => 'No decisions recorded yet. Make a choice and save it to see your map!';

  @override
  String get appIntroductionTitle => 'What is The Oracle?';

  @override
  String get appIntroductionContent => 'This app deeply connects your random decisions with your current physical environment (weather, location, time). Each choice you make is a unique point on your personal \'Decision Map\', creating a narrative of your journey.';

  @override
  String get ok => 'OK';

  @override
  String get saveToMap => 'Save to Decision Map';

  @override
  String saveToMapResult(String result) {
    return 'Result: $result';
  }

  @override
  String get saveToMapQuestionHint => 'What was your question or dilemma?';

  @override
  String get saveToMapMood => 'How do you feel?';

  @override
  String get saveToMapFinalDecision => 'My final decision is...';

  @override
  String get saveToMapSolutionHint => 'What did you decide to do?';

  @override
  String get savedToMapSuccess => 'Saved to your Decision Map!';

  @override
  String get settingsDataManagement => 'Data Management';

  @override
  String get settingsYourUserId => 'Your User ID';

  @override
  String get settingsCopyId => 'Copy ID';

  @override
  String get settingsUserIdCopied => 'User ID copied to clipboard!';

  @override
  String get settingsRestoreData => 'Restore Data';

  @override
  String get settingsRestoreDataTitle => 'Restore Data from ID';

  @override
  String get settingsRestoreDataWarning => 'WARNING: This will delete all current data on this device and attempt to load data associated with the provided ID. This action cannot be undone for current data.';

  @override
  String get settingsRestoreDataHint => 'Enter the User ID to restore from';

  @override
  String get settingsRestoreDataConfirm => 'Restore';

  @override
  String get settingsRestoreDataSuccess => 'Data restoration initiated. Please restart the app.';

  @override
  String get settingsRestoreDataError => 'Failed to restore data. Please check the ID and try again.';

  @override
  String get settingsDeleteAccount => 'Delete My Account';

  @override
  String get settingsDeleteAccountWarning => 'WARNING: This will permanently delete your account and all associated data. This action cannot be undone.';

  @override
  String get settingsDeleteAccountConfirm => 'Delete Account';

  @override
  String get settingsDeleteAccountSuccess => 'Account deleted. Restarting app...';

  @override
  String get settingsDeleteAccountError => 'Failed to delete account. Please try again.';

  @override
  String get coinFlipTitle => 'Coin Flip';

  @override
  String get coinFlipResultHeads => 'It\'s Heads!';

  @override
  String get coinFlipResultTails => 'It\'s Tails!';

  @override
  String get coinFlipResultEdge => 'It landed on the Edge!';

  @override
  String get coinFlipTapToFlip => 'Tap or shake to flip the coin';

  @override
  String get coinToolName => 'Coin Flip';

  @override
  String get coinResultHeads => 'Heads';

  @override
  String get coinResultTails => 'Tails';

  @override
  String get coinResultEdge => 'Edge';

  @override
  String get coinResultUnknown => 'Unknown';

  @override
  String get diceRollTitle => 'Dice Roll';

  @override
  String diceRollResult(String result) {
    return 'You rolled a $result';
  }

  @override
  String get diceRollTapToRoll => 'Tap or shake to roll';

  @override
  String get diceToolName => 'Dice Roll';

  @override
  String get fortuneStickTitle => 'Fortune Stick';

  @override
  String get fortuneStickShort => 'Short Stick';

  @override
  String get fortuneStickMedium => 'Medium Stick';

  @override
  String get fortuneStickLong => 'Long Stick';

  @override
  String get fortuneStickTapToDraw => 'Tap or shake to draw a stick';

  @override
  String get fortuneToolName => 'Fortune Stick';

  @override
  String get fortuneResultUnknown => 'Unknown';

  @override
  String get mood => 'Mood';

  @override
  String get myFinalDecision => 'My final decision is...';

  @override
  String get result => 'Result';

  @override
  String get solution => 'Solution';

  @override
  String get location => 'Location';

  @override
  String get unknownLocation => 'Unknown Location';

  @override
  String get addImage => 'Add Image';

  @override
  String get addImageSource => 'Choose image source';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get deleteImage => 'Delete Photo';
}
