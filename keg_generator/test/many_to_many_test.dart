import 'package:keg_annotation/keg_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

part 'many_to_many_test.g.dart';

// class name order is reserved word in sql. test if reserved word is usable as class name.
@table
class Order {
  int id;
  String user;

  @ManyToMany(middle: OrderToItem, self: 'order', target: 'item',
    order: 'name', descendant: true)
  List<Item> itemList = [];

  @ManyToMany(middle: OrderToItem, self: 'order', target: 'item',
    order: 'name', descendant: true)
  List<Item> itemList2 = [];

  Order(this.user, {this.id = 0});

  Map<String, Object?> toSqlMap() => _$OrderHelper.toSqlMap(this);
  factory Order.fromSqlMap(Map<String, Object?> map) =>
      _$OrderHelper.fromSqlMap(map);
}

@table
class Item {
  int id;
  String name;

  @BackLink(to: 'itemList')
  List <Order> orderList = [];

  Item(this.name, {this.id = 0});

  Map<String, Object?> toSqlMap() => _$ItemHelper.toSqlMap(this);
  factory Item.fromSqlMap(Map<String, Object?> map) =>
      _$ItemHelper.fromSqlMap(map);
}

@table
class OrderToItem {
  int id;
  Order? order;
  String field;
  Item? item;

  OrderToItem({required this.field, this.order, this.item, this.id = 0});

  Map<String, Object?> toSqlMap() => _$OrderToItemHelper.toSqlMap(this);
  factory OrderToItem.fromSqlMap(Map<String, Object?> map) =>
      _$OrderToItemHelper.fromSqlMap(map);
}


@KegDatabase(tables: [Order, Item, OrderToItem])
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
    await databaseFactory.deleteDatabase(path);
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

    final order = Order('User A');
    order.itemList.addAll([item1]);
    order.itemList2.addAll([item3, item4]);
    final order2 = Order('User B');
    order2.itemList.addAll([item3, item4]);

    await appdb.registerOrder(order);
    await appdb.registerOrder(order2);

    // update
    order.itemList.add(item2);
    await appdb.registerOrder(order);

    final order3 = await appdb.getOrder(order.id);
    expect(order3, isNotNull);
    expect(order3?.user, 'User A');
    expect(order3?.itemList.length, 2);
    expect(order3?.itemList[0].name, 'Item 2');
    expect(order3?.itemList[1].name, 'Item 1');
    expect(order3?.itemList2.length, 2);
    expect(order3?.itemList2[0].name, 'Item 4');
    expect(order3?.itemList2[1].name, 'Item 3');
    expect(order3?.itemList[0].orderList, isEmpty);
    expect(order3?.itemList[1].orderList, isEmpty);

    final result = await appdb.queryOrderToItem();
    expect(result.length, 6);

    // back link
    final item5 = await appdb.getItem(item1.id);
    expect(item5, isNotNull);
    expect(item5?.orderList.length, 1);
    expect(item5?.orderList[0].user, 'User A');

    await appdb.deleteOrderByIds([order]);
    final order4 = await appdb.getOrder(order.id);
    expect(order4, isNull);

    final result2 = await appdb.queryOrderToItem();
    expect(result2.length, 2);

    await appdb.deleteOrder(where: '${appdb.orderHelper.column.user} = ?', whereArgs: ['User B']);
    final order5 = await appdb.getOrder(order2.id);
    expect(order5, isNull);

    final result3 = await appdb.queryOrderToItem();
    expect(result3.length, 0);

  });
}
