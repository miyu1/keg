// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sole_table_test.dart';

// **************************************************************************
// DatabaseGenerator
// **************************************************************************

abstract class _$AppDatabase implements DatabaseExecutor {
  int get schemaVersion => 1;

  @override
  late Database database;

  late final userHelper = _$UserHelper();
  late final itemInfoHelper = _$ItemInfoHelper();

  Future<String> getPathToOpen();

  Future<void> open() async {
    final path = await getPathToOpen();
    database = await openDatabase(
      path,
      version: schemaVersion,
      onConfigure: onConfigure,
      onCreate: onCreate,
      onUpgrade: onUpgrade,
      onDowngrade: onDowngrade,
      onOpen: onOpen,
    );
  }

  Future<void> onConfigure(Database db) async {
    // do nothing
  }

  Future<void> onCreate(Database db, int version) async {
    final batch = db.batch();
    await userHelper.onCreate(version, batch: batch);
    await itemInfoHelper.onCreate(version, batch: batch);
    await batch.commit();
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    await userHelper.onUpgrade(oldVersion, newVersion, batch: batch);
    await itemInfoHelper.onUpgrade(oldVersion, newVersion, batch: batch);
    await batch.commit();
  }

  Future<void> onDowngrade(Database db, int oldVersion, int newVersion) async {
    throw UnimplementedError();
  }

  Future<void> onOpen(Database db) async {
    // do nothing
  }

  Future<int> registerUser(User item) =>
      userHelper.register(item, db: database);

  Future<List<User>> queryUser({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) => userHelper.query(
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    db: database,
  );

  Future<int> deleteUser(User item) => userHelper.delete(item, db: database);

  Future<int> registerItemInfo(ItemInfo item) =>
      itemInfoHelper.register(item, db: database);

  Future<List<ItemInfo>> queryItemInfo({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) => itemInfoHelper.query(
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    db: database,
  );

  Future<int> deleteItemInfo(ItemInfo item) =>
      itemInfoHelper.delete(item, db: database);

  // pass through methods
  String get path => database.path;

  Future<void> close() => database.close();

  Future<T> transaction<T>(
    Future<T> Function(Transaction txn) action, {
    bool? exclusive,
  }) => database.transaction<T>(action, exclusive: exclusive);

  Future<T> readTransaction<T>(Future<T> Function(Transaction txn) action) =>
      database.readTransaction<T>(action);

  bool get isOpen => database.isOpen;

  @override
  Future<void> execute(String sql, [List<Object?>? arguments]) =>
      database.execute(sql, arguments);

  @override
  Future<int> rawInsert(String sql, [List<Object?>? arguments]) =>
      database.rawInsert(sql, arguments);

  @override
  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) => database.insert(
    table,
    values,
    nullColumnHack: nullColumnHack,
    conflictAlgorithm: conflictAlgorithm,
  );

  @override
  Future<List<Map<String, Object?>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) => database.query(
    table,
    distinct: distinct,
    columns: columns,
    where: where,
    whereArgs: whereArgs,
    groupBy: groupBy,
    having: having,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
  );

  @override
  Future<List<Map<String, Object?>>> rawQuery(
    String sql, [
    List<Object?>? arguments,
  ]) => database.rawQuery(sql, arguments);

  @override
  Future<QueryCursor> rawQueryCursor(
    String sql,
    List<Object?>? arguments, {
    int? bufferSize,
  }) => database.rawQueryCursor(sql, arguments, bufferSize: bufferSize);

  @override
  Future<QueryCursor> queryCursor(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
    int? bufferSize,
  }) => database.queryCursor(
    table,
    distinct: distinct,
    columns: columns,
    where: where,
    whereArgs: whereArgs,
    groupBy: groupBy,
    having: having,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    bufferSize: bufferSize,
  );

  @override
  Future<int> rawUpdate(String sql, [List<Object?>? arguments]) =>
      database.rawUpdate(sql, arguments);

  @override
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) => database.update(
    table,
    values,
    where: where,
    whereArgs: whereArgs,
    conflictAlgorithm: conflictAlgorithm,
  );

  @override
  Future<int> rawDelete(String sql, [List<Object?>? arguments]) =>
      database.rawDelete(sql, arguments);

  @override
  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) =>
      database.delete(table, where: where, whereArgs: whereArgs);

  @override
  Batch batch() => database.batch();
}

// **************************************************************************
// TableGenerator
// **************************************************************************

class _$UserHelper {
  final String tableName = 'user';
  final column = (id: 'id', name: 'name');
  final columnTypes = {
    'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
    'name': 'TEXT NOT NULL DEFAULT ""',
  };
  static final v1ColumnList = ['id', 'name'];
  final columnListByVersion = {1: v1ColumnList};

  /// on create database table
  Future<void> onCreate(
    int version, {
    DatabaseExecutor? db,
    Batch? batch,
  }) async {
    assert((db != null) ^ (batch != null));

    var columnList = [];
    for (var i = 1; i <= version; i++) {
      final oneColumnList = columnListByVersion[i] ?? [];
      columnList.addAll(oneColumnList);
    }
    if (columnList.isEmpty) {
      throw UnsupportedError("No columns defined for User version $version");
    }
    var params = [];
    for (final column in columnList) {
      params.add('$column ${columnTypes[column]}');
    }
    final sql = 'CREATE TABLE IF NOT EXISTS $tableName (${params.join(', ')})';
    print('Creating table: $sql');
    if (db != null) {
      await db.execute(sql);
    } else if (batch != null) {
      batch.execute(sql);
    }
  }

  /// on upgrade database table
  Future<void> onUpgrade(
    int oldVersion,
    int newVersion, {
    DatabaseExecutor? db,
    Batch? batch,
  }) async {
    var columnList = [];
    for (var i = 1; i <= oldVersion; i++) {
      final oneColumnList = columnListByVersion[i] ?? [];
      columnList.addAll(oneColumnList);
    }
    if (columnList.isEmpty) {
      await onCreate(newVersion, db: db, batch: batch);
      return;
    }

    columnList = [];
    for (var i = oldVersion + 1; i <= newVersion; i++) {
      final newColumnList = columnListByVersion[i] ?? [];
      columnList.addAll(newColumnList);
    }
    for (final column in columnList) {
      final sql =
          'ALTER TABLE $tableName ADD COLUMN $column ${columnTypes[column]}';
      print('Altering table: $sql');
      if (db != null) {
        await db.execute(sql);
      } else if (batch != null) {
        batch.execute(sql);
      }
    }
  }

  static Map<String, Object?> toSqlMap(User item) {
    final values = <String, Object?>{};
    if (item.id != 0) {
      values["id"] = item.id;
    }
    values["name"] = item.name;
    return values;
  }

  static User fromSqlMap(Map<String, Object?> map) {
    final keys = map.keys.toSet();
    if (!keys.contains("name")) {
      throw ArgumentError("Missing required key name in map");
    }

    var id = 0;
    if (keys.contains('id')) {
      id = map['id'] as int;
      keys.remove("id");
    }

    final name = map['name'] as String;
    keys.remove("name");

    if (keys.isNotEmpty) {
      throw ArgumentError('Unkown map keys. $keys');
    }

    final item = User(name, id);

    return item;
  }

  Future<int> register(User item, {DatabaseExecutor? db, Batch? batch}) async {
    final map = item.toSqlMap();
    var command = 'REPLACE INTO';
    if (item.id == 0) {
      command = 'INSERT INTO';
    }
    final sql =
        '$command $tableName (${map.keys.join(',')}) VALUES (${List.filled(map.length, '?').join(', ')})';
    print('register sql: $sql');
    print('args: ${map.values.toList()}');
    var id = 0;
    if (db != null) {
      id = await db.rawInsert(sql, map.values.toList());
      item.id = id;
    } else if (batch != null) {
      batch.rawInsert(sql, map.values.toList());
    }
    return id;
  }

  Future<List<User>> query({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    DatabaseExecutor? db,
    Batch? batch,
  }) async {
    if (db != null) {
      final result = await db.query(
        tableName,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );
      return result.map((entry) => User.fromSqlMap(entry)).toList();
    }
    return [];
  }

  Future<int> delete(User item, {DatabaseExecutor? db, Batch? batch}) async {
    if (db != null) {
      final id = await db.delete(
        tableName,
        where: '${column.id} = ?',
        whereArgs: [item.id],
      );
      return id;
    }
    return -1;
  }
}

class _$ItemInfoHelper {
  final String tableName = 'item_info';
  final column = (
    id: 'id',
    name: 'name',
    stock: 'stock',
    color: 'color',
    weight: 'weight',
    isActive: 'is_active',
    created: 'created',
  );
  final columnTypes = {
    'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
    'name': 'TEXT NOT NULL DEFAULT ""',
    'stock': 'INTEGER NOT NULL DEFAULT 0',
    'color': 'TEXT NOT NULL DEFAULT "${Color.values[0].name}"',
    'weight': 'REAL NOT NULL DEFAULT 0.0',
    'is_active': 'INTEGER NOT NULL DEFAULT 0',
    'created': 'INTEGER NOT NULL DEFAULT 0',
  };
  static final v1ColumnList = [
    'id',
    'name',
    'stock',
    'color',
    'weight',
    'is_active',
    'created',
  ];
  final columnListByVersion = {1: v1ColumnList};

  /// on create database table
  Future<void> onCreate(
    int version, {
    DatabaseExecutor? db,
    Batch? batch,
  }) async {
    assert((db != null) ^ (batch != null));

    var columnList = [];
    for (var i = 1; i <= version; i++) {
      final oneColumnList = columnListByVersion[i] ?? [];
      columnList.addAll(oneColumnList);
    }
    if (columnList.isEmpty) {
      throw UnsupportedError(
        "No columns defined for ItemInfo version $version",
      );
    }
    var params = [];
    for (final column in columnList) {
      params.add('$column ${columnTypes[column]}');
    }
    final sql = 'CREATE TABLE IF NOT EXISTS $tableName (${params.join(', ')})';
    print('Creating table: $sql');
    if (db != null) {
      await db.execute(sql);
    } else if (batch != null) {
      batch.execute(sql);
    }
  }

  /// on upgrade database table
  Future<void> onUpgrade(
    int oldVersion,
    int newVersion, {
    DatabaseExecutor? db,
    Batch? batch,
  }) async {
    var columnList = [];
    for (var i = 1; i <= oldVersion; i++) {
      final oneColumnList = columnListByVersion[i] ?? [];
      columnList.addAll(oneColumnList);
    }
    if (columnList.isEmpty) {
      await onCreate(newVersion, db: db, batch: batch);
      return;
    }

    columnList = [];
    for (var i = oldVersion + 1; i <= newVersion; i++) {
      final newColumnList = columnListByVersion[i] ?? [];
      columnList.addAll(newColumnList);
    }
    for (final column in columnList) {
      final sql =
          'ALTER TABLE $tableName ADD COLUMN $column ${columnTypes[column]}';
      print('Altering table: $sql');
      if (db != null) {
        await db.execute(sql);
      } else if (batch != null) {
        batch.execute(sql);
      }
    }
  }

  static Map<String, Object?> toSqlMap(ItemInfo item) {
    final values = <String, Object?>{};
    if (item.id != 0) {
      values["id"] = item.id;
    }
    values["name"] = item.name;
    values["stock"] = item.stock;
    values["color"] = item.color.name;
    values["weight"] = item.weight;
    values["is_active"] = item.isActive ? 1 : 0;
    values["created"] = item.created.toUtc().microsecondsSinceEpoch;
    return values;
  }

  static ItemInfo fromSqlMap(Map<String, Object?> map) {
    final keys = map.keys.toSet();
    final params = <String, Object>{};
    if (!keys.contains("name")) {
      throw ArgumentError("Missing required key name in map");
    }
    if (!keys.contains("color")) {
      throw ArgumentError("Missing required key color in map");
    }
    if (!keys.contains("weight")) {
      throw ArgumentError("Missing required key weight in map");
    }

    var id = 0;
    if (keys.contains('id')) {
      id = map['id'] as int;
      keys.remove("id");
    }

    final name = map['name'] as String;
    keys.remove("name");

    var stock = 0;
    if (keys.contains('stock')) {
      stock = map['stock'] as int;
      keys.remove("stock");
    }

    final color = Color.values.byName(map['color'] as String);
    keys.remove("color");

    final weight = map['weight'] as double;
    keys.remove("weight");

    var isActive = true;
    if (keys.contains('is_active')) {
      isActive = (map['is_active'] as int) == 0 ? false : true;
      keys.remove("is_active");
    }

    if (keys.contains('created')) {
      params['created'] = DateTime.fromMicrosecondsSinceEpoch(
        map['created'] as int,
      ).toLocal();
      keys.remove("created");
    }

    if (keys.isNotEmpty) {
      throw ArgumentError('Unkown map keys. $keys');
    }

    final item = ItemInfo(
      name,
      id: id,
      stock: stock,
      color: color,
      weight: weight,
      isActive: isActive,
    );

    if (params.containsKey('created')) {
      item.created = params['created'] as DateTime;
    }
    return item;
  }

  Future<int> register(
    ItemInfo item, {
    DatabaseExecutor? db,
    Batch? batch,
  }) async {
    final map = item.toSqlMap();
    var command = 'REPLACE INTO';
    if (item.id == 0) {
      command = 'INSERT INTO';
    }
    final sql =
        '$command $tableName (${map.keys.join(',')}) VALUES (${List.filled(map.length, '?').join(', ')})';
    print('register sql: $sql');
    print('args: ${map.values.toList()}');
    var id = 0;
    if (db != null) {
      id = await db.rawInsert(sql, map.values.toList());
      item.id = id;
    } else if (batch != null) {
      batch.rawInsert(sql, map.values.toList());
    }
    return id;
  }

  Future<List<ItemInfo>> query({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    DatabaseExecutor? db,
    Batch? batch,
  }) async {
    if (db != null) {
      final result = await db.query(
        tableName,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );
      return result.map((entry) => ItemInfo.fromSqlMap(entry)).toList();
    }
    return [];
  }

  Future<int> delete(
    ItemInfo item, {
    DatabaseExecutor? db,
    Batch? batch,
  }) async {
    if (db != null) {
      final id = await db.delete(
        tableName,
        where: '${column.id} = ?',
        whereArgs: [item.id],
      );
      return id;
    }
    return -1;
  }
}
