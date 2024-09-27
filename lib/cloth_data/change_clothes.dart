import 'package:laundry_lust/cloth_data/main_DB.dart'; // Model for laundryData
import 'database_helper.dart'; // Helper class for database access
import 'package:sqflite/sqflite.dart';

/// Insert new laundry data into the database
Future<void> insertlaundry(laundryData laundry) async {
  final db = await DatabaseHelper().database;
  await db.insert(
    'laundry',
    laundry.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

/// Update existing laundry data in the database
Future<void> updatelaundry(laundryData laundry) async {
  final db = await DatabaseHelper().database;

  // Update the 'dirty' value of a specific laundry item identified by 'id'
  await db.update(
    'laundry',
    laundry.toMap(), // Converts the laundryData object to a map
    where: 'id = ?', // Specifies the row to update using the ID
    whereArgs: [laundry.id], // The ID of the laundryData item to be updated
  );
}

/// Update the 'dirty' field of multiple laundry items to 0 for the selected items
Future<void> washSelectedClothes(List<laundryData> selectedLaundry) async {
  final db = await DatabaseHelper().database;

  // Loop through the selected laundry items and reset the 'dirty' level to 0
  for (laundryData laundry in selectedLaundry) {
    laundry.dirty = 0; // Reset the dirty level to 0

    // Update each item in the database
    await db.update(
      'laundry',
      {'dirty': -1}, // Only update the 'dirty' field
      where: 'id = ?', // Identify the row by its ID
      whereArgs: [laundry.id], // Pass the ID of the item to update
    );
  }
}

Future<void> pickupSelectedClothes(List<laundryData> selectedLaundry) async {
  final db = await DatabaseHelper().database;

  // Loop through the selected laundry items and reset the 'dirty' level to 0
  for (laundryData laundry in selectedLaundry) {
    laundry.dirty = 0; // Reset the dirty level to 0

    // Update each item in the database
    await db.update(
      'laundry',
      {'dirty': 0}, // Only update the 'dirty' field
      where: 'id = ?', // Identify the row by its ID
      whereArgs: [laundry.id], // Pass the ID of the item to update
    );
  }
}

/// Delete selected laundry data from the database
/// Delete a laundry item from the database by its ID
Future<void> deleteLaundryById(int id) async {
  final db = await DatabaseHelper().database;  // Access the database instance

  // Delete the laundry item from the database where the ID matches
  await db.delete(
    'laundry',  // The table name
    where: 'id = ?',  // The WHERE clause to find the record by ID
    whereArgs: [id],  // The arguments for the WHERE clause (ID of the laundry item)
  );
}

