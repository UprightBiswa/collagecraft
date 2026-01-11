import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/collage_models.dart';

class CollageCubit extends Cubit<Collage?> {
  CollageCubit() : super(null);

  void createCollage(List<Photo> photos, Layout layout) {
    final photoPositions = layout.positions;
    final photoSizes = List.generate(
      photos.length,
      (_) => const Size(100, 100),
    );
    final collage = Collage(
      photos: photos,
      layout: layout,
      photoPositions: photoPositions,
      photoSizes: photoSizes,
      edits: {},
    );
    emit(collage);
  }

  void updateEdits(Map<String, dynamic> edits) {
    if (state != null) {
      emit(
        Collage(
          photos: state!.photos,
          layout: state!.layout,
          photoPositions: state!.photoPositions,
          photoSizes: state!.photoSizes,
          edits: edits,
        ),
      );
    }
  }

  void updatePhotoPosition(int index, Offset newPosition) {
    if (state != null) {
      final newPositions = List<Offset>.from(state!.photoPositions);
      newPositions[index] = newPosition;
      emit(
        Collage(
          photos: state!.photos,
          layout: state!.layout,
          photoPositions: newPositions,
          photoSizes: state!.photoSizes,
          edits: state!.edits,
        ),
      );
    }
  }

  void updatePhotoSize(int index, Size newSize) {
    if (state != null) {
      final newSizes = List<Size>.from(state!.photoSizes);
      newSizes[index] = newSize;
      emit(
        Collage(
          photos: state!.photos,
          layout: state!.layout,
          photoPositions: state!.photoPositions,
          photoSizes: newSizes,
          edits: state!.edits,
        ),
      );
    }
  }
}
