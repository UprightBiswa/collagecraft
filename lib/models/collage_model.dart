import 'package:objectbox/objectbox.dart';

@Entity()
class CollageModel {
  @Id()
  int id = 0;

  int templateId;
  String photosJson; // JSON string of List<String> photo paths
  String editsJson; // JSON string of Map<String, dynamic>
  DateTime createdAt;
  bool isFavorite;

  CollageModel({
    required this.templateId,
    required this.photosJson,
    required this.editsJson,
    required this.createdAt,
    this.isFavorite = false,
  });
}
