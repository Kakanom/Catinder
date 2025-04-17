import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'di/setup.dart';
import 'presentation/blocs/cat_bloc.dart';
import 'presentation/blocs/cat_state.dart';
import 'presentation/screens/home_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  setupDependencies();
  runApp(const CatinderApp());
}

class CatinderApp extends StatelessWidget {
  const CatinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CatBloc>(),
      child: BlocBuilder<CatBloc, CatState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Catinder PRO',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.dark,
            ),
            themeMode: state.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
