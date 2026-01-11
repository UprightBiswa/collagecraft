import 'dart:ui';
import 'package:photo_manager/photo_manager.dart';

class Photo {
  final AssetEntity asset;
  final int width;
  final int height;

  Photo({required this.asset, required this.width, required this.height});
}

class Layout {
  final String type; // e.g., 'grid', 'panorama'
  final List<Offset> positions;

  Layout({required this.type, required this.positions});
}

class Collage {
  final List<Photo> photos;
  final Layout layout;
  final List<Offset> photoPositions;
  final List<Size> photoSizes;
  final Map<String, dynamic> edits; // for transformations

  Collage({
    required this.photos,
    required this.layout,
    required this.photoPositions,
    required this.photoSizes,
    required this.edits,
  });
}
