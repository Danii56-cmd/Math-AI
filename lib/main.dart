import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/app_constants.dart';
import 'package:math_ai/core/theme.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:provider/provider.dart';
import 'package:math_ai/shared_widgets/main_screen.dart';
import 'package:math_ai/view/home/home_screen.dart';
import 'package:math_ai/view/scanner/camera_screen.dart';
import 'package:math_ai/view/splashscreen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeChangerProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            theme: ThemeData(
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppConstants.primaryColor,
              ),
            ),

            darkTheme: ThemeData(
              brightness: Brightness.dark, // ✅ THIS IS THE KEY
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppConstants.primaryColor,
                brightness: Brightness.dark,
              ),
            ),
            themeMode: Provider.of<ThemeChangerProvider>(context).themeMode,
            debugShowCheckedModeBanner: false,
            initialRoute: "/",
            routes: {
              "/": (context) => const SplashScreen(),
              "/home": (context) => const HomeScreen(),
              "/main_screen": (context) => const MainScreen(),
              "/camera_screen": (context) => const CameraScreen(),
              // "/solver_screen": (context) => const SolverScreen(imageFile: imageFile),
            },
          );
        },
      ),
    );
  }
}
