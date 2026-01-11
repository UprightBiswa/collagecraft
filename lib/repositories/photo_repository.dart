import 'package:photo_manager/photo_manager.dart';

class PhotoRepository {
  Future<List<AssetEntity>> loadPhotos() async {
    // Let PhotoManager handle permissions
    print('Requesting permission...');
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    print('PermissionState: isAuth=${ps.isAuth}, hasAccess=${ps.hasAccess}');

    if (ps.isAuth) {
      print('Permission granted, getting asset paths...');
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
    print('Permission denied by PhotoManager');
    throw Exception(
      'Permission denied. Please grant photo access in settings.',
    );
  }
}
