import 'dart:io';
import 'dart:async';

import 'package:keg_annotation/keg_annotation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

part 'batch_test.g.dart';

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
    return 'batch.db';
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

  test('throw error in batch', () async {
    final batch1 = appdb.batch();
    batch1.queryUser();
    final result1 = await batch1.commit();

    expect(result1.length, 1);
    expect(result1[0] is List<User>, true);
    final res1 = result1[0] as List<User>;
    expect(res1, isEmpty);

    expect(failureCode(appdb), throwsStateError);

    final result = await appdb.queryUser();
    expect(result, isEmpty);

  });

  test('batch normal end', () async {
    final result = await appdb.queryUser();
    expect(result, isEmpty);

    final user1 = User('Mike');
    final user2 = User('Jack');
    expect(user1.id, 0);
    expect(user2.id, 0);

    final batch1 = appdb.batch();
    batch1.registerUser(user1);
    batch1.registerUser(user2);
    final result1 = await batch1.apply();

    expect(result1.length, 2);
    expect(result1[0] is int, true);
    expect(result1[1] is int, true);
    expect(user1.id, greaterThan(0));
    expect(user2.id, greaterThan(0));

    final result2 = await appdb.queryUser();
    expect(result2.length, 2);

    expect(result2.where((user) => user.name == 'Mike').length, 1);
    expect(result2.where((user) => user.name == 'Jack').length, 1);
    expect(result2.where((user) => user.name == 'Mary').length, 0);

    final batch3 = appdb.batch();
    batch3.getUser(user1.id);
    final result3 = await batch3.commit();
    final user3 = result3[0] as User?;
    expect(user3, isNotNull);
    expect(user3?.id, user1.id);
    expect(user3?.name, user1.name);

    final batch4 = appdb.batch();
    batch4.deleteUserByIds([user1]);
    batch4.deleteUserByIds([user2]);
    final result4 = await batch4.commit();
    expect(result4.length, 2);
    expect(result4[0], 1);
    expect(result4[1], 1);

    final batch5 = appdb.batch();
    batch5.queryUser();
    batch5.getUser(user1.id);
    final result5 = await batch5.commit();
    expect(result5.length, 2);
    final list5 = result5[0] as List<User>;
    expect(list5, isEmpty);
    final user5 = result5[1] as User?;
    expect(user5, isNull);
  });

  test('batch no result', () async {
    // query: throws
    final batch1 = appdb.batch();
    batch1.queryUser();
    expect(batch1.commit(noResult: true), throwsStateError);

    // when id is 0, register cannot set id
    final user2 = User('Mike');
    final batch2 = appdb.batch();
    batch2.registerUser(user2);
    expect(batch2.commit(noResult: true), throwsStateError);
    //final result2 = await batch2.apply(noResult: true);
    //expect(result2, isEmpty);
    //expect(user2.id, 0); // !!

    // when id is not 0, register ends normally
    final user3 = User('Jane', 10);
    final batch3 = appdb.batch();
    batch3.registerUser(user3);
    final result3 = await batch3.commit(noResult: true);
    expect(result3, isEmpty);

    // get: throws
    final batch4 = appdb.batch();
    batch4.getUser(user3.id);
    expect(batch4.commit(noResult: true), throwsStateError);

    // delete ends normally
    final batch5 = appdb.batch();
    batch5.deleteUserByIds([user3]);
    final result5 = await batch5.commit(noResult: true);
    expect(result5, isEmpty);

    // delete throws when id is 0
    final batch6 = appdb.batch();
    expect(() => batch6.deleteUserByIds([user2]), throwsArgumentError);

    // delete ends normally 2
    final result7 = await appdb.queryUser();
    final batch7 = appdb.batch();
    for(final user in result7) {
      batch7.deleteUserByIds([user]);
    }
    await batch7.commit(noResult: true);
    
    final result8 = await appdb.queryUser();
    expect(result8, isEmpty);
  });

}

Future<int> failureCode(AppDatabase appdb) async {
  bool error = false;

  final user1 = User('Mike');
  final user2 = User('Jack');

  if (user1.name == 'Mike') {
    error = true;
  }

  final batch2 = appdb.batch();

  batch2.registerUser(user1);
  batch2.registerUser(user2);
  if (error) {
    throw StateError('abort batch');
  }
  await batch2.commit();

  return 0;
}