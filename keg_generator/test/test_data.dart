//import 'package:sqflite_common_ffi/sqflite_ffi.dart';

enum Color {
  red, green, blue;
}

class ItemInfo {
  int id;
  String name;
  int stock;
  Color color;
  double weight;
  bool isActive;
  DateTime created = DateTime.now();

  ItemInfo(
    this.name, {
    required this.weight,
    required this.color,
    this.stock = 0,
    this.isActive = true,
    this.id = 0,
  });

  // Map<String, Object?> toSqlMap() => _$ItemInfoHelper.toSqlMap(this);
  // factory ItemInfo.fromSqlMap(Map<String, Object?> map) =>
  //     _$ItemInfoHelper.fromSqlMap(map);
}

class ItemInfo2 {
  int id;
  String name;
  int stock;
  Color color;
  double weight;
  bool isActive;
  DateTime created = DateTime.now();

  ItemInfo2(
    this.name, {
    required this.weight,
    required this.color,
    required this.stock,
    required this.isActive,
    this.id = 0,
  });

}

