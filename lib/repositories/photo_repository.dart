import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoRepository {
  Future<List<AssetEntity>> loadPhotos() async {
    // Request permission first
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      throw Exception(
        'Permission denied. Please grant photo access in settings.',
      );
    }

    // Try to get asset paths
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList();

    if (paths.isNotEmpty) {
      final AssetPathEntity path = paths.first;
      final List<AssetEntity> entities = await path.getAssetListPaged(
        page: 0,
        size: 60,
      );
      return entities;
    }
    return []; // No albums found
  }
}
