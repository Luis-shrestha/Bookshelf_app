import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shelf/supports/FavoriteManage/favorite_manager.dart';
import 'package:shelf/theme/themeBloc/theme_bloc.dart';
import 'package:shelf/theme/themeData.dart';
import 'userScreen/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // BlocProvider for Theme
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
        // Provider for FavoriteManager
        ChangeNotifierProvider(
          create: (context) => FavoriteManager(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'BookShelf',
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: lightTheme,
            themeMode: themeState,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
