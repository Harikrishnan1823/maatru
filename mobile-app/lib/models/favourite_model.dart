import 'package:hive_flutter/hive_flutter.dart';

part 'favourite_model.g.dart';

@HiveType(typeId: 0)
class FavouriteModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String originalText;

  @HiveField(2)
  String translatedText;

  @HiveField(3)
  String fromLanguage;

  @HiveField(4)
  String toLanguage;

  @HiveField(5)
  String scenario;

  @HiveField(6)
  DateTime savedAt;

  @HiveField(7)
  String? customName;

  FavouriteModel({
    required this.id,
    required this.originalText,
    required this.translatedText,
    required this.fromLanguage,
    required this.toLanguage,
    required this.scenario,
    required this.savedAt,
    this.customName,
  });
}