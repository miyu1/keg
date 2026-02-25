import 'dart:io';

import 'package:keg_annotation/keg_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

part 'index_test.g.dart';

@table
class User {
  int id;

  @unique
  String name;

  @Index(unique: false, descendant: true)
  DateTime updated = DateTime.now();

  @index
  String contact;

  User(this.name, {this.contact = '', this.id = 0});

  Map<String, Object?> toSqlMap() => _$UserHelper.toSqlMap(this);
  factory User.fromSqlMap(Map<String, Object?> map) =>
      _$UserHelper.fromSqlMap(map);

}

@KegDatabase(tables: [User])
class AppDatabase extends _$AppDatabase {
  @override
  Future<String> getPathToOpen() async {
    // Implement your logic to get the database path
    return 'index.db';
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
    final f = File(path);
    await f.delete();
  });

  test('check if index is created', () async {
    final result = await appdb.rawQuery(
        "SELECT * FROM sqlite_master WHERE type='index' AND name='user_name_idx'");
    expect(result.length, 1);
    expect(result[0]['name'], 'user_name_idx');
    expect(result[0]['tbl_name'], 'user');
    expect(result[0]['sql'], contains('UNIQUE'));
    expect(result[0]['sql'], contains('("name" ASC)'));

    final result2 = await appdb.rawQuery(
        "SELECT * FROM sqlite_master WHERE type='index' AND name='user_updated_idx'");
    expect(result2.length, 1);
    expect(result2[0]['name'], 'user_updated_idx');
    expect(result2[0]['tbl_name'], 'user');
    expect(result2[0]['sql'], isNot(contains('UNIQUE')));
    expect(result2[0]['sql'], contains('("updated" DESC)'));

    final result3 = await appdb.rawQuery(
        "SELECT * FROM sqlite_master WHERE type='index' AND name='user_contact_idx'");
    expect(result3.length, 1);
    expect(result3[0]['name'], 'user_contact_idx');
    expect(result3[0]['tbl_name'], 'user');
    expect(result3[0]['sql'], isNot(contains('UNIQUE')));
    expect(result3[0]['sql'], contains('("contact" ASC)'));

  });

  test('check unique constraint', () async {
    final user1 = User('John', contact: 'john@example.com');
    await appdb.registerUser(user1);  

    final user2 = User('John', contact: 'john2@example.com');
    expect(() async => appdb.registerUser(user2), throwsA(isA<DatabaseException>()));
  });
}