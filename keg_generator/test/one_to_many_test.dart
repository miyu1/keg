import 'dart:io';

import 'package:keg_annotation/keg_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

part 'one_to_many_test.g.dart';

@table
class Category {
  int id;
  String name;

  Category(this.name, {this.id = 0});

  Map<String, Object?> toSqlMap() => _$CategoryHelper.toSqlMap(this);
  factory Category.fromSqlMap(Map<String, Object?> map) =>
      _$CategoryHelper.fromSqlMap(map);
}

@table
class Item {
  int id;
  String name;

  Category? category;

  Item(this.name, {this.category, this.id = 0});

  Map<String, Object?> toSqlMap() => _$ItemHelper.toSqlMap(this);
  factory Item.fromSqlMap(Map<String, Object?> map) =>
      _$ItemHelper.fromSqlMap(map);
}


@KegDatabase(tables: [Category, Item])
class AppDatabase extends _$AppDatabase {
  @override
  Future<String> getPathToOpen() async {
    // Implement your logic to get the database path
    return 'one2many.db';
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

  test('category is null', () async {
    final result = await appdb.rawQuery('PRAGMA foreign_keys');
    expect(result.length, 1);
    expect(result[0]['foreign_keys'], 1);

    final item1 = Item('book');
    await appdb.registerItem(item1);
    final item2 = await appdb.getItem(item1.id);
    expect(item2, isNotNull);
    expect(item2?.name, item1.name);
    expect(item2?.category, isNull);

    // id of category is 0
    final cat = Category('pen');
    final item3 = Item('ballpoint pen', category: cat);
    expect(appdb.registerItem(item3), throwsStateError);

    await appdb.deleteItem(item1);
  });

  test('category is set', () async {
    final cat = Category('pen');
    final item1 = Item('ballpoint pen', category: cat);
    await appdb.registerCategory(cat);
    await appdb.registerItem(item1);
    final item2 = await appdb.getItem(item1.id);
    expect(item2, isNotNull);
    expect(item2?.name, item1.name);
    expect(item2?.category, isNotNull);
    expect(item2?.category?.id, cat.id);
    expect(item2?.category?.name, cat.name);

    final cat2 = Category('stationary');
    item2?.category = cat2;
    await appdb.registerCategory(cat2);
    await appdb.registerItem(item2!);

    final item3 = await appdb.getItem(item1.id);
    expect(item3, isNotNull);
    expect(item3?.category, isNotNull);
    expect(item3?.category?.id, cat2.id);
    expect(item3?.category?.name, cat2.name);

    await appdb.deleteItem(item1);
    await appdb.deleteCategory(cat);
    await appdb.deleteCategory(cat2);
  });

  test('transaction test', () async {
    final cat = Category('pen');
    final item1 = Item('ballpoint pen', category: cat);

    await appdb.transaction((txn) async {
      await txn.registerCategory(cat);
      await txn.registerItem(item1);
    });

    await appdb.readTransaction((txn) async {
      final item2 = await txn.getItem(item1.id);
      expect(item2, isNotNull);
      expect(item2?.name, item1.name);
      expect(item2?.category, isNotNull);
      expect(item2?.category?.id, cat.id);
      expect(item2?.category?.name, cat.name);
    });

    await appdb.transaction((txn) async {
      await txn.deleteItem(item1);
      await txn.deleteCategory(cat);
    });
  });

  test('batch test', () async {
    final cat = Category('pen');
    final item1 = Item('ballpoint pen', category: cat);

    await appdb.registerCategory(cat);

    final batch1 = appdb.batch();
    batch1.registerItem(item1);
    await batch1.commit();

    final batch2 = appdb.batch();
    batch2.getItem(item1.id);
    final result1 = await batch2.commit();

    expect(result1.length, 1);
    final item2 = result1[0] as Item?;
    expect(item2, isNotNull);
    expect(item2?.name, item1.name);
    expect(item2?.category, isNotNull);
    expect(item2?.category?.id, cat.id);
    expect(item2?.category?.name, cat.name);

    final batch3 = appdb.batch();
    batch3.deleteItem(item1);
    batch3.deleteCategory(cat);
    await batch3.commit();

    final batch4 = appdb.batch();
    batch4.queryCategory();
    batch4.queryItem();
    final result4 = await batch4.commit();
    expect(result4.length, 2);
    final categoryList = result4[0] as List<Category>;
    final itemList = result4[1] as List<Item>;
    expect(categoryList, isEmpty);
    expect(itemList, isEmpty);

  });  

  /*
  test('join', () async {
    final cat = Category('pen');
    final item1 = Item('ballpoint pen', category: cat);
    await appdb.registerCategory(cat);
    await appdb.registerItem(item1);

    var columnList = [];
    columnList.addAll(
     appdb.itemHelper.columnList.map((e) => 'item.$e',)
    );
    columnList.addAll(
      appdb.categoryHelper.columnList.map((e) => 'category.$e as "category-$e"',)
    ); 

    final sql = '''
      SELECT ${columnList.join(', ')}  
      FROM ${appdb.itemHelper.tableName}
      INNER JOIN ${appdb.categoryHelper.tableName}
      ON ${appdb.itemHelper.tableName}.${appdb.itemHelper.column.category} =
      ${appdb.categoryHelper.tableName}.${appdb.categoryHelper.column.id}
    ''';
    print(sql);
    final result = await appdb.rawQuery(sql);
    print(result);
  });
  */
}
