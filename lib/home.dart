import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cleanliness_page.dart';
import 'global.dart' as globals;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CleanlinessPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Text(

          'Your cleanliness level is: ${globals.cleanlinessLevel}',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
