import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/trending_cubit.dart';

class TemplatesScreen extends StatelessWidget {
  const TemplatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TrendingCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Trendings'), centerTitle: true),
        body: BlocBuilder<TrendingCubit, TrendingState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: state.templates.length,
              itemBuilder: (context, index) {
                final template = state.templates[index];
                return _buildTrendingTemplate(
                  context,
                  template,
                  state.favorites,
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTrendingTemplate(
    BuildContext context,
    TrendingTemplate template,
    List<int> favorites,
  ) {
    final isFavorite = favorites.contains(template.id);

    return GestureDetector(
      onTap: () => _navigateToEditor(context, template.aspectRatio),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getTrendingIcon(template.category),
                  size: 48,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 8),
                Text(
                  template.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  template.category,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.grey,
                ),
                onPressed: () =>
                    context.read<TrendingCubit>().toggleFavorite(template.id),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getTrendingIcon(String category) {
    switch (category) {
      case 'Minimal':
        return Icons.remove_circle_outline;
      case 'Film':
        return Icons.movie;
      case 'Polaroid':
        return Icons.photo_camera;
      case 'Paper':
        return Icons.description;
      case 'Plastic':
        return Icons.widgets;
      case 'Marketing':
        return Icons.campaign;
      case 'Coach':
        return Icons.sports;
      default:
        return Icons.trending_up;
    }
  }

  void _navigateToEditor(BuildContext context, double aspectRatio) {
    Navigator.pushNamed(
      context,
      '/editor',
      arguments: {'aspectRatio': aspectRatio},
    );
  }
}
