import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> saveHistory({
    required String question,
    required String solution,
    required String category,
    required String type,
    List<dynamic>? steps,
  }) async {
    try {
      await _firestore.collection("history").add({
        "question": question,
        "solution": solution,
        "category": category,
        "type": type,
        "steps": steps ?? [],
        "searchText": question.toLowerCase(), // 🔥 ADD THIS
        "timestamp": FieldValue.serverTimestamp(),
      });

      print("✅ Saved to Firestore");
    } catch (e) {
      print("❌ Firestore Error: $e");
    }
  }

  static Stream<QuerySnapshot> getHistory() {
    return _firestore
        .collection("history")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}
