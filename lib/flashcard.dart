// flashcard.dart2
/*
id
pic
lastworn
dirty
name
 */
import 'dart:typed_data';
import 'cloth_data/get_clothes.dart';
class Clothboii {
  final String cloth_name;
  final int last_worn;
  final int dirty;
  final Uint8List pic;
  final int id;
  Clothboii({
    required this.cloth_name,
    required this.last_worn,
    required this.dirty,
    required this.pic,
    required this.id,
});
}
Future<void> _loadData() async {
  try {
    List<Clothboii> _flashcards = [];
    var laundryDataList = await laundryGet(); // Get the list of dictionaries
    _flashcards = laundryDataList.map((data) {
      return Clothboii(
          cloth_name: data.name,
          last_worn: data.lastWorn,
          dirty: data.dirty,
          id: data.id,
          pic: data.pic,
        );
      }).toList();
  } catch (e) {
    // Handle the error as needed
  }
}
