import 'dart:io';

import 'package:keg_annotation/keg_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

part 'keg_generator_example.g.dart';

@table
class User {
  int id;
  String name;

  @BackLink(to: 'user')
  List<Order> orderList = [];

  User(this.name, {this.id = 0});
  Map<String, Object?> toSqlMap() => _$UserHelper.toSqlMap(this);
  factory User.fromSqlMap(Map<String, Object?> map) =>
      _$UserHelper.fromSqlMap(map);
}

@table
class Order {
  int id;
  User? user;

  @ManyToMany(middle: OrderToItem, self: 'order', target: 'item', order: 'name')
  List<Item> itemList = [];

  Order({this.user, this.id = 0});

  Map<String, Object?> toSqlMap() => _$OrderHelper.toSqlMap(this);
  factory Order.fromSqlMap(Map<String, Object?> map) =>
      _$OrderHelper.fromSqlMap(map);
}

@table
class Item {
  int id;
  String name;

  @BackLink(to: 'itemList')
  List<Order> orderList = [];

  Item(this.name, {this.id = 0});

  Map<String, Object?> toSqlMap() => _$ItemHelper.toSqlMap(this);
  factory Item.fromSqlMap(Map<String, Object?> map) =>
      _$ItemHelper.fromSqlMap(map);
}

@table
class OrderToItem {
  int id;
  Order? order;
  Item? item;
  String field;

  OrderToItem({required this.field, this.order, this.item, this.id = 0});

  Map<String, Object?> toSqlMap() => _$OrderToItemHelper.toSqlMap(this);
  factory OrderToItem.fromSqlMap(Map<String, Object?> map) =>
      _$OrderToItemHelper.fromSqlMap(map);
}

@KegDatabase(tables: [User, Order, Item, OrderToItem])
class AppDatabase extends _$AppDatabase {
  @override
  Future<String> getPathToOpen() async {
    // Implement your logic to get the database path
    return 'app.db';
  }

  @override
  Future<void> onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
    //return super.onConfigure(db);
  }
}

void main() async {
  databaseFactory = databaseFactoryFfi;
  final appdb = AppDatabase();
  await appdb.open();

  // user
  final john = User('John');
  final jane = User('Jane');

  await appdb.registerUser(john);
  await appdb.registerUser(jane);

  // items
  final pen = Item('Pen');
  final notebook = Item('Notebook');
  final tablet = Item('Tablet');
  final earPhone = Item('Ear Phone');

  await appdb.transaction((txn) async {
    await txn.registerItem(pen);
    await txn.registerItem(notebook);
    await txn.registerItem(tablet);
    await txn.registerItem(earPhone);
  });

  // orders
  final order1 = Order(user: john);
  order1.itemList.addAll([pen, notebook]);
  final order2 = Order(user: jane);
  order2.itemList.addAll([tablet, earPhone]);
  final order3 = Order(user: john);
  order3.itemList.addAll([tablet]);

  final batch = appdb.batch();
  batch.registerOrder(order1);
  batch.registerOrder(order2);
  batch.registerOrder(order3);
  await batch.commit();

  final result = await appdb.queryUser();
  for (var user in result) {
    print('User: ${user.name} (id=${user.id}) ');
    for (var order in user.orderList) {
      print('  Order: (id=${order.id})');
      for (var item in order.itemList) {
        print('    Item: ${item.name} (id=${item.id})');
      }
    }
  }

  final result2 = await appdb.queryItem();
  for (var item in result2) {
    print('Item: ${item.name} (id=${item.id})');
    for (var order in item.orderList) {
      print('  Order: (id=${order.id})');
      if (order.user != null) {
        print('    User: ${order.user!.name} (id=${order.user!.id})');
      }
    }
  }

  await appdb.close();

  final path = appdb.path;
  print('deleting database file: $path');
  final f = File(path);
  await f.delete();
}
