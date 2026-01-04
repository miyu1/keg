import 'dart:io';
import 'package:test/test.dart';

import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'common.dart';

void main() {
  databaseFactory = databaseFactoryFfi;

  tearDownAll(() async {
    final dir = await getDatabasesPath();
    final path = p.join(dir, 'app.db');
    print('deleting file: $path');
    final f = File(path);
    await f.delete();
  });

  test('before migration1', () async {
    await testGenerator('migration2_before');
  });

  test('after migration1', () async {
    File file = File('test/migration2_after.g.dart');
    if (file.existsSync()) {
      file.deleteSync();
    }
    await testGenerator('migration2_after');
  });

}