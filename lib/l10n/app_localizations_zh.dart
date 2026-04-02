// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '神谕';

  @override
  String get bottomNavChoice => '做选择';

  @override
  String get bottomNavMap => '抉择地图';

  @override
  String get bottomNavQuick => '速选';

  @override
  String get bottomNavAiDraw => 'AI 绘图';

  @override
  String get bottomNavOracle => '神谕';

  @override
  String get bottomNavMe => '我';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsAppearance => '外观';

  @override
  String get settingsTheme => '主题';

  @override
  String get settingsThemeSystem => '跟随系统';

  @override
  String get settingsThemeLight => '浅色模式';

  @override
  String get settingsThemeDark => '深色模式';

  @override
  String get settingsPreferences => '偏好';

  @override
  String get settingsLanguage => '语言';

  @override
  String get settingsLanguageSystem => '跟随系统';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageChinese => '简体中文';

  @override
  String get settingsLanguageTraditionalChinese => '繁體中文';

  @override
  String get settingsLanguageJapanese => '日本語';

  @override
  String get settingsAbout => '关于';

  @override
  String get settingsVersion => '版本';

  @override
  String get quickPickTitle => '做出选择';

  @override
  String get quickPickCoinFlip => '抛硬币';

  @override
  String get quickPickDiceRoll => '掷骰子';

  @override
  String get quickPickDrawCard => '抽张卡';

  @override
  String get quickPickFortuneSticks => '摇签筒';

  @override
  String get oraclePickTitle => '塔罗工坊';

  @override
  String get oraclePickLibrary => '牌库';

  @override
  String get oraclePickDailyDraw => '每日一抽';

  @override
  String get oraclePickClassicSpread => '经典牌阵';

  @override
  String get tarotDisplayTitle => '塔罗牌';

  @override
  String get tarotDisplaySelectCard => '选择塔罗牌';

  @override
  String get tarotDisplayUprightMeaning => '正位释义';

  @override
  String get tarotDisplayReversedMeaning => '逆位释义';

  @override
  String tarotDisplayKeywords(Object keywords) {
    return '关键词: $keywords';
  }

  @override
  String get singleDrawTitle => '揭示命运';

  @override
  String get singleDrawReversed => '逆位';

  @override
  String get singleDrawTapToReveal => '点击卡牌以揭示';

  @override
  String get singleDrawShowMeaning => '查看解读';

  @override
  String get pastPresentFutureTitle => '三圣命运';

  @override
  String get pastPresentFuturePast => '过去';

  @override
  String get pastPresentFuturePresent => '现在';

  @override
  String get pastPresentFutureFuture => '未来';

  @override
  String get pastPresentFuturePastDesc => '问题的根源';

  @override
  String get pastPresentFuturePresentDesc => '当前的能量';

  @override
  String get pastPresentFutureFutureDesc => '可能的结果';

  @override
  String get pastPresentFutureReadFullMeaning => '查看完整解读';

  @override
  String get readingSummaryTitle => '解读概要';

  @override
  String get readingSummaryReversedAbbr => '逆';

  @override
  String get clearHistory => '清空历史';

  @override
  String get clearHistoryConfirmation => '此操作将删除所有未收藏的条目。此操作无法撤销。';

  @override
  String get cancel => '取消';

  @override
  String get clear => '清空';

  @override
  String get noHistory => '暂无历史记录。';

  @override
  String get question => '问题';

  @override
  String get deleteRecord => '删除记录?';

  @override
  String deleteRecordConfirmation(Object cardName) {
    return '您确定要移除关于“$cardName”的记录吗？此操作无法撤销。';
  }

  @override
  String get recordDeleted => '记录已删除';

  @override
  String get delete => '删除';

  @override
  String get editQuestion => '编辑问题';

  @override
  String get editQuestionHint => '你当时的问题是什么？';

  @override
  String get save => '保存';

  @override
  String get tripleCardHistoryTitle => '三牌牌阵历史';

  @override
  String get choiceScreenTitle => '做出你的选择';

  @override
  String get decisionMapScreenTitle => '你的抉择地图';

  @override
  String get appIntroductionTitle => '什么是“神谕”？';

  @override
  String get appIntroductionContent => '本应用将每一次的随机决策与用户当下的物理环境（天气、位置、时间）深度绑定。你的每一个选择，都将成为个人专属“抉择地图”上的一个独特节点，最终汇聚成一段充满探索性的个人叙事。';

  @override
  String get ok => '好的';

  @override
  String get saveToMap => '收录至抉择地图';

  @override
  String saveToMapResult(String result) {
    return '结果: $result';
  }

  @override
  String get saveToMapQuestionHint => '你现在的困惑或问题是什么？';

  @override
  String get saveToMapMood => '你现在的心情？';

  @override
  String get saveToMapSolutionHint => '你最终决定做什么？';

  @override
  String get savedToMapSuccess => '已成功收录至抉择地图！';

  @override
  String get settingsDataManagement => '数据管理';

  @override
  String get settingsYourUserId => '你的用户 ID';

  @override
  String get settingsCopyId => '复制 ID';

  @override
  String get settingsRestoreData => '恢复数据';

  @override
  String get settingsRestoreDataTitle => '从 ID 恢复数据';

  @override
  String get settingsRestoreDataWarning => '警告：此操作将删除此设备上的所有当前数据，并尝试加载所提供 ID 的关联数据。此操作对当前数据不可撤销。';

  @override
  String get settingsRestoreDataHint => '输入要恢复的用户 ID';

  @override
  String get settingsRestoreDataConfirm => '恢复';

  @override
  String get settingsRestoreDataSuccess => '数据恢复已启动。请重启应用。';

  @override
  String get settingsRestoreDataError => '无法恢复数据。请检查 ID 后重试。';

  @override
  String get settingsDeleteAccount => '删除我的账户';

  @override
  String get settingsDeleteAccountWarning => '警告：此操作将永久删除您的账户及所有关联数据。此操作无法撤销。';

  @override
  String get settingsDeleteAccountConfirm => '删除账户';

  @override
  String get settingsDeleteAccountSuccess => '账户已删除。正在重启应用...';

  @override
  String get settingsDeleteAccountError => '无法删除账户。请稍后重试。';
}
