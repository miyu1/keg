import 'package:keg_annotation/keg_annotation.dart' as keg;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

part 'ignore_test.g.dart';

@keg.Table()
class User {
  int id;
  String name;

  @keg.ignore
  String sir;

  @keg.ignore
  List<String> get tags {
    return ['tag1', 'tag2'];
  }

  @keg.ignore
  set tags(List<String> value) {
    // do nothing
  }

  User(this.name, {this.sir = '', this.id = 0});

  Map<String, Object?> toSqlMap() => _$UserHelper.toSqlMap(this);
  factory User.fromSqlMap(Map<String, Object?> map) =>
      _$UserHelper.fromSqlMap(map);
}

@keg.KegDatabase(tables: [User])
class AppDatabase extends _$AppDatabase {
  @override
  Future<String> getPathToOpen() async {
    // Implement your logic to get the database path
    return 'ignore.db';
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
    await databaseFactory.deleteDatabase(path);
  });

  test('map conversion', (){
    final user1 = User('Smith', sir: 'Mr');
    final map1 = user1.toSqlMap();
    expect(map1.keys.contains('sir'), false);

    final user2 = User.fromSqlMap(map1);
    expect(user2.name, user1.name);
    expect(user2.id, user1.id);
    expect(user2.sir, isEmpty);
  });

  test('register', () async {
    final user1 = User('Smith', sir: 'Mr');
    await appdb.registerUser(user1);

    final user2 = await appdb.getUser(user1.id);
    expect(user2, isNotNull);
    expect(user2?.id, user1.id);
    expect(user2?.name, user1.name);
    expect(user2?.sir, isEmpty);
  });
}