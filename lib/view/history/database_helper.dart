import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── get current user's history collection ──
  static CollectionReference _historyCollection() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return _firestore.collection("users").doc(uid).collection("history");
  }

  static Future<void> saveHistory({
    required String question,
    required String solution,
    required String category,
    required String type,
    List<dynamic>? steps,
  }) async {
    try {
      await _historyCollection().add({
        "question": question,
        "solution": solution,
        "category": category,
        "type": type,
        "steps": steps ?? [],
        "searchText": question.toLowerCase(),
        "createdAt": FieldValue.serverTimestamp(),
      });
      print("✅ Saved to Firestore");
    } catch (e) {
      print("❌ Firestore Error: $e");
    }
  }

  static Stream<QuerySnapshot> getHistory() {
    return _historyCollection()
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  static Future<void> deleteHistory(String itemId) async {
    try {
      await _historyCollection().doc(itemId).delete();
      print("✅ Deleted from Firestore");
    } catch (e) {
      print("❌ Firestore Error: $e");
    }
  }
}
