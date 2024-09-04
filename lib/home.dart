import 'dart:async';
import 'package:flutter/material.dart';
import 'package:laundry_lust/levelSelectionPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cleanliness_page.dart';
import 'cloth_data/get_clothes.dart';
import 'global.dart' as globals;
import 'add_clothes.dart';
import 'flashcard.dart';
import 'dart:io';
import 'cloth_data/main_DB.dart' as pog;
import 'cloth_data/main_DB.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'global.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late Timer _timer;
  late AnimationController _controller;
  late Animation<double> _animation;
  List<pog.laundryData> _flashcards = [];
  bool _isLoading = true;
  List<int> _selectedIndices = []; // Track selected flashcards

  Future<void> _getCleanlinessLevel() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      globals.cleanlinessLevel = prefs.getInt('cleanlinessLevel') ?? 0;
    });
  }

  // Calculate the time difference between the last worn time and the current time
  String _calculateTimeDifference(int lastWorn) {
    DateTime lastWornTime = DateTime.fromMillisecondsSinceEpoch(lastWorn);
    Duration difference = DateTime.now().difference(lastWornTime);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
  Future<void> _loadData() async {
    try {
      // Fetch the list of laundry data from the database
      var laundryDataList = await laundryGet();
      // Debugging: Print the fetched list to ensure it contains all rows
      print('Fetched laundry data: $laundryDataList');
      // Clear the current flashcards list before repopulating it
      setState(() {
        _flashcards.clear();// Clear the list to avoid duplicates
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
        _isLoading = false;// Set loading to false once data is loaded
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Optionally, handle errors here
      print('Error loading data: $e');
    }
  }


  void _editSelectedFlashcard(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LevelSelectionPage(laundryItem: _flashcards[index]),
      ),
    ).then((_) {
      _selectedIndices.clear();
      _loadData();
    });
  }

  @override
  void initState() {
    super.initState();
    _getCleanlinessLevel();
    _loadData();

    // Setup a periodic timer to refresh the flashcards every 60 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _loadData();  // Refresh the data
      setState(() {});  // Rebuild the UI to reflect updated times
    });
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
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _deselectAll() {
    setState(() {
      _selectedIndices.clear();
    });
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          if (_selectedIndices.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: null,
            ),
        ],
      ),
      body: GestureDetector(
        onTap: _selectedIndices.isNotEmpty ? _deselectAll : null,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: _flashcards.length,
          itemBuilder: (context, index) {
            int data;
            return GestureDetector(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                globals.cleanlinessLevel = prefs.getInt('cleanlinessLevel')!.toInt();
                if (_selectedIndices.isNotEmpty) {
                  _toggleSelection(index);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LevelSelectionPage(laundryItem: _flashcards[index]),
                    ),
                  );
                }
              },
              onLongPress: () {
                _toggleSelection(index);
              },
              child: Card(


                color: _selectedIndices.contains(index) ? Colors.blue.shade100 : _flashcards[index].dirty>3*(12-globals.cleanlinessLevel)?const Color(0xFFEF5350):null,
                surfaceTintColor: _flashcards[index].dirty > 0 && _flashcards[index].dirty < (12 - globals.cleanlinessLevel)
                    ? Colors.yellow.shade700
                    : (_flashcards[index].dirty >= (12 - globals.cleanlinessLevel)
                    ? Colors.red.shade700
                    : Colors.transparent),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: _flashcards[index].pic != null && _flashcards[index].pic.isNotEmpty
                        ? Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: FileImage(File(_flashcards[index].pic)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                        : Icon(Icons.image_not_supported),
                    title: Text(_flashcards[index].name),
                    subtitle: Text(
                      'Last Worn: ${_calculateTimeDifference(_flashcards[index].lastWorn)}\n'
                          'Dirty: ${_flashcards[index].dirty}',
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: _selectedIndices.isNotEmpty
          ? FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Wrap(
                children: [
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                    onTap: () {
                      _editSelectedFlashcard(_selectedIndices.first);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.more_vert),
      )
          : FloatingActionButton(
        onPressed: () async{
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddClothes()),
          );
          // Check if a new flashcard was added, and reload data
          if (result == true) {
          _loadData(); // Reload the flashcard data when a new one is added
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}