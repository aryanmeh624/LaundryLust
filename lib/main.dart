import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'intro_page.dart';
import 'cleanliness_page.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
  bool hasSetCleanliness = prefs.getBool('hasSetCleanliness') ?? false;

  Widget defaultHome;
  if (!hasSeenIntro) {
    defaultHome = IntroPage();
  } else if (!hasSetCleanliness) {
    defaultHome = Home();
  } else {
    defaultHome = Home();
  }

  runApp(MyApp(defaultHome: defaultHome));
}

class MyApp extends StatelessWidget {
  final Widget defaultHome;

  MyApp({required this.defaultHome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stay Clean App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: defaultHome,
    );
  }
}
