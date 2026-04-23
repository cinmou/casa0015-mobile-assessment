class TarotCard {
  final String number;
  final String name;
  final String arcana;
  final String? suit;
  final String img;
  final List<String> uprightKeywords;
  final String uprightMeaning;
  final List<String> reversedKeywords;
  final String reversedMeaning;

  TarotCard({
    required this.name,
    required this.number,
    required this.arcana,
    this.suit,
    required this.img,
    required this.uprightKeywords,
    required this.uprightMeaning,
    required this.reversedKeywords,
    required this.reversedMeaning,
  });

  factory TarotCard.fromJson(Map<String, dynamic> json) {
    return TarotCard(
      name: json['name'],
      number: json['number'],
      arcana: json['arcana'],
      suit: json['suit'],
      img: json['img'],
      uprightKeywords: List<String>.from(json['upright']['keywords']),
      uprightMeaning: json['upright']['meaning'],
      reversedKeywords: List<String>.from(json['reversed']['keywords']),
      reversedMeaning: json['reversed']['meaning'],
    );
  }

  String get fullPath => 'assets/images/tarot/$img';
}
