import 'package:hive/hive.dart';

part 'hive_model.g.dart';

@HiveType(typeId: 2)
class HistoryModel extends HiveObject {
  @HiveField(0)
  final String question;

  @HiveField(1)
  final String solution;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final List<dynamic> steps;

  @HiveField(5)
  final String searchText;

  @HiveField(6)
  final DateTime createdAt;

  HistoryModel({
    required this.question,
    required this.solution,
    required this.category,
    required this.type,
    required this.steps,
    required this.searchText,
    required this.createdAt,
  });
}
