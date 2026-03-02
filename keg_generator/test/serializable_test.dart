import 'dart:io';

import 'package:json_annotation/json_annotation.dart';
import 'package:keg_annotation/keg_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

part 'serializable_test.g.dart';

@table
@JsonSerializable()
class Category {
  int id;
  String name;

  @BackLink(to: "category", order: "name")
  @JsonKey(fromJson: _itemListFromJson, toJson: _itemListToJson)
  final List<Item> itemList;

  Category(this.name, {this.id = 0, this.itemList = const []});

  Map<String, Object?> toSqlMap() => _$CategoryHelper.toSqlMap(this);
  factory Category.fromSqlMap(Map<String, Object?> map) =>
      _$CategoryHelper.fromSqlMap(map);

  factory Category.fromJson(Map<String, dynamic> json) 
    => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  static List<Item> _itemListFromJson(List<dynamic> json) {
    return json.map((e) => Item.fromJson(e as Map<String, dynamic>)).toList();
  }
  static List<dynamic> _itemListToJson(List<Item> itemList) {
    return itemList.map((e) => e.toJson()).toList();
  }
}


@table
@JsonSerializable()
class Item {
  int id;
  String name;

  @JsonKey(fromJson: _categoryFromJson, toJson: _categoryToJson)
  Category? category;

  Item(this.name, {this.category, this.id = 0});

  Map<String, Object?> toSqlMap() => _$ItemHelper.toSqlMap(this);
  factory Item.fromSqlMap(Map<String, Object?> map) =>
      _$ItemHelper.fromSqlMap(map);

  factory Item.fromJson(Map<String, dynamic> json) 
    => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);

  static Category? _categoryFromJson(String? json) {
    if (json == null) return null;
    return Category(json);
  }
  static String? _categoryToJson(Category? category) {
    if (category == null) return null;
    return category.name;
  }
}



@KegDatabase(tables: [Category, Item])
class AppDatabase extends _$AppDatabase {
  @override
  Future<String> getPathToOpen() async {
    // Implement your logic to get the database path
    return 'serializable.db';
  }

  @override
  Future<void> onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
    //return super.onConfigure(db);
  }
}

void main() async {
  // ({int id, String name}) record = (id:1, name:'Alice');
  // var record = (id:1, name:'Alice');
  // print('Record: id=${record.id}, name=${record.name}');

  databaseFactory = databaseFactoryFfi;
  late AppDatabase appdb;

  setUpAll(() async {
    // final path = await getDatabasesPath();
    // print('default db directory: $path');

    appdb = AppDatabase();
    await appdb.open();
  });

  tearDownAll(() async {
    if (appdb.isOpen) {
      await appdb.close();
    }

    final path = appdb.path;
    print('deleting file: $path');
    final f = File(path);
    await f.delete();
  });

  test('serializable test', () async {
    final cat = Category('pen');
    await appdb.registerCategory(cat);
    final item1 = Item('ballpoint pen', category: cat);
    await appdb.registerItem(item1);

    final categoryList = await appdb.queryCategory();
    expect(categoryList.length, 1);

    final json = categoryList[0].toJson();
    expect(json['id'], cat.id);
    expect(json['name'], cat.name);
    expect(json['itemList'], isA<List<dynamic>>());
    expect(json['itemList'].length, 1);
    
    expect(json['itemList'].length, 1);
    expect(json['itemList'][0]['id'], item1.id);
    expect(json['itemList'][0]['name'], item1.name);
    
    final cat2 = Category.fromJson(json);
    expect(cat2.name, cat.name);
    expect(cat2.itemList.length, 1);
    expect(cat2.itemList[0].id, item1.id);
    expect(cat2.itemList[0].name, item1.name);
    expect(cat2.itemList[0].category?.name, cat.name);
    // print('cat2: id=${cat2.id}, name=${cat2.name}');
  });
}