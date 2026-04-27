import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:math_ai/core/theme.dart';
import 'package:math_ai/provider/aichat_provider.dart';
import 'package:math_ai/provider/calculator_provider.dart';
import 'package:math_ai/provider/course_provider.dart';
import 'package:math_ai/provider/history_provider.dart';
import 'package:math_ai/provider/homescreen_provider.dart';
import 'package:math_ai/provider/navigation_provider.dart';
import 'package:math_ai/provider/profile_provider.dart';
import 'package:math_ai/view/Aichatbotbotscreen/Aichatbot_screen.dart';
import 'package:math_ai/view/probleminput_screen.dart/calculator_screen.dart';
import 'package:provider/provider.dart';
import 'package:math_ai/shared_widgets/main_screen.dart';
import 'package:math_ai/view/home/home_screen.dart';
import 'package:math_ai/view/scanner/camera_screen.dart';
import 'package:math_ai/view/splashscreen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        ChangeNotifierProvider(create: (_) => AiChatProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => CalculatorProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: Provider.of<ThemeChangerProvider>(context).themeMode,
            debugShowCheckedModeBanner: false,
            initialRoute: "/",
            routes: {
              "/": (context) => const SplashScreen(),
              "/home": (context) => const HomeScreen(),
              "/main_screen": (context) => const MainScreen(),
              "/camera_screen": (context) => const CameraScreen(),
              "/aichatbot_screen": (context) => const AichatbotScreen(),
              "/calculator_screen": (context) => const CalculatorScreen(),
              // "/solver_screen": (context) => const SolverScreen(imageFile: imageFile),
            },
          );
        },
      ),
    );
  }
}
