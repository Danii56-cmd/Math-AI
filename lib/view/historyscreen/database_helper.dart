import 'package:hive/hive.dart';
import 'package:math_ai/models/hive_model.dart';

class DatabaseHelper {
  static const String boxName = "history_box";

  static Box<HistoryModel> getBox() {
    return Hive.box<HistoryModel>(boxName);
  }

  // ================= SAVE =================
  static Future<void> saveHistory(HistoryModel model) async {
    final box = getBox();
    await box.add(model);
  }

  // ================= GET ALL =================
  static List<HistoryModel> getHistory() {
    final box = getBox();
    return box.values.toList().reversed.toList();
  }

  // ================= DELETE =================
  static Future<void> deleteHistory(int index) async {
    final box = getBox();
    await box.deleteAt(index);
  }

  // ================= CLEAR =================
  static Future<void> clearHistory() async {
    final box = getBox();
    await box.clear();
  }
}
