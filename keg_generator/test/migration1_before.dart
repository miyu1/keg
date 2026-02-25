import 'package:test/test.dart';

import 'package:keg_annotation/keg_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

part 'migration1_before.g.dart';

@Table()
class ItemInfo {
  int id;

  @unique
  String name;

  ItemInfo(
    this.name, {
    this.id = 0,
  });

  Map<String, Object?> toSqlMap() => _$ItemInfoHelper.toSqlMap(this);
  factory ItemInfo.fromSqlMap(Map<String, Object?> map) =>
      _$ItemInfoHelper.fromSqlMap(map);
}

@KegDatabase(tables: [ItemInfo], schemaVersion: 1)
class AppDatabase extends _$AppDatabase {
  @override
  Future<String> getPathToOpen() async {
    // Implement your logic to get the database path
    return 'migration1.db';
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

  test('before migration1', () async {
    await appdb.open();

    expect(appdb.schemaVersion, 1);

    final result = await appdb.rawQuery('pragma user_version');
    // print(result);

    expect(result.length, 1);
    final version = result[0]['user_version'];
    expect(version, 1);

    final item = ItemInfo('notebook');
    await appdb.registerItemInfo(item);
    expect(item.id, greaterThan(0));

    final result2 = await appdb.queryItemInfo();
    expect(result2.length, 1);
    expect(result2[0].name, item.name);
    expect(result2[0].id, item.id);
  });

}
