import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../bloc/layout_cubit.dart';
import '../bloc/photo_cubit.dart';
import '../bloc/collage_cubit.dart';
import '../models/collage_models.dart' as models;
import 'editor_screen.dart';

class LayoutPickerScreen extends StatelessWidget {
  const LayoutPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final layouts = [
      models.Layout(
        type: 'grid2x2',
        positions: [
          Offset(0, 0),
          Offset(0.5, 0),
          Offset(0, 0.5),
          Offset(0.5, 0.5),
        ],
      ),
      models.Layout(
        type: 'panorama',
        positions: [Offset(0, 0), Offset(0.5, 0)],
      ),
      models.Layout(
        type: 'vertical',
        positions: [Offset(0, 0), Offset(0, 0.5)],
      ),
      models.Layout(
        type: 'triangle',
        positions: [Offset(0, 0), Offset(0.5, 0), Offset(0.25, 0.5)],
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Choose Layout')),
      body: CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * 0.8,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
        ),
        items: layouts.map((layout) {
          return Builder(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: () => context.read<LayoutCubit>().selectLayout(layout),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: context.watch<LayoutCubit>().state == layout
                        ? Colors.blue[200]
                        : Colors.grey[200],
                  ),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Stack(
                              children: layout.positions.asMap().entries.map((
                                entry,
                              ) {
                                final index = entry.key;
                                final position = entry.value;
                                return Positioned(
                                  left: position.dx * constraints.maxWidth,
                                  top: position.dy * constraints.maxHeight,
                                  width: layout.type == 'panorama'
                                      ? constraints.maxWidth / 2
                                      : constraints.maxWidth / 2 - 4,
                                  height: layout.type == 'vertical'
                                      ? constraints.maxHeight / 2 - 4
                                      : constraints.maxHeight / 2 - 4,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.primaries[index %
                                              Colors.primaries.length],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final selectedLayout = context.read<LayoutCubit>().state;
          if (selectedLayout != null) {
            final photos = context
                .read<PhotoCubit>()
                .state
                .selected
                .map(
                  (e) =>
                      models.Photo(asset: e, width: e.width, height: e.height),
                )
                .toList();
            context.read<CollageCubit>().createCollage(photos, selectedLayout);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditorScreen()),
            );
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }
}
