import 'dart:io';
import 'package:test/test.dart';

import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'common.dart';

void main() {
  databaseFactory = databaseFactoryFfi;

  tearDownAll(() async {
    final dir = await getDatabasesPath();
    final path = p.join(dir, 'migration1.db');
    print('deleting file: $path');
    await databaseFactory.deleteDatabase(path);
  });

  test('before migration1', () async {
    await testGenerator('migration1_before');
  });

  test('after migration1. read previous g.dart to check table change', () async {
    final file = File('test/migration1_before.g.dart');
    final content = file.readAsStringSync();
    final lines = content.split('\n');
    lines[0] = "part of 'migration1_after.dart';";

    File file2 = File('test/migration1_after.g.dart');
    file2.writeAsStringSync(lines.join('\n'));
    await testGenerator('migration1_after');
  });

}