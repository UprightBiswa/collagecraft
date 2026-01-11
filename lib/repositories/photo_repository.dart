import 'package:photo_manager/photo_manager.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotoRepository {
  Future<List<AssetEntity>> loadPhotos() async {
    // Request permission first
    print('Requesting permission with permission_handler...');
    final status = await Permission.photos.request();
    print('Permission status: $status');
    if (!status.isGranted) {
      throw Exception(
        'Permission denied. Please grant photo access in settings.',
      );
    }

    // Try to get asset paths
    print('Getting asset paths...');
    final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList();
    print('Found ${paths.length} asset paths');

    if (paths.isNotEmpty) {
      final AssetPathEntity path = paths.first;
      print('Using path: ${path.name}');
      final List<AssetEntity> entities = await path.getAssetListPaged(
        page: 0,
        size: 60,
      );
      print('Loaded ${entities.length} photos');
      return entities;
    }
    print('No asset paths found');
    return []; // No albums found
  }
}
