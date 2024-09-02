//import 'dart:nativewrappers/_internal/vm/lib/typed_data_patch.dart';
import 'dart:async';
import 'database_helper.dart';
import 'dart:typed_data';
import 'package:laundry_lust/cloth_data/main_DB.dart';

Future<List<laundryData>> laundryGet() async{
  final db = await DatabaseHelper().database;
  final List<Map<String, dynamic>> laundryMaps = await db.query('laundry');
  return[
    for(final{
      'id': id as int,
      'pic': pic as int,
      'lastWorn':  lastWorn as int,
      'dirty': dirty as int,
      'name': name as String
    } in laundryMaps)
      laundryData(id: id,pic: pic, lastWorn: lastWorn, dirty: dirty, name: name),
      ];
}