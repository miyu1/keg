import 'package:keg_annotation/keg_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

part 'complex_test.g.dart';

@table
class User {
  int id;
  @unique
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

  @ManyToMany(middle: OrderToItem, self: 'order', target: 'item', order: 'name')
  List<Item> cancelledItemList = [];

  Order({this.user, this.id = 0});

  Map<String, Object?> toSqlMap() => _$OrderHelper.toSqlMap(this);
  factory Order.fromSqlMap(Map<String, Object?> map) =>
      _$OrderHelper.fromSqlMap(map);
}

@table
class Category {
  int id;
  @unique
  String name;
  @BackLink(to: 'category')
  List<Item> itemList = [];

  Category(this.name, {this.id = 0});

  Map<String, Object?> toSqlMap() => _$CategoryHelper.toSqlMap(this);
  factory Category.fromSqlMap(Map<String, Object?> map) =>
      _$CategoryHelper.fromSqlMap(map);
}  

@table
class Color {
  int id;
  @unique
  String name;

  @BackLink(to: 'colorList')
  List<Item> itemList = [];

  Color(this.name, {this.id = 0});

  Map<String, Object?> toSqlMap() => _$ColorHelper.toSqlMap(this);
  factory Color.fromSqlMap(Map<String, Object?> map) =>
      _$ColorHelper.fromSqlMap(map);
}

@table
class Item {
  int id;
  @unique  
  String name;
  @index
  Category? category;

  @ManyToMany(middle: ItemToColor, self: 'item', target: 'color')
  List<Color> colorList = [];

  @BackLink(to: 'itemList')
  List<Order> orderList = [];

  Item(this.name, { this.category, this.id = 0});

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

@table
class ItemToColor {
  int id;
  Item? item;
  Color? color;
  String field;

  ItemToColor({this.item, this.color, required this.field, this.id = 0});

  Map<String, Object?> toSqlMap() => _$ItemToColorHelper.toSqlMap(this);
  factory ItemToColor.fromSqlMap(Map<String, Object?> map) =>
      _$ItemToColorHelper.fromSqlMap(map);
}

@KegDatabase(tables: [User, Order, Item, Category, Color, OrderToItem, ItemToColor])
class AppDatabase extends _$AppDatabase {
  @override
  Future<String> getPathToOpen() async {
    // Implement your logic to get the database path
    return 'complex1.db';
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

  test('complex test', () async {
    // user
    final john = User('John');
    final jane = User('Jane');

    await appdb.registerUser(john);
    await appdb.registerUser(jane);

    // category
    final stationery = Category('Stationery');
    final electronics = Category('Electronics');

    await appdb.registerCategory(stationery);
    await appdb.registerCategory(electronics);

    // color
    final red = Color('red');
    final black = Color('black');

    await appdb.registerColor(red);
    await appdb.registerColor(black);

    // items
    final pen = Item('pen', category: stationery)
      ..colorList.addAll([red, black]);
    final notebook = Item('notebook', category: stationery);
    final tablet = Item('tablet', category: electronics);
    final earPhone = Item('ear phone', category: electronics);

    await appdb.transaction((txn) async {
      await txn.registerItem(pen);
      await txn.registerItem(notebook);
      await txn.registerItem(tablet);
      await txn.registerItem(earPhone);
    });

    // orders
    final order1 = Order(user: john);
    order1.itemList.addAll([pen, notebook]);
    order1.cancelledItemList.addAll([earPhone]);
    final order2 = Order(user: jane);
    order2.itemList.addAll([tablet, earPhone]);
    final order3 = Order(user: john);
    order3.itemList.addAll([tablet]);

    final batch = appdb.batch();
    batch.registerOrder(order1);
    batch.registerOrder(order2);
    batch.registerOrder(order3);
    await batch.commit();

    final result = await appdb.queryUser(orderBy: appdb.userHelper.column.name);
    expect(result.length, 2);
    final user1 = result[0];
    expect(user1.name, 'Jane');
    expect(user1.orderList.length, 1);
    final order4 = user1.orderList[0];
    expect(order4.user?.name, jane.name);
    // itemList is ordered by name
    expect(order4.itemList.length, 2);
    expect(order4.itemList[0].name, earPhone.name);
    expect(order4.itemList[0].category?.name, electronics.name);
    expect(order4.itemList[0].colorList.length, 0);
    expect(order4.itemList[0].orderList, isEmpty);
    expect(order4.itemList[1].name, tablet.name);
    expect(order4.itemList[1].category?.name, electronics.name);
    expect(order4.itemList[1].colorList.length, 0);
    expect(order4.itemList[1].orderList, isEmpty);


    final user2 = result[1];
    expect(user2.name, john.name);
    expect(user2.orderList.length, 2);
    // orderList is ordered by id
    final order5 = user2.orderList[0];
    expect(order5.user?.name, john.name);
    expect(order5.itemList.length, 2);
    // itemList is ordered by name
    expect(order5.itemList[0].name, notebook.name);
    expect(order5.itemList[0].category?.name, stationery.name);
    expect(order5.itemList[0].colorList.length, 0);
    expect(order5.itemList[0].orderList, isEmpty);
    expect(order5.itemList[1].name, pen.name);
    expect(order5.itemList[1].category?.name, stationery.name);
    expect(order5.itemList[1].colorList.length, 2);
    // colorList is ordered by id
    expect(order5.itemList[1].colorList[0].name, red.name);
    expect(order5.itemList[1].colorList[1].name, black.name);
    expect(order5.itemList[1].orderList, isEmpty);

    expect(order5.cancelledItemList.length, 1);
    expect(order5.cancelledItemList[0].name, earPhone.name);
    expect(order5.cancelledItemList[0].category?.name, electronics.name);
    expect(order5.cancelledItemList[0].colorList.length, 0);
    expect(order5.cancelledItemList[0].orderList, isEmpty);

    final order6 = user2.orderList[1];
    expect(order6.user?.name, john.name);
    expect(order6.itemList.length, 1);
    expect(order6.itemList[0].name, tablet.name);
    expect(order6.itemList[0].category?.name, electronics.name);
    expect(order6.itemList[0].colorList.length, 0);
    expect(order6.itemList[0].orderList, isEmpty);

    final result2 = await appdb.queryCategory(
      orderBy: appdb.categoryHelper.column.name
    );
    expect(result2.length, 2);
    final category1 = result2[0];
    expect(category1.name, electronics.name);
    expect(category1.itemList.length, 2);
    // category.itemList is ordered by id

    expect(category1.itemList[0].name, tablet.name);
    expect(category1.itemList[0].category?.name, electronics.name);
    expect(category1.itemList[0].colorList.length, 0);
    expect(category1.itemList[0].orderList.length, 2);
    expect(category1.itemList[0].orderList[0].user?.name, jane.name);
    expect(category1.itemList[0].orderList[0].itemList.length, 0);
    expect(category1.itemList[0].orderList[1].user?.name, john.name);
    expect(category1.itemList[0].orderList[1].itemList.length, 0);

    expect(category1.itemList[1].name, earPhone.name);
    expect(category1.itemList[1].category?.name, electronics.name);
    expect(category1.itemList[1].colorList.length, 0);
    expect(category1.itemList[1].orderList.length, 1);
    expect(category1.itemList[1].orderList[0].user?.name, jane.name);
    expect(category1.itemList[1].orderList[0].itemList, isEmpty);

    final category2 = result2[1];
    expect(category2.name, stationery.name);
    expect(category2.itemList.length, 2);
    // category.itemList is ordered by id
    expect(category2.itemList[0].name, pen.name);
    expect(category2.itemList[0].category?.name, stationery.name);
    expect(category2.itemList[0].colorList.length, 2);
    // colorList is ordered by id
    expect(category2.itemList[0].colorList[0].name, red.name);
    expect(category2.itemList[0].colorList[1].name, black.name);
    expect(category2.itemList[0].orderList.length, 1);
    expect(category2.itemList[0].orderList[0].user?.name, john.name);
    expect(category2.itemList[0].orderList[0].itemList, isEmpty);

    expect(category2.itemList[1].name, notebook.name);
    expect(category2.itemList[1].category?.name, stationery.name);
    expect(category2.itemList[1].colorList.length, 0);
    expect(category2.itemList[1].orderList.length, 1);
    expect(category2.itemList[1].orderList[0].user?.name, john.name);
    expect(category2.itemList[1].orderList[0].itemList, isEmpty);


    final result3 = await appdb.queryColor(orderBy: appdb.colorHelper.column.name);
    expect(result3.length, 2);
    final color1 = result3[0];
    expect(color1.name, black.name);
    expect(color1.itemList.length, 1);
    expect(color1.itemList[0].name, pen.name);
    expect(color1.itemList[0].category?.name, stationery.name);
    expect(color1.itemList[0].colorList.length, 0);
    expect(color1.itemList[0].orderList.length, 1);
    expect(color1.itemList[0].orderList[0].user?.name, john.name);
    expect(color1.itemList[0].orderList[0].itemList, isEmpty);
    final color2 = result3[1];
    expect(color2.name, red.name);
    expect(color2.itemList.length, 1);
    expect(color2.itemList[0].name, pen.name);
    expect(color2.itemList[0].category?.name, stationery.name);
    expect(color2.itemList[0].colorList.length, 0);
    expect(color2.itemList[0].orderList.length, 1);
    expect(color2.itemList[0].orderList[0].user?.name, john.name);
    expect(color2.itemList[0].orderList[0].itemList, isEmpty);

    await appdb.deleteOrder();
    await appdb.deleteItem();
    await appdb.deleteCategory();
    await appdb.deleteColor();
    await appdb.deleteUser();
  });
}
