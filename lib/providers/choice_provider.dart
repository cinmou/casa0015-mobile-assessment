import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/decision_node.dart';
import '../services/firestore_service.dart';
import '../services/environment_service.dart';

class ChoiceProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final EnvironmentService _environmentService = EnvironmentService();
  final Uuid _uuid = const Uuid();

  // The stream of decision nodes from Firestore
  Stream<List<DecisionNode>> get decisionStream => _firestoreService.getDecisionsStream();

  Future<void> addDecisionNode({
    required String tool,
    required String result,
    required String question,
    required String solution,
    required String mood,
  }) async {
    final envData = await _environmentService.getEnvironmentData();

    final newNode = DecisionNode(
      id: _uuid.v4(),
      timestamp: DateTime.now(),
      tool: tool,
      result: result,
      question: question,
      solution: solution,
      mood: mood,
      latitude: envData['latitude'],
      longitude: envData['longitude'],
      weatherCondition: envData['weatherCondition'],
      temperature: envData['temperature']?.toDouble(),
    );

    try {
      await _firestoreService.saveDecision(newNode);
      print("Successfully saved node ${newNode.id} to Firestore.");
    } catch (e) {
      print("Failed to save node ${newNode.id} to Firestore: $e");
      rethrow;
    }
  }

  Future<void> updateDecisionNode(DecisionNode updatedNode) async {
    try {
      await _firestoreService.updateDecision(updatedNode);
      print("Successfully updated node ${updatedNode.id} in Firestore.");
    } catch (e) {
      print("Failed to update node ${updatedNode.id} in Firestore: $e");
      rethrow;
    }
  }

  Future<void> deleteDecisionNode(String id) async {
    try {
      await _firestoreService.deleteDecision(id);
      print("Successfully deleted node $id from Firestore.");
    } catch (e) {
      print("Failed to delete node $id from Firestore: $e");
      rethrow;
    }
  }
}
