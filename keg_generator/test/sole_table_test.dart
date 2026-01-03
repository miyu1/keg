import 'dart:io';

import 'package:keg_annotation/keg_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

part 'sole_table_test.g.dart';

@Table()
class User {
  int id;
  String name;

  User(this.name, [this.id = 0]);

  Map<String, Object?> toSqlMap() => _$UserHelper.toSqlMap(this);
  factory User.fromSqlMap(Map<String, Object?> map) =>
      _$UserHelper.fromSqlMap(map);

}

enum Color {
  red, green, blue;
}

@Table()
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

  Map<String, Object?> toSqlMap() => _$ItemInfoHelper.toSqlMap(this);
  factory ItemInfo.fromSqlMap(Map<String, Object?> map) =>
      _$ItemInfoHelper.fromSqlMap(map);
}

/*
@Table()
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

  Map<String, Object?> toSqlMap() => _$ItemInfo2Helper.toSqlMap(this);
  factory ItemInfo2.fromSqlMap(Map<String, Object?> map) =>
      _$ItemInfo2Helper.fromSqlMap(map);
}
*/

@KegDatabase(tables: [User, ItemInfo])
class AppDatabase extends _$AppDatabase {
  @override
  Future<String> getPathToOpen() async {
    // Implement your logic to get the database path
    return 'app.db';
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

    final dir = await getDatabasesPath();
    final path = p.join(dir, 'app.db');
    print('deleting file: $path');
    final f = File(path);
    await f.delete();
  });

  test('map conversion', () async {
    // User
    final userHelper = appdb.userHelper;

    final user1 = User('John');
    expect(user1.id, 0);

    final map1 = user1.toSqlMap();
    expect(map1.length, 1);
    expect(map1.containsKey(userHelper.column.name), true);
    expect(map1.containsKey(userHelper.column.id), false);
    expect(map1[userHelper.column.name], 'John');

    final user2 = User.fromSqlMap(map1);
    expect(user1.name, user2.name);
    expect(user1.id, user2.id);

    // ItemInfo
    final helper = appdb.itemInfoHelper;

    // table and fields are snake_case
    expect(helper.tableName, 'item_info');
    expect(helper.column.isActive, 'is_active');


    final item1 = ItemInfo('pen', weight:5.5, color: Color.red, stock: 10,
      isActive: false, id: 10);
    final map2 = item1.toSqlMap();
    expect(map2.length, 7);
    expect(map2[helper.column.color], 'red');
    expect(map2[helper.column.isActive], 0);
    expect(map2[helper.column.created], item1.created.toUtc().microsecondsSinceEpoch);

    final item2 = ItemInfo.fromSqlMap(map2);
    expect(item2.id, item1.id);
    expect(item2.name, item1.name);
    expect(item2.weight, item1.weight);
    expect(item2.color, item1.color);
    expect(item2.stock, item1.stock);
    expect(item2.isActive, item1.isActive);
    expect(item2.created, item1.created);
  });

  test('table creation', () async {
    await appdb.open();

    expect(appdb.isOpen, true);
    expect(appdb.schemaVersion, 1);

    final result = await appdb.rawQuery('pragma user_version');
    // print(result);

    expect(result.length, 1);

    final version = result[0]['user_version'];
    expect(version, 1);
  });

  test('insert/delete User', () async {
    final user1 = User('John');
    expect(user1.id, 0);

    final id = await appdb.registerUser(user1);
    print('id: $id');
    expect(id, greaterThan(0));
    expect(user1.id, id);

    final result = await appdb.queryUser();
    expect(result.length, 1);
    final user2 = result[0];
    expect(user2.id, user1.id);
    expect(user2.name, user1.name);

    final count = await appdb.deleteUser(user1);
    expect(count, 1);

    final result2 = await appdb.queryUser();
    expect(result2.length, 0);
  });

  test('query User', () async {
    final user1 = User('John');
    final user2 = User('Mike');
    final user3 = User('Jack');

    await appdb.registerUser(user1);
    await appdb.registerUser(user2);
    await appdb.registerUser(user3);

    final result = await appdb.queryUser(orderBy: '${appdb.userHelper.column.name} asc');
    expect(result.length, 3);
    expect(result[0].name, 'Jack');
    expect(result[1].name, 'John');
    expect(result[2].name, 'Mike');

    final result2 = await appdb.queryUser(
      where: "${appdb.userHelper.column.name} LIKE 'J%'",
      orderBy: '${appdb.userHelper.column.name} desc'
    );
    expect(result2.length, 2);
    expect(result2[0].name, 'John');
    expect(result2[1].name, 'Jack');

    final result3 = await appdb.queryUser(
      where: "${appdb.userHelper.column.name} = ?",
      whereArgs: ['Mike'],
    );
    expect(result3.length, 1);
    expect(result3[0].name, 'Mike');

    await appdb.deleteUser(user1);
    await appdb.deleteUser(user2);
    await appdb.deleteUser(user3);
  });

  test('insert/delete item', () async {
    final item1 = ItemInfo('pen', weight: 8.5, color: .red,
      stock: 10, isActive: true, id: 10);

    await appdb.registerItemInfo(item1);
    final result1 = await appdb.queryItemInfo();

    expect(result1.length, 1);
    expect(result1[0].id, 10);

    final item2 = ItemInfo('blue pen', weight: 12.5, color: .blue,
      stock: 30, isActive: false, id: 10);
    await appdb.registerItemInfo(item2);
    final result2 = await appdb.queryItemInfo();

    expect(result2.length, 1);
    expect(result2[0].id, item2.id);
    expect(result2[0].name, item2.name);
    expect(result2[0].weight, item2.weight);
    expect(result2[0].color, item2.color);
    expect(result2[0].stock, item2.stock);
    expect(result2[0].isActive, item2.isActive);
    expect(result2[0].created, item2.created);

    await appdb.deleteItemInfo(item2);
  });
}
