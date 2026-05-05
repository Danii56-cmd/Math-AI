import 'package:hive/hive.dart';
import 'package:math_ai/models/hive_model.dart';

class DatabaseHelper {
  static const String boxName = "history_box";

  static Box<HistoryModel> getBox() => Hive.box<HistoryModel>(boxName);

  // SAVE
  static Future<void> saveHistory(HistoryModel model) async {
    await getBox().add(model);
  }

  // GET ALL (reversed, newest first)
  static List<HistoryModel> getHistory() {
    final box = getBox();
    return box.values.toList().reversed.toList();
  }

  // GET HIVE KEY for a reversed display index
  // Display index 0 = last inserted = box.length - 1 in actual box
  static dynamic getKeyAt(int displayIndex) {
    final box = getBox();
    final actualIndex = box.length - 1 - displayIndex;
    return box.keyAt(actualIndex);
  }

  // DELETE by Hive key (not positional index)
  static Future<void> deleteHistory(dynamic key) async {
    await getBox().delete(key);
  }

  // CLEAR
  static Future<void> clearHistory() async {
    await getBox().clear();
  }
}
