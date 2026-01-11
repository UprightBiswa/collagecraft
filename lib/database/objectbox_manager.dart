import '../models/template.dart';
import '../models/collage_model.dart';
import '../objectbox.g.dart';

class ObjectBoxManager {
  static ObjectBoxManager? _instance;
  late final Store _store;

  // Boxes
  late final Box<Template> _templateBox;
  late final Box<CollageModel> _collageBox;

  ObjectBoxManager._();

  static Future<ObjectBoxManager> get instance async {
    if (_instance != null) return _instance!;

    _instance = ObjectBoxManager._();
    await _instance!._init();
    return _instance!;
  }

  Future<void> _init() async {
    // Initialize store
    _store = await openStore();

    // Initialize boxes
    _templateBox = Box<Template>(_store);
    _collageBox = Box<CollageModel>(_store);
  }

  // Template operations
  Future<List<Template>> getAllTemplates() async {
    return _templateBox.getAll();
  }

  Future<Template?> getTemplate(int id) async {
    return _templateBox.get(id);
  }

  Future<int> saveTemplate(Template template) async {
    return _templateBox.put(template);
  }

  // Collage operations
  Future<List<CollageModel>> getAllCollages() async {
    return _collageBox.getAll();
  }

  Future<List<CollageModel>> getFavoriteCollages() async {
    return _collageBox
        .query(CollageModel_.isFavorite.equals(true))
        .build()
        .find();
  }

  Future<CollageModel?> getCollage(int id) async {
    return _collageBox.get(id);
  }

  Future<int> saveCollage(CollageModel collage) async {
    return _collageBox.put(collage);
  }

  Future<bool> deleteCollage(int id) async {
    return _collageBox.remove(id);
  }

  Future<void> close() async {
    _store.close();
  }
}
