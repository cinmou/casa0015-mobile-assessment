import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/decision_node.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 获取当前用户的 UID
  // Gets the current user's UID.
  String? get _uid => _auth.currentUser?.uid;

  // 获取用户专属的 decisions 集合引用
  // Gets the reference to the user's specific 'decisions' collection.
  CollectionReference? get _userDecisionsRef {
    if (_uid == null) return null;
    // 数据结构: users -> [UID] -> decisions -> [Auto-ID Documents]
    return _db.collection('users').doc(_uid).collection('decisions');
  }

  /// 保存一个新的决策节点到 Firestore
  /// Saves a new DecisionNode to Firestore under the current user's document.
  Future<void> saveDecision(DecisionNode node) async {
    final ref = _userDecisionsRef;
    if (ref == null) {
      print("Error: Cannot save decision. No user is signed in.");
      return;
    }

    try {
      if (node.id != null && node.id!.isNotEmpty) {
        // Use the provided ID (e.g., from local Hive storage)
        await ref.doc(node.id).set(node.toMap());
      } else {
        // Fallback: auto-generate ID if none provided
        await ref.add(node.toMap());
      }
      print("Decision saved successfully to Firestore.");
    } catch (e) {
      print("Error saving decision to Firestore: $e");
      rethrow;
    }
  }

  /// Updates an existing decision node in Firestore
  Future<void> updateDecision(DecisionNode node) async {
    final ref = _userDecisionsRef;
    if (ref == null || node.id == null || node.id!.isEmpty) {
      print("Error: Cannot update decision. No user signed in or node ID missing.");
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

  /// Deletes a specific decision node from Firestore
  Future<void> deleteDecision(String id) async {
    final ref = _userDecisionsRef;
    if (ref == null || id.isEmpty) {
      print("Error: Cannot delete decision. No user signed in or node ID missing.");
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

  /// 获取当前用户的所有决策节点的数据流 (按时间倒序排列)
  /// Gets a real-time stream of all DecisionNodes for the current user, ordered by timestamp descending.
  Stream<List<DecisionNode>> getDecisionsStream() {
    final ref = _userDecisionsRef;
    if (ref == null) {
      return Stream.value([]); // 如果没有登录，返回空流
    }

    // 监听数据库变化，按时间戳降序（最新的在前）排列
    return ref
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return DecisionNode.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  /// 删除当前用户的所有决策数据 (配合"一键销毁账号"使用)
  /// Deletes all decision data for the current user.
  Future<void> deleteAllUserData() async {
    final ref = _userDecisionsRef;
    if (ref == null) return;

    try {
      // 1. 获取用户所有的 decisions 文档
      final snapshots = await ref.get();
      
      // 2. 使用 WriteBatch 批量删除，提高效率并保证原子性
      final batch = _db.batch();
      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      
      // 3. (可选) 删除 users 集合下的用户主文档
      await _db.collection('users').doc(_uid).delete();
      
      print("All user data deleted from Firestore successfully.");
    } catch (e) {
      print("Error deleting user data: $e");
    }
  }
}
