import 'dart:io';

import 'package:keg_annotation/keg_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

part 'many_to_many_test.g.dart';

@table
class Cart {
  int id;
  String user;

  @ManyToMany(middle: OrderToItem, self: 'order', target: 'item',
    order: 'name', descendant: true)
  List<Item> itemList = [];

  @ManyToMany(middle: OrderToItem, self: 'order', target: 'item',
    order: 'name', descendant: true)
  List<Item> itemList2 = [];

  Cart(this.user, {this.id = 0});

  Map<String, Object?> toSqlMap() => _$CartHelper.toSqlMap(this);
  factory Cart.fromSqlMap(Map<String, Object?> map) =>
      _$CartHelper.fromSqlMap(map);
}

@table
class Item {
  int id;
  String name;

  Item(this.name, {this.id = 0});

  Map<String, Object?> toSqlMap() => _$ItemHelper.toSqlMap(this);
  factory Item.fromSqlMap(Map<String, Object?> map) =>
      _$ItemHelper.fromSqlMap(map);
}

@table
class OrderToItem {
  int id;
  Cart? order;
  String field;
  Item? item;

  OrderToItem({required this.order, required this.item, required this.field, this.id = 0});

  Map<String, Object?> toSqlMap() => _$OrderToItemHelper.toSqlMap(this);
  factory OrderToItem.fromSqlMap(Map<String, Object?> map) =>
      _$OrderToItemHelper.fromSqlMap(map);
}


@KegDatabase(tables: [Cart, Item, OrderToItem])
class AppDatabase extends _$AppDatabase {
  @override
  Future<String> getPathToOpen() async {
    // Implement your logic to get the database path
    return 'many2many.db';
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

  test('register order with items', () async {
    final item1 = Item('Item 1');
    final item2 = Item('Item 2');
    final item3 = Item('Item 3');
    final item4 = Item('Item 4');

    await appdb.registerItem(item1);
    await appdb.registerItem(item2);
    await appdb.registerItem(item3);
    await appdb.registerItem(item4);

    final cart = Cart('User A');
    cart.itemList.addAll([item1]);
    cart.itemList2.addAll([item3, item4]);
    final cart2 = Cart('User B');
    cart2.itemList.addAll([item3, item4]);

    await appdb.registerCart(cart);
    await appdb.registerCart(cart2);

    // update
    cart.itemList.add(item2);
    await appdb.registerCart(cart);

    final cart3 = await appdb.getCart(cart.id);
    expect(cart3, isNotNull);
    expect(cart3?.user, 'User A');
    expect(cart3?.itemList.length, 2);
    expect(cart3?.itemList[0].name, 'Item 2');
    expect(cart3?.itemList[1].name, 'Item 1');
    expect(cart3?.itemList2.length, 2);
    expect(cart3?.itemList2[0].name, 'Item 4');
    expect(cart3?.itemList2[1].name, 'Item 3');

    final result = await appdb.queryOrderToItem();
    expect(result.length, 6);

    await appdb.deleteCartByIds([cart]);
    final cart4 = await appdb.getCart(cart.id);
    expect(cart4, isNull);

    final result2 = await appdb.queryOrderToItem();
    expect(result2.length, 2);

    await appdb.deleteCart(where: '${appdb.cartHelper.column.user} = ?', whereArgs: ['User B']);
    final cart5 = await appdb.getCart(cart2.id);
    expect(cart5, isNull);

    final result3 = await appdb.queryOrderToItem();
    expect(result3.length, 0);

  });
}
