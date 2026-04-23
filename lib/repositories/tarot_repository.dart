import '../models/tarot_card.dart';
import '../services/tarot_service.dart';

class TarotRepository {
  // Cache tarot datasets by language code.
  final Map<String, List<TarotCard>> _cache = {};

  Future<List<TarotCard>> fetchCardsByLanguage(String lang) async {
    print('--- [DEBUG] TarotRepository: Fetching cards for lang: $lang ---');

    if (_cache.containsKey(lang)) {
      print(
        '--- [DEBUG] TarotRepository: Returning cached data for $lang. Count: ${_cache[lang]!.length} ---',
      );
      return _cache[lang]!;
    }

    print(
      '--- [DEBUG] TarotRepository: Cache miss for $lang. Calling Service... ---',
    );
    final cards = await TarotService.loadCards(lang);

    _cache[lang] = cards;
    print(
      '--- [DEBUG] TarotRepository: Data cached for $lang. Count: ${cards.length} ---',
    );
    return cards;
  }

  void clearCache() {
    _cache.clear();
    print('--- [DEBUG] TarotRepository: Cache cleared ---');
  }
}
