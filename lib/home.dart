import 'dart:async';
import 'package:laundry_lust/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laundry_lust/levelSelectionPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cleanliness_page.dart'; // Import CleanlinessPage
import 'cloth_data/change_clothes.dart';
import 'cloth_data/get_clothes.dart';
import 'global.dart' as globals;
import 'add_clothes.dart';
import 'dart:io';
import 'cloth_data/main_DB.dart' as pog;
import 'cloth_data/main_DB.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global.dart';
import 'edit_page.dart';
import 'notification_service.dart'; // New Edit Page import

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

  // Function to check if all selected items have dirty == -1
  bool _allSelectedAreDrying() {
    return _selectedIndices.every((index) => _flashcards[index].dirty == -1);
  }

  Future<void> _deleteSelectedClothes() async {
    List<laundryData> selectedLaundry = _selectedIndices.map((index) => _flashcards[index]).toList();
    for (var laundry in selectedLaundry) {
      await deleteLaundryById(laundry.id);  // Call your database delete function
    }
    setState(() {
      _flashcards.removeWhere((item) => _selectedIndices.contains(_flashcards.indexOf(item)));
      _selectedIndices.clear();  // Clear selection after deleting
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected clothes deleted successfully!')),
    );
  }

  Future<void> _showDeleteConfirmationDialog() async {
    bool? confirmed = await deleteConfirmationDialog(context);
    if (confirmed == true) {
      _deleteSelectedClothes();  // If confirmed, delete the selected clothes
    }
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
      //print('Fetched laundry data: $laundryDataList');
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
        //print('Mapped flashcards: $_flashcards');
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



  void _editSelectedFlashcard(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPage(laundryItem: _flashcards[index]), // Navigate to EditPage
      ),
    ).then((_) {
      _selectedIndices.clear(); // Clear selections when coming back
      _loadData(); // Refresh data
    });
  }

  @override
  void initState() {
    super.initState();
    _getCleanlinessLevel();
    _loadData();

    // Setup a periodic timer to refresh the flashcards every 60 seconds
    _timer = Timer.periodic(Duration(milliseconds: 34), (timer) {
      _loadData(); // Refresh the data
      setState(() {}); // Rebuild the UI to reflect updated times
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

  void _confirmPickupSelectedClothes() async {
    bool? confirmed = await pickupConfirmationDialog(context);
    if (confirmed == true) {
      _pickupSelectedClothes(); // Call the washing function if confirmed
    }
  }

  void _pickupSelectedClothes() async {
    // Extract the selected laundry items based on _selectedIndices
    List<laundryData> selectedLaundry = _selectedIndices.map((index) => _flashcards[index]).toList();

    // Reset 'dirty' levels to 0 in both UI and database
    await pickupSelectedClothes(selectedLaundry);

    // Update the UI by setting the 'dirty' values to 0 and changing the color
    setState(() {
      for (int index in _selectedIndices) {
        _flashcards[index].dirty = 0; // Reset the 'dirty' level in memory
      }
      _selectedIndices.clear(); // Clear selections after washing
    });

    // Optionally, give some feedback to the user
    HapticFeedback.heavyImpact(); // Vibrate to indicate success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected clothes washed successfully!')),
    );
  }

  void _washSelectedClothes() async {
    // Extract the selected laundry items based on _selectedIndices
    List<laundryData> selectedLaundry = _selectedIndices.map((index) => _flashcards[index]).toList();

    // Reset 'dirty' levels to 0 in both UI and database
    await washSelectedClothes(selectedLaundry);

    // Update the UI by setting the 'dirty' values to 0 and changing the color
    setState(() {
      for (int index in _selectedIndices) {
        _flashcards[index].dirty = -1; // Reset the 'dirty' level in memory
      }
      _selectedIndices.clear(); // Clear selections after washing
    });

    // Optionally, give some feedback to the user
    HapticFeedback.heavyImpact(); // Vibrate to indicate success
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected clothes washed successfully!')),
    );
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
        HapticFeedback.lightImpact();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      if (_selectedIndices.isNotEmpty) {
        // If there are selected indices, deselect them and prevent back navigation
        setState(() {
          _selectedIndices.clear();
        });
        return false; // Prevents back navigation
      } else {
        return true; // Allows back navigation
      }
    },
    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Stay Clean!'),
        // backgroundColor: Colors.white,
        elevation: 1.0,
        actions: [

          // Show the delete button only if all selected items have dirty == -1
          if (_selectedIndices.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _showDeleteConfirmationDialog,  // Show confirmation dialog
            ),
          if(_selectedIndices.isNotEmpty && _allSelectedAreDrying())
            IconButton(
              icon: Icon(Icons.air),
              onPressed: _confirmPickupSelectedClothes,
            ),
          // Add Cleanliness Icon Button to AppBar
          IconButton(
            icon: Icon(Icons.clean_hands),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CleanlinessPage(), // Navigate to CleanlinessPage
                ),
              );
            },
          ),
          // if (_selectedIndices.length == 1) // Show only when one item is selected
          //   IconButton(
          //     icon: Icon(Icons.edit),
          //     onPressed: () {
          //       _editSelectedFlashcard(_selectedIndices.first); // Edit selected flashcard
          //     },
          //   ),
          // if (_selectedIndices.isNotEmpty)
          //   IconButton(
          //     icon: Icon(Icons.delete),
          //     onPressed: null, // Implement delete action if needed
          //   ),
        ],
      ),
      body: GestureDetector(
        // onTap: _selectedIndices.isNotEmpty ? _deselectAll : null,
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child:
                ListView.builder(

                  itemCount: _flashcards.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3.2),
                      child: GestureDetector(
                        onTap: () async {
                          // Check if the cloth is in drying state (dirty == -1)
                          if (_flashcards[index].dirty == -1) {
                            // Show pickup confirmation dialog
                            bool? confirmed = await pickupConfirmationDialog(context);
                            if (confirmed == true) {
                              List<laundryData> selectedLaundry = [_flashcards[index]]; // Single item in a list
                              await pickupSelectedClothes(selectedLaundry);  // Call wash function
                              // If user confirms, update the dirty value to 0
                              setState(() {
                                _flashcards[index].dirty = 0;  // Set dirty value to 0
                              });
                              // Optionally, give some feedback to the user
                              HapticFeedback.heavyImpact(); // Vibrate to indicate success
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Cloth picked up successfully!')),
                              );
                            }
                          } else {
                            // If not drying, navigate to LevelSelectionPage as usual
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            globals.cleanlinessLevel = prefs.getInt('cleanlinessLevel')!.toInt();

                            if (_selectedIndices.isNotEmpty) {
                              _toggleSelection(index);
                            } else {
                              // Navigate to LevelSelectionPage and pass the checkwashing function
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LevelSelectionPage(
                                    laundryItem: _flashcards[index],
                                    checkWashingCallback: checkwashing, // Pass checkwashing callback
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        onLongPress: () {
                          _toggleSelection(index);
                        },
                        child: Card(
                          elevation: 0.0, // Keep elevation flat
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: _selectedIndices.contains(index)
                                  ? null // No gradient when selected
                                  : LinearGradient(
                                colors: [
                                  Colors.white, // Start with white
                                  _flashcards[index].dirty == -1
                                      ? Colors.grey.shade300 // Grey for drying clothes
                                      : _flashcards[index].dirty > 3 * (12 - globals.cleanlinessLevel)
                                      ? const Color(0xfff43e3e) // Red for very dirty clothes
                                      : _flashcards[index].dirty > (12 - globals.cleanlinessLevel) && _flashcards[index].dirty <= 3 * (12 - globals.cleanlinessLevel)
                                      ? const Color.fromRGBO(255, 153, 153, 0.7) // Light red for dirty clothes
                                      : _flashcards[index].dirty > 0 && _flashcards[index].dirty < (12 - globals.cleanlinessLevel)
                                      ? const Color(0xfff9f1a4) // Yellow for moderately dirty clothes
                                      : const Color(0xffa0fc81), // Green for clean clothes
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: [0.0, 1.0], // Smooth uniform gradient transition
                              ),
                              color: _selectedIndices.contains(index) ? Colors.blue.shade100 : null, // Solid blue if selected
                              borderRadius: BorderRadius.circular(12.0), // Circular corners
                            ),
                            padding: const EdgeInsets.all(2.0),
                            child: ListTile(
                              leading: _flashcards[index].pic != null && _flashcards[index].pic.isNotEmpty
                                  ? ColorFiltered(
                                colorFilter: _flashcards[index].dirty == -1
                                    ? ColorFilter.mode(Colors.grey, BlendMode.saturation) // Apply grayscale
                                    : ColorFilter.mode(Colors.transparent, BlendMode.saturation),
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: FileImage(File(_flashcards[index].pic)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              )
                                  : Icon(Icons.image_not_supported),

                              // Title with Font Size 16
                              title: Text(
                                _flashcards[index].name,
                                style: TextStyle(
                                  fontSize: 16,  // Set font size to 16 for the title
                                  color: _flashcards[index].dirty == -1 ? Colors.grey : Colors.black, // Grey font when washed
                                ),
                              ),

                              // Subtitle with Font Size 12
                              subtitle: Text(
                                _flashcards[index].dirty == -1
                                    ? '${_calculateTimeDifference(_flashcards[index].lastWorn)}\nThe cloth is drying right now.'
                                    : '${_calculateTimeDifference(_flashcards[index].lastWorn)}',
                                style: TextStyle(
                                  fontSize: 12,  // Set font size to 12 for the subtitle
                                  color: _flashcards[index].dirty == -1 ? Colors.grey : Colors.black, // Grey subtitle when washed
                                ),
                              ),

                              // Trailing section
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min, // Makes sure the row doesn't take too much space
                                children: [
                                  Container(
                                    width: 0.0,
                                    height: 0.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _flashcards[index].dirty == -1
                                          ? Colors.grey.shade300 // Greyed out color when drying
                                          : _flashcards[index].dirty > 3 * (12 - globals.cleanlinessLevel)
                                          ? const Color(0xfff43e3e) // Red for very dirty
                                          : _flashcards[index].dirty > (12 - globals.cleanlinessLevel) && _flashcards[index].dirty <= 3 * (12 - globals.cleanlinessLevel)
                                          ? const Color.fromRGBO(255, 153, 153, 0.7) // Light red for dirty clothes
                                          : _flashcards[index].dirty > 0 && _flashcards[index].dirty < (12 - globals.cleanlinessLevel)
                                          ? const Color(0xffFFF5CD) // Yellow for moderately dirty
                                          : const Color(0xffa0fc81), // Green for clean clothes
                                    ),
                                  ),
                                  const SizedBox(width: 8.0), // Add some spacing between the circle and the text
                                  Text(
                                    _flashcards[index].dirty > 0 ? "${_flashcards[index].dirty}" : "0", // Show "Dirty" only if dirty > 0
                                    style: TextStyle(
                                      fontSize: 14.783650,
                                      color: _flashcards[index].dirty > 0 ? Colors.black : Colors.black, // Hide text if not dirty
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
         ),
      ),
      floatingActionButton: _selectedIndices.isNotEmpty
          ? FloatingActionButton(
        onPressed: () {
          print("Floating action button pressed!"); // Debugging

          // Show bottom sheet with options (Edit/Delete, Wash, etc.)
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Wrap(
                children: [
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Edit'),
                    onTap: () {
                      print("Edit option tapped!"); // Debugging
                      // Close the BottomSheet before navigating
                      Navigator.pop(context);

                      // Ensure we have a valid selected index
                      if (_selectedIndices.isNotEmpty) {
                        _editSelectedFlashcard(_selectedIndices.first);
                      }
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.local_laundry_service),
                    title: Text('Wash Clothes'),
                    onTap: () {
                      print("Wash option tapped!"); // Debugging
                      // Close the BottomSheet before proceeding with the wash action
                      Navigator.pop(context);

                      // Reset the 'dirty' value of selected clothes to 0 and change their color to purple
                      _washSelectedClothes();
                    },
                  ),
                  // You can add more actions like delete, etc.
                ],
              );
            },
          );
        },
        child: Icon(Icons.more_vert),
      )
          : FloatingActionButton(
        onPressed: () async {
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

    )
    );
  }
  Future<void> checkwashing() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int count =1;
    for(var currcloth in _flashcards){
      int dirty = currcloth.dirty;
      if(dirty>=(12 - globals.cleanlinessLevel)){
        count = count+1;
      }
    }
    print("__________________________________________________________________________________");
    print(count);
    print(prefs.getInt('washfreq')!.toInt());
    if(count>=prefs.getInt('washfreq')!.toInt()){
      print("REACHED");
      NotificationService().showInstantNotification();
    }
  }
}

