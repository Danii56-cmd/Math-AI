import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:math_ai/main.dart';
import 'package:math_ai/models/hive_model.dart';
import 'package:math_ai/provider/theme_provider.dart';

void main() {
  setUpAll(() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HistoryModelAdapter());
    await Hive.openBox<HistoryModel>('history_box');
  });

  tearDownAll(() async {
    await Hive.close();
  });

  testWidgets('App launches without crashing', (WidgetTester tester) async {
    final themeProvider = ThemeChangerProvider();
    await themeProvider.loadThemeFromPrefs();

    await tester.pumpWidget(MyApp(themeProvider: themeProvider));
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  test('ThemeChangerProvider defaults to light mode', () async {
    final themeProvider = ThemeChangerProvider();
    await themeProvider.loadThemeFromPrefs();

    expect(themeProvider.themeMode, ThemeMode.light);
  });

  test('ThemeChangerProvider switches to dark mode', () async {
    final themeProvider = ThemeChangerProvider();
    await themeProvider.setThemeMode(ThemeMode.dark);

    expect(themeProvider.themeMode, ThemeMode.dark);
  });

  test('ThemeChangerProvider resets to light on logout', () async {
    final themeProvider = ThemeChangerProvider();
    await themeProvider.setThemeMode(ThemeMode.dark);
    await themeProvider.resetToLight();

    expect(themeProvider.themeMode, ThemeMode.light);
  });
}
