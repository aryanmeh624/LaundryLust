import 'dart:typed_data';
import 'cloth_data/main_DB.dart' as pog;
import 'cloth_data/get_clothes.dart';

Future<List<pog.laundryData>> _loadData() async {
List<pog.laundryData> _flashcards = [];
var laundryDataList = await laundryGet(); // Get the list of dictionaries
_flashcards = laundryDataList.map((data) {
  return pog.laundryData(
      name: data.name,
      lastWorn: data.lastWorn,
      dirty: data.dirty,
      id: data.id,
      pic: data.pic,
    );
  }).toList();
return _flashcards;
}

// class Clothboii {
//   final String cloth_name;
//   final int last_worn;
//   final int dirty;
//   final Uint8List pic;
//   final int id;
//   Clothboii({
//     required this.cloth_name,
//     required this.last_worn,
//     required this.dirty,
//     required this.pic,
//     required this.id,
// });
// }
