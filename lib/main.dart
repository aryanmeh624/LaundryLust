import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'intro_page.dart';
import 'cleanliness_page.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), 'laundry_database.db'),
    onCreate: (db, version){
      return db.execute(
        'CREATE TABLE laundryData(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)'
      );
    },
    version: 1,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasSeenIntro = prefs.getBool('hasSeenIntro') ?? false;
  bool hasSetCleanliness = prefs.getBool('hasSetCleanliness') ?? false;

  Widget defaultHome;
  if (!hasSeenIntro) {
    defaultHome = IntroPage();
  } else if (!hasSetCleanliness) {
    defaultHome = IntroPage();
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
