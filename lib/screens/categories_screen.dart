import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> categories = [
    'Minimal',
    'Film',
    'Polaroid',
    'Paper',
    'Plastic',
    'Marketing',
    'Coach',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAspectRatioMenu() {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset offset = button.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + button.size.height,
        offset.dx + button.size.width,
        offset.dy + button.size.height,
      ),
      items: [
        _buildPopupMenuItem('16:9', 16 / 9),
        _buildPopupMenuItem('4:5', 4 / 5),
        _buildPopupMenuItem('1:1', 1 / 1),
      ],
    );
  }

  PopupMenuItem<double> _buildPopupMenuItem(String label, double ratio) {
    return PopupMenuItem<double>(
      value: ratio,
      child: Text(label),
      onTap: () => _navigateToEditor(ratio),
    );
  }

  void _navigateToEditor(double aspectRatio) {
    // Navigate to editor with aspect ratio
    Navigator.pushNamed(
      context,
      '/editor',
      arguments: {'aspectRatio': aspectRatio},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Open settings
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: categories.map((category) => Tab(text: category)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: categories
            .map((category) => _buildCategoryContent(category))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAspectRatioMenu,
        child: const Icon(Icons.aspect_ratio),
      ),
    );
  }

  Widget _buildCategoryContent(String category) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: 6, // Placeholder for templates
      itemBuilder: (context, index) {
        return _buildTemplateContainer(category, index);
      },
    );
  }

  Widget _buildTemplateContainer(String category, int index) {
    return GestureDetector(
      onTap: () => _navigateToEditor(1.0), // Default 1:1 for templates
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getCategoryIcon(category),
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              '$category Template ${index + 1}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
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
        return Icons.image;
    }
  }
}
