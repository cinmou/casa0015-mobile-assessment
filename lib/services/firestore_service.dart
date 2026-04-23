import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/decision_node.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference? get _userDecisionsRef {
    if (_uid == null) return null;
    // Store each user's decision timeline under their anonymous UID.
    return _db.collection('users').doc(_uid).collection('decisions');
  }

  Future<void> saveDecision(DecisionNode node) async {
    final ref = _userDecisionsRef;
    if (ref == null) {
      print("Error: Cannot save decision. No user is signed in.");
      return;
    }

    try {
      if (node.id != null && node.id!.isNotEmpty) {
        await ref.doc(node.id).set(node.toMap());
      } else {
        await ref.add(node.toMap());
      }
      print("Decision saved successfully to Firestore.");
    } catch (e) {
      print("Error saving decision to Firestore: $e");
      rethrow;
    }
  }

  Future<void> updateDecision(DecisionNode node) async {
    final ref = _userDecisionsRef;
    if (ref == null || node.id == null || node.id!.isEmpty) {
      print(
        "Error: Cannot update decision. No user signed in or node ID missing.",
      );
      return;
    }

    try {
      await ref.doc(node.id).update(node.toMap());
      print("Decision updated successfully in Firestore.");
    } catch (e) {
      print("Error updating decision in Firestore: $e");
      rethrow;
    }
  }

  Future<void> deleteDecision(String id) async {
    final ref = _userDecisionsRef;
    if (ref == null || id.isEmpty) {
      print(
        "Error: Cannot delete decision. No user signed in or node ID missing.",
      );
      return;
    }

    try {
      await ref.doc(id).delete();
      print("Decision deleted successfully from Firestore.");
    } catch (e) {
      print("Error deleting decision from Firestore: $e");
      rethrow;
    }
  }

  Stream<List<DecisionNode>> getDecisionsStream() {
    final ref = _userDecisionsRef;
    if (ref == null) {
      return Stream.value([]);
    }

    return ref.orderBy('timestamp', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return DecisionNode.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  Future<void> deleteAllUserData() async {
    final ref = _userDecisionsRef;
    if (ref == null) return;

    try {
      final snapshots = await ref.get();

      final batch = _db.batch();
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      await _db.collection('users').doc(_uid).delete();

      print("All user data deleted from Firestore successfully.");
    } catch (e) {
      print("Error deleting user data: $e");
    }
  }
}
