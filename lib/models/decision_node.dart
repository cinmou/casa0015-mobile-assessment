import 'package:cloud_firestore/cloud_firestore.dart';

class DecisionNode {
  final String? id;
  final DateTime timestamp;
  final String tool;
  final String result;
  final String question;
  final String solution;
  final String mood;
  final double? latitude;
  final double? longitude;
  final String? weatherCondition;
  final double? temperature;
  final String? imagePath;

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
    this.imagePath,
  });

  factory DecisionNode.fromMap(Map<String, dynamic> map, String documentId) {
    return DecisionNode(
      id: documentId,
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      tool: map['tool'] ?? '',
      result: map['result'] ?? '',
      question: map['question'] ?? '',
      solution: map['solution'] ?? '',
      mood: map['mood'] ?? '',
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      weatherCondition: map['weatherCondition'],
      temperature: map['temperature']?.toDouble(),
      imagePath: map['imagePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'timestamp': Timestamp.fromDate(timestamp),
      'tool': tool,
      'result': result,
      'question': question,
      'solution': solution,
      'mood': mood,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (weatherCondition != null) 'weatherCondition': weatherCondition,
      if (temperature != null) 'temperature': temperature,
      if (imagePath != null) 'imagePath': imagePath,
    };
  }

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
    String? imagePath,
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
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
