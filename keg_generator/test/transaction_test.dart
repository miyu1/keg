import 'dart:io';

import 'package:keg_annotation/keg_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

part 'transaction_test.g.dart';

@Table()
class User {
  int id;
  String name;

  User(this.name, [this.id = 0]);

  Map<String, Object?> toSqlMap() => _$UserHelper.toSqlMap(this);
  factory User.fromSqlMap(Map<String, Object?> map) =>
      _$UserHelper.fromSqlMap(map);
}

@KegDatabase(tables: [User])
class AppDatabase extends _$AppDatabase {
  @override
  Future<String> getPathToOpen() async {
    // Implement your logic to get the database path
    return 'transaction.db';
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

  test('throw error in transaction', () async {
    await appdb.readTransaction((txn) async {
      final result = await txn.queryUser();
      expect(result.length, 0);
    });

    final user1 = User('Mike');
    final user2 = User('Jack');

    expect(appdb.transaction((txn) async {
      await txn.registerUser(user1);
      await txn.registerUser(user2);
      throw StateError('abort transaction');
    }), throwsStateError);

    await appdb.readTransaction((txn) async {
      final result = await txn.queryUser();
      expect(result.length, 0);
    });
  });

  test('transaction normal end', () async {
    await appdb.readTransaction((txn) async {
      final result = await txn.queryUser();
      expect(result.length, 0);
    });

    final user1 = User('Mike');
    final user2 = User('Jack');

    await appdb.transaction((txn) async {
      await txn.registerUser(user1);
      await txn.registerUser(user2);
    });
    expect(user1.id, greaterThan(0));
    expect(user2.id, greaterThan(0));

    await appdb.readTransaction((txn) async {
      final result = await txn.queryUser();
      expect(result.length, 2);

      expect(result.where((user) => user.name == 'Mike').length, 1);
      expect(result.where((user) => user.name == 'Jack').length, 1);
      expect(result.where((user) => user.name == 'Mary').length, 0);

      final user3 = await txn.getUser(user1.id);
      expect(user3, isNotNull);
      expect(user3?.id, user1.id);
      expect(user3?.name, user1.name);
    });

    await appdb.transaction((txn) async {
      await txn.deleteUserByIds([user1, user2]);
      //await txn.deleteUser(user2);
    });

    await appdb.readTransaction((txn) async {
      final result = await txn.queryUser();
      expect(result, isEmpty);

      final user4 = await txn.getUser(user1.id);
      expect(user4, isNull);
    });
  });  

}
