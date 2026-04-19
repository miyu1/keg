import 'dart:io';

import 'package:keg_annotation/keg_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

part 'one_to_many_test.g.dart';

@table
class Category {
  int id;
  String name;

  @BackLink(to: "category", order: "name")
  List<Item> itemList;

  Category(this.name, {this.id = 0, this.itemList = const []});

  Map<String, Object?> toSqlMap() => _$CategoryHelper.toSqlMap(this);
  factory Category.fromSqlMap(Map<String, Object?> map) =>
      _$CategoryHelper.fromSqlMap(map);
}

@table
class Item {
  int id;
  String name;

  Category? category;
  Category? subCategory;

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

    await appdb.deleteItemByIds([item1]);
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

    final cat3 = await appdb.getCategory(cat.id);
    expect(cat3, isNotNull);
    expect(cat3?.itemList.length, 1);
    expect(cat3?.itemList[0].id, item1.id);
    expect(cat3?.itemList[0].name, item1.name);
    expect(cat.itemList, isEmpty);

    final cat2 = Category('stationery');
    item2?.category = cat2;
    await appdb.registerCategory(cat2);
    await appdb.registerItem(item2!);

    final item3 = await appdb.getItem(item1.id);
    expect(item3, isNotNull);
    expect(item3?.category, isNotNull);
    expect(item3?.category?.id, cat2.id);
    expect(item3?.category?.name, cat2.name);

    final dropKey = (
      table: appdb.itemHelper.tableName,
      column: appdb.itemHelper.column.category,
    );
    final result = await appdb.queryItem(dropKeys: [dropKey]);
    expect(result.length, 1);
    final item4 = result[0];
    expect(item4.category, isNull);

    await appdb.deleteItemByIds([item1]);
    await appdb.deleteCategoryByIds([cat, cat2]);
    //await appdb.deleteCategory(cat2);
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

      final cat2 = await txn.getCategory(cat.id);
      expect(cat2, isNotNull);
      expect(cat2?.itemList.length, 1);
      expect(cat2?.itemList[0].name, item1.name);
    });

    await appdb.transaction((txn) async {
      await txn.deleteItemByIds([item1]);
      await txn.deleteCategoryByIds([cat]);
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
    batch2.getCategory(cat.id);
    final result1 = await batch2.commit();

    expect(result1.length, 2);
    final item2 = result1[0] as Item?;
    expect(item2, isNotNull);
    expect(item2?.name, item1.name);
    expect(item2?.category, isNotNull);
    expect(item2?.category?.id, cat.id);
    expect(item2?.category?.name, cat.name);

    final cat2 = result1[1] as Category?;
    expect(cat2, isNotNull);
    expect(cat2?.itemList.length, 1);
    expect(cat2?.itemList[0].name, item1.name);

    final batch3 = appdb.batch();
    batch3.deleteItemByIds([item1]);
    batch3.deleteCategoryByIds([cat]);
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

  test('multi records', () async {
    final cat1 = Category('stationery');
    final cat2 = Category('pen');
    final cat3 = Category('mobile');

    await appdb.registerCategory(cat1);
    await appdb.registerCategory(cat2);
    await appdb.registerCategory(cat3);

    final item1 = Item('ballpoint pen', category: cat1);
    item1.subCategory = cat2;
    final item2 = Item('pencil', category: cat1);
    item2.subCategory = cat2;
    final item3 = Item('notebook', category: cat1);
    final item4 = Item('phone', category: cat3);
    final item5 = Item('tablet', category: cat3);

    await appdb.registerItem(item1);
    await appdb.registerItem(item2);
    await appdb.registerItem(item3);
    await appdb.registerItem(item4);
    await appdb.registerItem(item5);

    final cat11 = await appdb.getCategory(cat1.id);
    expect(cat11, isNotNull);
    expect(cat11?.itemList.length, 3);
    expect(cat11?.itemList[0].name, item1.name);
    expect(cat11?.itemList[1].name, item3.name);
    expect(cat11?.itemList[2].name, item2.name);

    final cat21 = await appdb.getCategory(cat2.id);
    expect(cat21, isNotNull);
    expect(cat21?.itemList.length, 0);

    final cat31 = await appdb.getCategory(cat3.id);
    expect(cat31, isNotNull);
    expect(cat31?.itemList.length, 2);
    expect(cat31?.itemList[0].name, item4.name);
    expect(cat31?.itemList[1].name, item5.name);

    final item11 = await appdb.getItem(item1.id);
    expect(item11, isNotNull);
    expect(item11?.category, isNotNull);
    expect(item11?.category?.name, cat1.name);
    expect(item11?.subCategory, isNotNull);
    expect(item11?.subCategory?.name, cat2.name);

    final item21 = await appdb.getItem(item2.id);
    expect(item21, isNotNull);
    expect(item21?.category, isNotNull);
    expect(item21?.category?.name, cat1.name);
    expect(item21?.subCategory, isNotNull);
    expect(item21?.subCategory?.name, cat2.name);

    final item31 = await appdb.getItem(item3.id);
    expect(item31, isNotNull);
    expect(item31?.category, isNotNull);
    expect(item31?.category?.name, cat1.name);
    expect(item31?.subCategory, isNull);

    final item41 = await appdb.getItem(item4.id);
    expect(item41, isNotNull);
    expect(item41?.category, isNotNull);
    expect(item41?.category?.name, cat3.name);
    expect(item41?.subCategory, isNull);

    final item51 = await appdb.getItem(item5.id);
    expect(item51, isNotNull);
    expect(item51?.category, isNotNull);
    expect(item51?.category?.name, cat3.name);
    expect(item51?.subCategory, isNull);

    final batch = appdb.batch();
    batch.deleteItemByIds([item1, item2, item3, item4, item5]);
    // batch.deleteItem(item2);
    // batch.deleteItem(item3);
    // batch.deleteItem(item4);
    // batch.deleteItem(item5);
    batch.deleteCategoryByIds([cat1, cat2, cat3]);
    // batch.deleteCategory(cat2);
    // batch.deleteCategory(cat3);
    await batch.commit(noResult: true);
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
