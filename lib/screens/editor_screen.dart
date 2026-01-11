import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:extended_image/extended_image.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import '../bloc/collage_cubit.dart';
import '../models/collage_models.dart';

class EditorScreen extends StatelessWidget {
  const EditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Collage')),
      body: BlocBuilder<CollageCubit, Collage?>(
        builder: (context, collage) {
          if (collage == null) return const Center(child: Text('No collage'));
          const double canvasWidth = 1000;
          const double canvasHeight = 500;
          return Center(
            child: AspectRatio(
              aspectRatio: canvasWidth / canvasHeight,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Stack(
                  children: collage.photos.asMap().entries.map((entry) {
                    final index = entry.key;
                    final photo = entry.value;
                    final position = collage.photoPositions[index];
                    final photoSize = collage.photoSizes[index];
                    return Positioned(
                      left: position.dx * canvasWidth,
                      top: position.dy * canvasHeight,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onPanUpdate: (details) {
                              final newDx =
                                  (position.dx + details.delta.dx / canvasWidth)
                                      .clamp(
                                        0.0,
                                        1.0 - photoSize.width / canvasWidth,
                                      );
                              final newDy =
                                  (position.dy +
                                          details.delta.dy / canvasHeight)
                                      .clamp(
                                        0.0,
                                        1.0 - photoSize.height / canvasHeight,
                                      );
                              context.read<CollageCubit>().updatePhotoPosition(
                                index,
                                Offset(newDx, newDy),
                              );
                            },
                            child: FutureBuilder<File?>(
                              future: photo.asset.originFile,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.data != null) {
                                  return ExtendedImage.file(
                                    snapshot.data!,
                                    width: photoSize.width,
                                    height: photoSize.height,
                                    fit: BoxFit.cover,
                                  );
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onPanUpdate: (details) {
                                final newWidth =
                                    (photoSize.width + details.delta.dx).clamp(
                                      50.0,
                                      canvasWidth,
                                    );
                                final newHeight =
                                    (photoSize.height + details.delta.dy).clamp(
                                      50.0,
                                      canvasHeight,
                                    );
                                context.read<CollageCubit>().updatePhotoSize(
                                  index,
                                  Size(newWidth, newHeight),
                                );
                              },
                              child: Container(
                                width: 20,
                                height: 20,
                                color: Colors.blue.withValues(alpha: 0.5),
                                child: const Icon(Icons.aspect_ratio, size: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final collage = context.read<CollageCubit>().state;
          if (collage == null) return;
          final images = <img.Image>[];
          for (final photo in collage.photos) {
            final file = await photo.asset.originFile;
            if (file != null) {
              final bytes = await file.readAsBytes();
              final image = img.decodeImage(bytes);
              if (image != null) images.add(image);
            }
          }
          if (images.isEmpty) return;
          img.Image canvas;
          if (collage.layout.type == 'panorama') {
            int totalWidth = 0;
            for (final image in images) {
              totalWidth += image.width;
            }
            canvas = img.Image(width: totalWidth, height: 500);
            int x = 0;
            for (final image in images) {
              img.compositeImage(canvas, image, dstX: x, dstY: 0);
              x += image.width;
            }
          } else {
            canvas = img.Image(width: 1000, height: 500);
            for (int i = 0; i < images.length; i++) {
              final image = images[i];
              final position = collage.photoPositions[i];
              final left = (position.dx * 1000).toInt();
              final top = (position.dy * 500).toInt();
              img.compositeImage(canvas, image, dstX: left, dstY: top);
            }
          }
          final directory = await getApplicationDocumentsDirectory();
          final path = '${directory.path}/collage.png';
          final png = img.encodePng(canvas);
          final file = File(path);
          await file.writeAsBytes(png);
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Saved to $path')));
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
