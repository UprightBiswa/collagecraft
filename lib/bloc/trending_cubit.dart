import 'package:flutter_bloc/flutter_bloc.dart';

// Model for trending templates
class TrendingTemplate {
  final int id;
  final String name;
  final String category;
  final double aspectRatio;

  const TrendingTemplate({
    required this.id,
    required this.name,
    required this.category,
    required this.aspectRatio,
  });
}

// State
class TrendingState {
  final bool isLoading;
  final List<TrendingTemplate> templates;
  final List<int> favorites;

  const TrendingState({
    this.isLoading = false,
    this.templates = const [],
    this.favorites = const [],
  });

  TrendingState copyWith({
    bool? isLoading,
    List<TrendingTemplate>? templates,
    List<int>? favorites,
  }) {
    return TrendingState(
      isLoading: isLoading ?? this.isLoading,
      templates: templates ?? this.templates,
      favorites: favorites ?? this.favorites,
    );
  }
}

// Cubit
class TrendingCubit extends Cubit<TrendingState> {
  TrendingCubit() : super(const TrendingState()) {
    loadTrendingTemplates();
  }

  void loadTrendingTemplates() {
    emit(state.copyWith(isLoading: true));

    // Simulate API call with sample data
    final sampleTemplates = [
      const TrendingTemplate(
        id: 1,
        name: 'Summer Vibes',
        category: 'Film',
        aspectRatio: 1.0,
      ),
      const TrendingTemplate(
        id: 2,
        name: 'Minimal Art',
        category: 'Minimal',
        aspectRatio: 1.0,
      ),
      const TrendingTemplate(
        id: 3,
        name: 'Polaroid Love',
        category: 'Polaroid',
        aspectRatio: 0.8,
      ),
      const TrendingTemplate(
        id: 4,
        name: 'Business Card',
        category: 'Marketing',
        aspectRatio: 1.6,
      ),
      const TrendingTemplate(
        id: 5,
        name: 'Nature Scene',
        category: 'Paper',
        aspectRatio: 1.3,
      ),
      const TrendingTemplate(
        id: 6,
        name: 'Sports Action',
        category: 'Coach',
        aspectRatio: 1.9,
      ),
      const TrendingTemplate(
        id: 7,
        name: 'Tech Modern',
        category: 'Plastic',
        aspectRatio: 1.0,
      ),
      const TrendingTemplate(
        id: 8,
        name: 'Wedding Bliss',
        category: 'Film',
        aspectRatio: 0.67,
      ),
    ];

    emit(state.copyWith(isLoading: false, templates: sampleTemplates));
  }

  void toggleFavorite(int templateId) {
    final currentFavorites = List<int>.from(state.favorites);
    if (currentFavorites.contains(templateId)) {
      currentFavorites.remove(templateId);
    } else {
      currentFavorites.add(templateId);
    }
    emit(state.copyWith(favorites: currentFavorites));
  }
}
