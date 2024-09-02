import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class laundryData{
  final int id;
  final int pic;
  final int lastWorn;
  final int dirty;
  final String name;

  const laundryData({
    required this.id,
    required this.pic,
    required this.lastWorn,
    required this.dirty,
    required this.name,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pic': pic,  // This should match the database column name
      'lastWorn': lastWorn,
      'dirty': dirty,
      'name': name,
    };
  }
  @override
  String toString(){
    return 'laundryData{id: $id,pic: $pic, lastWorn: $lastWorn, dirty: $dirty, name: $name}';
  }
}



