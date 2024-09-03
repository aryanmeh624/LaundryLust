import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cleanliness_page.dart';
import 'cloth_data/get_clothes.dart';
import 'global.dart' as globals;
import 'add_clothes.dart';
import 'flashcard.dart'; // Import flashcard.dart
import 'dart:io';
import 'cloth_data/main_DB.dart' as pog; // Import your main DB class
import 'cloth_data/main_DB.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  List<pog.laundryData> _flashcards = [];
  bool _isLoading = true;

  Future<void> _getCleanlinessLevel() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      globals.cleanlinessLevel = prefs.getInt('cleanlinessLevel') ?? 0;
    });
  }

  Future<void> _loadData() async {
    try {
      // Fetch the list of laundry data from the database
      var laundryDataList = await laundryGet();

      // Debugging: Print the fetched list to ensure it contains all rows
      print('Fetched laundry data: $laundryDataList');

      // Clear the current flashcards list before repopulating it
      setState(() {
        _flashcards.clear(); // Clear the list to avoid duplicates
        for (var data in laundryDataList) {
          _flashcards.add(pog.laundryData(
            name: data.name,
            lastWorn: data.lastWorn,
            dirty: data.dirty,
            id: data.id,
            pic: data.pic,
          ));
        }

        // Debugging: Print the flashcards list to ensure all rows are added
        print('Mapped flashcards: $_flashcards');

        _isLoading = false; // Set loading to false once data is loaded
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Optionally, handle errors here
      print('Error loading data: $e');
    }
  }
  @override
  void initState() {
    super.initState();
    _getCleanlinessLevel();
    _loadData(); // Load data when the widget is initialized

    // Initialize the animation controller and animation
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
//hhj
  @override
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          for (var flashcard in _flashcards)
            InkWell(
              onTap: () {
                print('Tapped on ${flashcard.name}');
              },
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: flashcard.pic != null && flashcard.pic.isNotEmpty
                        ? Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: FileImage(File(flashcard.pic)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                        : Icon(Icons.image_not_supported),
                    title: Text(flashcard.name),
                    subtitle: Text(
                      'Last Worn: ${flashcard.lastWorn} minutes ago\n'
                          'Dirty: ${flashcard.dirty}',
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddClothes()),
          );
          _loadData();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
