import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cleanliness_page.dart';
import 'global.dart' as globals;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> _getCleanlinessLevel() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      globals.cleanlinessLevel = prefs.getInt('cleanlinessLevel') ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCleanlinessLevel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //...
      body: Center(
        child: Text(
          'Your cleanliness level is: ${globals.cleanlinessLevel}',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}