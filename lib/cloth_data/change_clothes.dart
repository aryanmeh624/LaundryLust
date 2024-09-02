import 'package:laundry_lust/cloth_data/main_DB.dart';
import 'package:sqflite/sqflite.dart';

Future<void> insertlaundry(laundryData laundry) async{
  final db = await  database;
  await db.insert(
    'laundry',
    laundry.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<void> updatelaundry(laundryData laundry) async{
  final db = await database;
  await db.update(
    'laundry',
    laundry.toMap(),
    where: 'id = ?',
    whereArgs: [laundry.id],
  );
}

