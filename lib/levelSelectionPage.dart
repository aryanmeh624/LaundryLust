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
    await updatelaundry(laundryItem);

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
                      '😊',
                      style: TextStyle(fontSize: 24),
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
                      '😎',
                      style: TextStyle(fontSize: 24),
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
                      '🤯',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Level 3'),
                ],
              ),
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // You can add functionality for deleting or resetting the dirty value here.
              },
              icon: Icon(Icons.delete),
              label: Text(''),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: CircleBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
