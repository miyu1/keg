import 'dart:io';
import 'package:test/test.dart';

import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'common.dart';

void main() {
  databaseFactory = databaseFactoryFfi;

  tearDownAll(() async {
    final dir = await getDatabasesPath();
    final path = p.join(dir, 'migration2.db');
    print('deleting file: $path');
    await databaseFactory.deleteDatabase(path);
  });

  test('before migration2', () async {
    await testGenerator('migration2_before');
  });

  test('after migration2. delete g.dart and read v1ColumnInfo from ItemInfo.', () async {
    File file = File('test/migration2_after.g.dart');
    if (file.existsSync()) {
      file.deleteSync();
    }
    await testGenerator('migration2_after');
  });

}