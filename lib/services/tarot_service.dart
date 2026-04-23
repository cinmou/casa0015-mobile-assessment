import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/tarot_card.dart';

class TarotService {
  static const String cardBackPath = 'assets/images/tarot/CardBacks.png';

  static Future<List<TarotCard>> loadCards(String languageCode) async {
    final String path = 'assets/data/tarot_$languageCode.json';
    print('--- [DEBUG] TarotService: Attempting to load file: $path ---');

    try {
      final String jsonContent = await rootBundle.loadString(path);
      print(
        '--- [DEBUG] TarotService: File loaded successfully. Length: ${jsonContent.length} ---',
      );

      final Map<String, dynamic> rawData = json.decode(jsonContent);
      final List<dynamic> cardsList = rawData['cards'];
      print('--- [DEBUG] TarotService: Parsed ${cardsList.length} cards ---');

      return cardsList.map((item) => TarotCard.fromJson(item)).toList();
    } catch (e) {
      print("--- [DEBUG] TarotService: Error loading tarot data: $e ---");
      return [];
    }
  }
}
