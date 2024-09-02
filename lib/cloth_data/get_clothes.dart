import 'package:laundry_lust/cloth_data/main_DB.dart';

Future<List<laundryData>> laundryGet() async{
  final db = await  database;
  final List<Map<String, dynamic>> laundryMaps = await db.query('laundryGet');
  return[
    for(final{
      'id': id as int,
      'pic': pic as blob,
      'lastWorn':  lastWorn as int,
      'dirty': dirty as int,
      'name': name as String
    } in laundryMaps)
      laundryData(id: id,pic: pic, lastWorn: lastWorn, dirty: dirty, name: name),
      ];
}