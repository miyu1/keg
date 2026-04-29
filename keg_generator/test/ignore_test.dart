import 'package:keg_annotation/keg_annotation.dart' as keg;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:test/test.dart';

part 'ignore_test.g.dart';

@keg.Table()
class User {
  int id;
  String name;

  // final field not included in constructor
  final String key = 'abcde';

  static String staticField = 'hijkl';

  @keg.ignore
  String sir;

  String tagStr = '';

  List<String> _tagList = [];
  @keg.ignore
  List<String> get tagList {
    // final ret = tagStr.split(',');

    // return ret.map((e) => e.trim()).toList();
    return _tagList;
  }

  //@keg.ignore
  set tagList(List<String> value) {
    // _tagStr = value.join(',');
    _tagList = value;
  }

  String get getterOnly => 'Xyz';

  set setterOnly(String value) {
    // do nothing
  }

  User(this.name, {this.sir = '', this.id = 0});

  Map<String, Object?> toSqlMap() {
    tagStr = _tagList.join(',');
    return _$UserHelper.toSqlMap(this);
  } 
  factory User.fromSqlMap(Map<String, Object?> map) {
    final ret = _$UserHelper.fromSqlMap(map);
    ret._tagList = ret.tagStr.split(',');
    return ret;
  }
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
    user1.tagList.addAll(['tag1', 'tag2']);
    final map1 = user1.toSqlMap();

    expect(map1.keys.contains('sir'), false);
    expect(map1.keys.contains('tag_list'), false);
    expect(map1.keys.contains('_tag_list'), false);
    expect(map1.keys.contains('getter_only'), false);
    expect(map1.keys.contains('setter_only'), false);
    expect(map1.keys.contains('static_field'), false);
    expect(map1['key'], 'abcde');
    expect(map1['tag_str'], 'tag1,tag2');

    final user2 = User.fromSqlMap(map1);
    expect(user2.name, user1.name);
    expect(user2.id, user1.id);
    expect(user2.sir, isEmpty);
    expect(user2.key, 'abcde');
    expect(user2.tagList, contains('tag1'));
    expect(user2.tagList, contains('tag2'));
  });

  test('register', () async {
    final user1 = User('Smith', sir: 'Mr');
    user1.tagList.add('a');
    await appdb.registerUser(user1);

    final user2 = await appdb.getUser(user1.id);
    expect(user2, isNotNull);
    expect(user2?.id, user1.id);
    expect(user2?.name, user1.name);
    expect(user2?.sir, isEmpty);
    expect(user2?.tagList.length, 1);
    expect(user2?.tagList, contains('a'));
  });
}