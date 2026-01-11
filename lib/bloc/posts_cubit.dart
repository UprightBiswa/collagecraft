import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Model for posts
class PostItem {
  final int id;
  final String title;
  final String date;
  final IconData icon;

  const PostItem({
    required this.id,
    required this.title,
    required this.date,
    required this.icon,
  });
}

// State
class PostsState {
  final List<PostItem> savedPosts;
  final List<PostItem> favoritePosts;

  const PostsState({this.savedPosts = const [], this.favoritePosts = const []});

  PostsState copyWith({
    List<PostItem>? savedPosts,
    List<PostItem>? favoritePosts,
  }) {
    return PostsState(
      savedPosts: savedPosts ?? this.savedPosts,
      favoritePosts: favoritePosts ?? this.favoritePosts,
    );
  }
}

// Cubit
class PostsCubit extends Cubit<PostsState> {
  PostsCubit() : super(const PostsState()) {
    loadSampleData();
  }

  void loadSampleData() {
    // Sample saved posts
    final savedPosts = [
      const PostItem(
        id: 1,
        title: 'Summer Memories',
        date: '2 days ago',
        icon: Icons.beach_access,
      ),
      const PostItem(
        id: 2,
        title: 'Family Gathering',
        date: '1 week ago',
        icon: Icons.family_restroom,
      ),
      const PostItem(
        id: 3,
        title: 'Travel Adventure',
        date: '2 weeks ago',
        icon: Icons.flight,
      ),
      const PostItem(
        id: 4,
        title: 'Birthday Party',
        date: '1 month ago',
        icon: Icons.cake,
      ),
    ];

    // Sample favorite posts
    final favoritePosts = [
      const PostItem(
        id: 5,
        title: 'Nature Walk',
        date: '3 days ago',
        icon: Icons.forest,
      ),
      const PostItem(
        id: 6,
        title: 'City Lights',
        date: '5 days ago',
        icon: Icons.location_city,
      ),
      const PostItem(
        id: 7,
        title: 'Pet Love',
        date: '1 week ago',
        icon: Icons.pets,
      ),
    ];

    emit(state.copyWith(savedPosts: savedPosts, favoritePosts: favoritePosts));
  }

  void toggleFavorite(int postId) {
    final currentFavorites = List<PostItem>.from(state.favoritePosts);
    final savedPosts = List<PostItem>.from(state.savedPosts);

    // Find the post in saved posts
    final post = savedPosts.firstWhere((p) => p.id == postId);
    final isAlreadyFavorite = currentFavorites.any((p) => p.id == postId);

    if (isAlreadyFavorite) {
      currentFavorites.removeWhere((p) => p.id == postId);
    } else {
      currentFavorites.add(post);
    }

    emit(state.copyWith(favoritePosts: currentFavorites));
  }

  void removePost(int postId, bool fromSaved) {
    if (fromSaved) {
      final updatedSaved = state.savedPosts
          .where((p) => p.id != postId)
          .toList();
      emit(state.copyWith(savedPosts: updatedSaved));
    } else {
      final updatedFavorites = state.favoritePosts
          .where((p) => p.id != postId)
          .toList();
      emit(state.copyWith(favoritePosts: updatedFavorites));
    }
  }
}
