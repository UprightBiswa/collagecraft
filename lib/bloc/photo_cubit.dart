import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import '../repositories/photo_repository.dart';

class PhotoState {
  final bool loading;
  final List<AssetEntity> photos;
  final List<AssetEntity> selected;
  final String? error;

  PhotoState({
    this.loading = true,
    this.photos = const [],
    this.selected = const [],
    this.error,
  });

  PhotoState copyWith({
    bool? loading,
    List<AssetEntity>? photos,
    List<AssetEntity>? selected,
    String? error,
  }) {
    return PhotoState(
      loading: loading ?? this.loading,
      photos: photos ?? this.photos,
      selected: selected ?? this.selected,
      error: error ?? this.error,
    );
  }
}

class PhotoCubit extends Cubit<PhotoState> {
  final PhotoRepository _repository;

  PhotoCubit(this._repository) : super(PhotoState());

  Future<void> loadPhotos() async {
    try {
      final photos = await _repository.loadPhotos();
      emit(state.copyWith(loading: false, photos: photos));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void selectPhoto(AssetEntity photo) {
    final selected = List<AssetEntity>.from(state.selected);
    if (!selected.contains(photo)) {
      selected.add(photo);
      emit(state.copyWith(selected: selected));
    }
  }

  void removePhoto(AssetEntity photo) {
    final selected = List<AssetEntity>.from(state.selected);
    selected.remove(photo);
    emit(state.copyWith(selected: selected));
  }
}
