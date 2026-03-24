import 'package:keg_annotation/keg_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'localdb.g.dart';

@table
class User {
  int id;
  @unique
  String name;

  @BackLink(to: 'user', order: 'created', descendant: true)
  List<Order> orderList = [];

  User(this.name, {this.id = 0});
  Map<String, Object?> toSqlMap() => _$UserHelper.toSqlMap(this);
  factory User.fromSqlMap(Map<String, Object?> map) =>
      _$UserHelper.fromSqlMap(map);
}

@table
class Order {
  int id;
  @index
  User? user;
  @Index(descendant: true)
  DateTime created = DateTime.now();

  @ManyToMany(middle: OrderToItem, self: 'order', target: 'item', order: 'name')
  List<Item> itemList = [];

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
class Item {
  int id;
  @unique
  String name;
  @index
  Category? category;

  @BackLink(to: 'itemList')
  List<Order> orderList = [];

  Item(this.name, {this.category, this.id = 0});

  Map<String, Object?> toSqlMap() => _$ItemHelper.toSqlMap(this);
  factory Item.fromSqlMap(Map<String, Object?> map) =>
      _$ItemHelper.fromSqlMap(map);
}

@table
class OrderToItem {
  int id;
  @index
  Order? order;
  @index
  Item? item;
  @index
  String field;

  OrderToItem({required this.field, this.order, this.item, this.id = 0});

  Map<String, Object?> toSqlMap() => _$OrderToItemHelper.toSqlMap(this);
  factory OrderToItem.fromSqlMap(Map<String, Object?> map) =>
      _$OrderToItemHelper.fromSqlMap(map);
}

@KegDatabase(tables: [User, Order, Category, Item, OrderToItem])
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

Future<void> setInitialContents(AppDatabase appdb) async {
  var stationary = Category('Stationary');
  var result = await appdb.queryCategory(
    where: '${appdb.categoryHelper.column.name} = ?',
    whereArgs: ['Stationary']
  );
  if (result.isNotEmpty) {
    stationary = result.first;
  } else {
    await appdb.registerCategory(stationary);
  }
  if (stationary.itemList.isEmpty) {
    final pen = Item('pen', category: stationary);
    final notebook = Item('notebook', category: stationary);
    final postit = Item('post it', category: stationary);
    await appdb.registerItem(pen);
    await appdb.registerItem(notebook);
    await appdb.registerItem(postit);
  }

  var electronics = Category('Electronics');
  result = await appdb.queryCategory(
    where: '${appdb.categoryHelper.column.name} = ?',
    whereArgs: ['Electronics']
  );
  if (result.isNotEmpty) {
    electronics = result.first;
  } else {
    await appdb.registerCategory(electronics);
  }
  if (electronics.itemList.isEmpty) {
    final smartphone = Item('smart phone', category: electronics);
    final tablet = Item('tablet', category: electronics);
    final touchpen = Item('touch pen', category: electronics);
    final headphone = Item('headphone', category: electronics);
    await appdb.registerItem(smartphone);
    await appdb.registerItem(tablet);
    await appdb.registerItem(touchpen);
    await appdb.registerItem(headphone);
  }

  var fureniture = Category('Furniture');
  result = await appdb.queryCategory(
    where: '${appdb.categoryHelper.column.name} = ?',
    whereArgs: ['Furniture']
  );
  if (result.isNotEmpty) {
    fureniture = result.first;
  } else {
    await appdb.registerCategory(fureniture);
  }
  if (fureniture.itemList.isEmpty) {
    final chair = Item('chair', category: fureniture);
    final desk = Item('desk', category: fureniture);
    final light = Item('light', category: fureniture);
    await appdb.registerItem(chair);
    await appdb.registerItem(desk);
    await appdb.registerItem(light);
  }

  var mike = User('Mike');
  final result2 = await appdb.queryUser(
    where: '${appdb.userHelper.column.name} = ?',
    whereArgs: ['Mike']
  );
  if (result2.isNotEmpty)  {
    mike = result2.first;
  } else {
    await appdb.registerUser(mike);
  }
  if (mike.orderList.isEmpty) {
    final order1 = Order(user: mike);
    order1.created = DateTime(2026, 3, 15);
    var result3 = await appdb.queryItem(
      where: '${appdb.itemHelper.column.name} = ?',
      whereArgs: ['pen']
    );
    order1.itemList.addAll(result3);
    await appdb.registerOrder(order1);
  }
}

@riverpod
Future<AppDatabase> appDatabase(Ref ref) async {
  final db = AppDatabase();
  print('Opening database...');
  await db.open();
  print('Database path: ${db.path}');

  ref.onDispose(() async {
    print('Closing database...');
    if (ref.mounted) {
      await db.close();
    }
  });

  await setInitialContents(db);
  return db;
}

@riverpod
Future<List<Category>> categoryList(Ref ref) async {
  final appdb = await ref.watch(appDatabaseProvider.future);
  return await appdb.queryCategory(
    orderBy: appdb.categoryHelper.column.name
  );
}

@riverpod
Future<List<User>> userList(Ref ref) async {
  final appdb = await ref.watch(appDatabaseProvider.future);
  return await appdb.queryUser(
    orderBy: appdb.userHelper.column.name
  );
}

@riverpod
Future<User> user(Ref ref, String name) async {
  final appdb = await ref.watch(appDatabaseProvider.future);
  final result = await appdb.queryUser(
    where: '${appdb.userHelper.column.name} = ?',
    whereArgs: [name]
  );
  if (result.isEmpty) {
    throw Exception('User not found');
  }
  return result.first;
}
