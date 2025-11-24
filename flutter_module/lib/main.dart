import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_module/app_config.dart';
import 'package:flutter_module/features/items_list/presentation/pages/list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.light;
  String theme = 'no theme';
  static const platform = MethodChannel("app/payment");
  static const navChannel = MethodChannel("com.example.app/navChannel");
  static const payChannel = MethodChannel("com.example.app/payChannel");
  Future<void> loadTheme() async {
    if (Platform.isAndroid) {
      try {
        final data = await platform.invokeMethod("getLoginData");

        setState(() {
          theme = data["theme"] ?? "no theme";
          themeMode = theme == "dark" ? ThemeMode.dark : ThemeMode.light;
        });
      } catch (e) {
        print("Error loading theme: $e");
      }
    } else if (Platform.isIOS) {
      navChannel.setMethodCallHandler((call) async {
        if (call.method == "loginData") {
          final data = Map<String, dynamic>.from(call.arguments);

          setState(() {
            theme = data["theme"] ?? "no theme";
            themeMode = theme == "dark" ? ThemeMode.dark : ThemeMode.light;
          });
        }
      });
    }
  }

  @override
  void initState() {
    loadTheme();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: themeMode,

      // 🌞 LIGHT THEME
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),

      // 🌙 DARK THEME
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),

      home: ListScreen(
        title: "Products List",
        config: AppConfig(),
      ),
    );
  }
}
