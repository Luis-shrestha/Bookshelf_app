import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shelf/theme/themeBloc/theme_bloc.dart';
import 'package:shelf/theme/themeData.dart';
import 'package:shelf/userScreen/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
// user view
class MyApp extends StatelessWidget with WidgetsBindingObserver{
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider( create: (context) => ThemeBloc(),),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, themeState){
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


// admin view

// class MyApp extends StatelessWidget with WidgetsBindingObserver{
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Admin Panel',
//       theme: ThemeData.dark().copyWith(
//         scaffoldBackgroundColor: bgColor,
//         textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
//             .apply(bodyColor: Colors.white),
//         canvasColor: secondaryColor,
//       ),
//       home: HomeView(),
//     );
//   }
// }

