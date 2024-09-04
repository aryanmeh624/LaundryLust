import 'package:flutter/material.dart';
import 'package:laundry_lust/cloth_data/main_DB.dart'; // Ensure you import your laundryData class
import 'cloth_data/change_clothes.dart'; // Import change_clothes for update functions

class LevelSelectionPage extends StatelessWidget {
  final laundryData laundryItem;

  LevelSelectionPage({required this.laundryItem});

  Future<void> _updateDirtyLevel(int increment, BuildContext context) async {
    // Increase the dirty value by the increment
    laundryData updatedLaundryItem = laundryData(
      id: laundryItem.id,
      pic: laundryItem.pic,
      lastWorn: DateTime.now().millisecondsSinceEpoch,
      dirty: laundryItem.dirty + increment, // Update the dirty value
      name: laundryItem.name,
    );
    // Call the update function to update the database
    await updatelaundry(updatedLaundryItem);

    // Pop the page to return to the previous screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Level'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'How was your use of the cloth today?',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _updateDirtyLevel(1, context),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(24),
                    ),
                    child: Text(
                      '😊🌤️\nCool day\n(no sweat)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Level 1'),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _updateDirtyLevel(2, context),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(24),
                    ),
                    child: Text(
                      '😅🌞\nHot but\nno workout',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Level 2'),
                ],
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => _updateDirtyLevel(3, context),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(24),
                    ),
                    child: Text(
                      '💪😅\nWorkout\n(fully wet)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Level 3'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
