import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/collage_models.dart';

class LayoutCubit extends Cubit<Layout?> {
  LayoutCubit() : super(null);

  void selectLayout(Layout layout) {
    emit(layout);
  }
}
