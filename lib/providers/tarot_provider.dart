import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../models/tarot_card.dart';
import '../repositories/tarot_repository.dart';

class TarotProvider extends ChangeNotifier {
  final TarotRepository _repository = TarotRepository();

  List<TarotCard> _cards = [];
  String _currentLang = 'en';
  bool _isLoading = false;

  List<TarotCard> get cards => _cards;
  String get currentLang => _currentLang;
  bool get isLoading => _isLoading;

  Future<void> init([String initialLang = 'en']) async {
    await loadTarotData(initialLang);
  }

  Future<void> loadTarotData([String lang = 'en']) async {
    print(
      '--- [DEBUG] TarotProvider: loadTarotData called with lang: $lang ---',
    );
    _isLoading = true;
    notifyListeners();

    String actualLang = lang;
    if (lang == 'system') {
      String systemLocale = ui.PlatformDispatcher.instance.locale.languageCode;
      print(
        '--- [DEBUG] TarotProvider: System locale detected: $systemLocale ---',
      );

      // Fall back to English when the device locale has no tarot dataset.
      if (['en', 'zh', 'ja'].contains(systemLocale)) {
        actualLang = systemLocale;
      } else {
        actualLang = 'en';
      }
    }

    print(
      '--- [DEBUG] TarotProvider: Final resolved language: $actualLang ---',
    );

    _currentLang = actualLang;
    _cards = await _repository.fetchCardsByLanguage(actualLang);
    print(
      '--- [DEBUG] TarotProvider: Cards loaded. Count: ${_cards.length} ---',
    );

    _isLoading = false;
    notifyListeners();
  }
}
