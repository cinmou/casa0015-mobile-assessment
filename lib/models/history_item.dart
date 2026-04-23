enum HistoryType { singleTarot, threeSpread, coinToss }

class HistoryItem {
  final String id;
  final HistoryType type;
  final DateTime timestamp;
  final Map<String, dynamic> payload;

  String question;
  bool isFavorite;

  HistoryItem({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.payload,
    this.question = "Revealing the truth",
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type.index,
    'timestamp': timestamp.millisecondsSinceEpoch,
    'payload': payload,
    'question': question,
    'isFavorite': isFavorite,
  };

  factory HistoryItem.fromMap(Map<dynamic, dynamic> map) => HistoryItem(
    id: map['id'],
    type: HistoryType.values[map['type']],
    timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
    payload: Map<String, dynamic>.from(map['payload']),
    question: map['question'] ?? "Current Status Reflection",
    isFavorite: map['isFavorite'] ?? false,
  );
}
