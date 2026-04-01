import 'package:cloud_firestore/cloud_firestore.dart';

class DecisionNode {
  final String? id; // Firestore 文档 ID
  final DateTime timestamp; // 决策时间
  final String tool; // 使用的工具 (例如: "Coin", "Tarot", "Dice")
  final String result; // 工具给出的随机结果
  final String question; // 用户的困惑/问题
  final String solution; // 用户最终选择的决定/方案
  final String mood; // 用户当时的心情 (例如 Emoji)
  final double? latitude; // 纬度
  final double? longitude; // 经度
  final String? weatherCondition; // 天气状况 (例如: "Clear", "Rain")
  final double? temperature; // 气温

  DecisionNode({
    this.id,
    required this.timestamp,
    required this.tool,
    required this.result,
    required this.question,
    required this.solution,
    required this.mood,
    this.latitude,
    this.longitude,
    this.weatherCondition,
    this.temperature,
  });

  /// 从 Firestore 的数据 Map 转换为 DecisionNode 对象
  factory DecisionNode.fromMap(Map<String, dynamic> map, String documentId) {
    return DecisionNode(
      id: documentId,
      // Firestore 中存储的时间是 Timestamp 类型，需要转换为 DateTime
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      tool: map['tool'] ?? '',
      result: map['result'] ?? '',
      question: map['question'] ?? '',
      solution: map['solution'] ?? '',
      mood: map['mood'] ?? '',
      // 将可能会存储为 int 的数值转换为 double
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      weatherCondition: map['weatherCondition'],
      temperature: map['temperature']?.toDouble(),
    );
  }

  /// 将 DecisionNode 对象转换为可存入 Firestore 的 Map 数据
  Map<String, dynamic> toMap() {
    return {
      // 存入 Firestore 时，使用 Timestamp 类型更好
      'timestamp': Timestamp.fromDate(timestamp),
      'tool': tool,
      'result': result,
      'question': question,
      'solution': solution,
      'mood': mood,
      // 只有在数据存在时才保存
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (weatherCondition != null) 'weatherCondition': weatherCondition,
      if (temperature != null) 'temperature': temperature,
    };
  }

  /// 方便更新某些字段的 copyWith 方法
  DecisionNode copyWith({
    String? id,
    DateTime? timestamp,
    String? tool,
    String? result,
    String? question,
    String? solution,
    String? mood,
    double? latitude,
    double? longitude,
    String? weatherCondition,
    double? temperature,
  }) {
    return DecisionNode(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      tool: tool ?? this.tool,
      result: result ?? this.result,
      question: question ?? this.question,
      solution: solution ?? this.solution,
      mood: mood ?? this.mood,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      weatherCondition: weatherCondition ?? this.weatherCondition,
      temperature: temperature ?? this.temperature,
    );
  }
}
