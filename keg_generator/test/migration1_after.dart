import 'package:keg_annotation/keg_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

part 'migration1_after.g.dart';

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

@KegDatabase(tables: [User, ItemInfo], schemaVersion: 2)
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
  });

  test('after migration1', () async {
    await appdb.open();

    expect(appdb.schemaVersion, 2);

    final result = await appdb.rawQuery('pragma user_version');
    // print(result);

    expect(result.length, 1);
    final version = result[0]['user_version'];
    expect(version, 2);

    final result2 = await appdb.queryItemInfo();
    expect(result2.length, 1);
    expect(result2[0].name, 'notebook');
    expect(result2[0].stock, 0);
    expect(result2[0].color, Color.red);
    expect(result2[0].weight, 0.0);
    expect(result2[0].isActive, false);
    expect(result2[0].created, DateTime.fromMicrosecondsSinceEpoch(0));

    final now = DateTime.now();
    print('now: $now');
    final item = ItemInfo('pen', weight: 10.5, color: Color.blue);
    print('created: ${item.created}');
    await appdb.registerItemInfo(item);
    expect(item.id, greaterThan(0));

    final result3 = await appdb.queryItemInfo(
      where: '${appdb.itemInfoHelper.column.name} = ?',
      whereArgs: [item.name]);
    expect(result3.length, 1);
    expect(result3[0].id, item.id);
    expect(result3[0].name, item.name);
    expect(result3[0].stock, item.stock);
    expect(result3[0].color, item.color);
    expect(result3[0].weight, item.weight);
    expect(result3[0].isActive, item.isActive);
    expect(result3[0].created.isAfter(now), true);

    final user = User('John');
    await appdb.registerUser(user);

    final result4 = await appdb.queryUser();
    expect(result4.length, 1);
    expect(result4[0].name, user.name);
    expect(result4[0].id, user.id);
  });

}
