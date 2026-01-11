import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/collage_cubit.dart';
import 'repositories/photo_repository.dart';
import 'database/objectbox_manager.dart';
import 'screens/splash_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/editor_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize ObjectBox
  await ObjectBoxManager.instance;

  runApp(
    MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (_) => PhotoRepository())],
      child: BlocProvider(create: (_) => CollageCubit(), child: const MyApp()),
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
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const MainNavigationScreen(),
        '/editor': (context) => const EditorScreen(),
      },
    );
  }
}
