import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cleanliness_page.dart';
import 'cloth_data/get_clothes.dart';
import 'global.dart' as globals;
import 'add_clothes.dart';
import 'flashcard.dart'; // Import flashcard.dart
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
      var laundryDataList = await laundryGet(); // Get the list of dictionaries
      setState(() {
        _flashcards = laundryDataList.map((data) {
          return pog.laundryData(
            name: data.name,
            lastWorn: data.lastWorn,
            dirty: data.dirty,
            id: data.id,
            pic: data.pic,
          );
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle the error as needed
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
          : ListView.builder(
        itemCount: _flashcards.length,
        itemBuilder: (context, index) {
          var flashcard = _flashcards[index];
          return Card(
            child: ListTile(
              title: Text(flashcard.name),
              subtitle: Text(
                'Last Worn: ${flashcard.lastWorn} days ago\n'
                    'Dirty Level: ${flashcard.dirty}',
              ),
              leading: Image.memory(flashcard.pic), // Display the image
            ),
          );
        },
      ),
      floatingActionButton: _AnimatedFloatingActionButton(
        animation: _animation,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddClothes()),
          );
        },
      ),
    );
  }
}

class _AnimatedFloatingActionButton extends StatelessWidget {
  final Animation<double> animation;
  final VoidCallback onPressed;

  _AnimatedFloatingActionButton({
    required this.animation,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: animation.value,
          child: FloatingActionButton(
            onPressed: onPressed,
            backgroundColor: Colors.blue,
            child: Icon(Icons.add),
            tooltip: 'Add Clothes',
          ),
        );
      },
    );
  }
}
