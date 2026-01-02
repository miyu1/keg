import 'dart:io';
import 'package:keg_annotation/keg_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

part 'empty_database_test.g.dart';

@KegDatabase(tables: [])
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
    await appdb.close();
    
    final dir = await getDatabasesPath();
    final path = p.join(dir, 'app.db');
    print('file path: $path');
    final f = File(path);
    await f.delete();

  });

  test('check empty database', () async {
    expect(appdb.isOpen, true);
    expect(appdb.schemaVersion, 1);

    var result = await appdb.rawQuery('pragma schema_version');
    // print(result);
    expect(result.length, 1);
    var version = result[0]['schema_version'];
    expect(version, 0); // no table yet, so version is 0

    result = await appdb.rawQuery('pragma user_version');
    // print(result);
    expect(result.length, 1);
    version = result[0]['user_version'];
    expect(version, 1); // no table yet, so version is 0
  });
}
