import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/photo_cubit.dart';
import 'bloc/layout_cubit.dart';
import 'bloc/collage_cubit.dart';
import 'repositories/photo_repository.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (_) => PhotoRepository())],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PhotoCubit(context.read<PhotoRepository>()),
          ),
          BlocProvider(create: (_) => LayoutCubit()),
          BlocProvider(create: (_) => CollageCubit()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CollageCraft',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
