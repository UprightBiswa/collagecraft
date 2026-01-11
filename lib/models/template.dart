import 'package:objectbox/objectbox.dart';

@Entity()
class Template {
  @Id()
  int id = 0;

  String name;
  String? previewImage;
  String aspectRatio; // e.g., "16:9", "4:5", "1:1"
  String positionsJson; // JSON string of List<Offset>

  Template({
    required this.name,
    this.previewImage,
    required this.aspectRatio,
    required this.positionsJson,
  });
}
