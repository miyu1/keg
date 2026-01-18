// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'one_to_many_test.dart';

// **************************************************************************
// DatabaseGenerator
// **************************************************************************

abstract class _$AppDatabaseExecutor extends DatabaseExecutor {
  @override
  _$AppDatabaseBatchWrapper batch();

  /// Insert or update Category.
  /// If id is 0, insert and sets id to generated value.
  /// If specified id already exists in table, update the record.
  /// If specified id does not exist in table, insert with the id.
  Future<int> registerCategory(Category item);

  Future<List<Category>> queryCategory({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  });

  Future<Category?> getCategory(int id);

  Future<int> deleteCategory(Category item);

  /// Insert or update Item.
  /// If id is 0, insert and sets id to generated value.
  /// If specified id already exists in table, update the record.
  /// If specified id does not exist in table, insert with the id.
  Future<int> registerItem(Item item);

  Future<List<Item>> queryItem({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  });

  Future<Item?> getItem(int id);

  Future<int> deleteItem(Item item);
}

class _$AppDatabaseTransactionWrapper implements _$AppDatabaseExecutor {
  _$AppDatabase appdb;
  Transaction transaction;

  _$AppDatabaseTransactionWrapper(this.appdb, this.transaction);

  @override
  Database get database => transaction.database;

  @override
  _$AppDatabaseBatchWrapper batch() {
    final batch = transaction.batch();
    final wrapper = _$AppDatabaseBatchWrapper(appdb, this, batch);
    return wrapper;
  }

  @override
  Future<int> registerCategory(Category item) =>
      appdb.categoryHelper.register(item, db: this);

  @override
  Future<List<Category>> queryCategory({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) => appdb.categoryHelper.query(
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    db: this,
  );

  @override
  Future<Category?> getCategory(int id) =>
      appdb.categoryHelper.get(id, db: this);

  @override
  Future<int> deleteCategory(Category item) =>
      appdb.categoryHelper.delete(item, db: this);

  @override
  Future<int> registerItem(Item item) =>
      appdb.itemHelper.register(item, db: this);

  @override
  Future<List<Item>> queryItem({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) => appdb.itemHelper.query(
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    db: this,
  );

  @override
  Future<Item?> getItem(int id) => appdb.itemHelper.get(id, db: this);

  @override
  Future<int> deleteItem(Item item) => appdb.itemHelper.delete(item, db: this);

  // passthrough methods
  @override
  Future<void> execute(String sql, [List<Object?>? arguments]) =>
      transaction.execute(sql, arguments);

  @override
  Future<int> rawInsert(String sql, [List<Object?>? arguments]) =>
      transaction.rawInsert(sql, arguments);

  @override
  Future<int> insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
  }) => transaction.insert(
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
  }) => transaction.query(
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
  ]) => transaction.rawQuery(sql, arguments);

  @override
  Future<QueryCursor> rawQueryCursor(
    String sql,
    List<Object?>? arguments, {
    int? bufferSize,
  }) => transaction.rawQueryCursor(sql, arguments, bufferSize: bufferSize);

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
  }) => transaction.queryCursor(
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
      transaction.rawUpdate(sql, arguments);

  @override
  Future<int> update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
  }) => transaction.update(
    table,
    values,
    where: where,
    whereArgs: whereArgs,
    conflictAlgorithm: conflictAlgorithm,
  );

  @override
  Future<int> rawDelete(String sql, [List<Object?>? arguments]) =>
      transaction.rawDelete(sql, arguments);

  @override
  Future<int> delete(String table, {String? where, List<Object?>? whereArgs}) =>
      transaction.delete(table, where: where, whereArgs: whereArgs);
}

class _$AppDatabaseBatchWrapper implements Batch {
  _$AppDatabase appdb; // used for refer helpers
  _$AppDatabaseExecutor executor; // database or transaction used for exec sqls
  Batch batch;
  int callBackIndex = 0;
  Map<int, List<Future<Object?> Function(bool? noResult, Object?)>> callBacks =
      {};

  _$AppDatabaseBatchWrapper(this.appdb, this.executor, this.batch);

  void _addCallBack(
    int index,
    Future<Object?> Function(bool? noResult, Object?) callback,
  ) {
    var callBackList = callBacks[index];
    if (callBackList == null) {
      callBackList = [];
      callBacks[index] = callBackList;
    }
    callBackList.add(callback);
  }

  Future<List<Object?>> _execCallBacks(
    List<Object?> result,
    bool? noResult,
  ) async {
    for (final index in callBacks.keys) {
      Object? object;
      if (index < result.length) {
        object = result[index];
      }
      final callbackList = callBacks[index];
      if (callbackList == null) {
        continue;
      }
      for (final callback in callbackList) {
        object = await callback(noResult, object);
      }
      if (index < result.length) {
        result[index] = object;
      }
    }
    return result;
  }

  @override
  Future<List<Object?>> commit({
    bool? exclusive,
    bool? noResult,
    bool? continueOnError,
  }) async {
    var result = await batch.commit(
      exclusive: exclusive,
      noResult: noResult,
      continueOnError: continueOnError,
    );

    result = result.toList(); // read only list to writable list
    result = await _execCallBacks(result, noResult);
    callBacks = {};
    callBackIndex = 0;

    return result;
  }

  @override
  Future<List<Object?>> apply({bool? noResult, bool? continueOnError}) async {
    var result = await batch.apply(
      noResult: noResult,
      continueOnError: continueOnError,
    );

    result = result.toList(); // read only list to writable list
    result = await _execCallBacks(result, noResult);
    callBacks = {};
    callBackIndex = 0;

    return result;
  }

  void registerCategory(
    Category item, [
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    appdb.categoryHelper.register(item, batch: this);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void queryCategory({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.categoryHelper.query(
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
      batch: this,
    );
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void getCategory(
    int id, [
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    appdb.categoryHelper.get(id, batch: this);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void deleteCategory(Category item) =>
      appdb.categoryHelper.delete(item, batch: this);

  void registerItem(
    Item item, [
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    appdb.itemHelper.register(item, batch: this);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void queryItem({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.itemHelper.query(
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
      batch: this,
    );
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void getItem(
    int id, [
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    appdb.itemHelper.get(id, batch: this);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void deleteItem(Item item) => appdb.itemHelper.delete(item, batch: this);

  // pass through methods
  @override
  int get length => batch.length;

  @override
  void rawInsert(
    String sql, [
    List<Object?>? arguments,
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    batch.rawInsert(sql, arguments);
    if (onCommit != null) {
      _addCallBack(callBackIndex, onCommit);
    }
    callBackIndex++;
  }

  @override
  void insert(
    String table,
    Map<String, Object?> values, {
    String? nullColumnHack,
    ConflictAlgorithm? conflictAlgorithm,
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    batch.insert(
      table,
      values,
      nullColumnHack: nullColumnHack,
      conflictAlgorithm: conflictAlgorithm,
    );
    if (onCommit != null) {
      _addCallBack(callBackIndex, onCommit);
    }
    callBackIndex++;
  }

  @override
  void rawUpdate(
    String sql, [
    List<Object?>? arguments,
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    batch.rawUpdate(sql, arguments);
    if (onCommit != null) {
      _addCallBack(callBackIndex, onCommit);
    }
    callBackIndex++;
  }

  @override
  void update(
    String table,
    Map<String, Object?> values, {
    String? where,
    List<Object?>? whereArgs,
    ConflictAlgorithm? conflictAlgorithm,
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    batch.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
      conflictAlgorithm: conflictAlgorithm,
    );
    if (onCommit != null) {
      _addCallBack(callBackIndex, onCommit);
    }
    callBackIndex++;
  }

  @override
  void rawDelete(
    String sql, [
    List<Object?>? arguments,
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    batch.rawDelete(sql, arguments);
    if (onCommit != null) {
      _addCallBack(callBackIndex, onCommit);
    }
    callBackIndex++;
  }

  @override
  void delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    batch.delete(table, where: where, whereArgs: whereArgs);
    if (onCommit != null) {
      _addCallBack(callBackIndex, onCommit);
    }
    callBackIndex++;
  }

  @override
  void execute(
    String sql, [
    List<Object?>? arguments,
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    batch.execute(sql, arguments);
    if (onCommit != null) {
      _addCallBack(callBackIndex, onCommit);
    }
    callBackIndex++;
  }

  @override
  void query(
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
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    batch.query(
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
    if (onCommit != null) {
      _addCallBack(callBackIndex, onCommit);
    }
    callBackIndex++;
  }

  @override
  void rawQuery(
    String sql, [
    List<Object?>? arguments,
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    batch.rawQuery(sql, arguments);
    if (onCommit != null) {
      _addCallBack(callBackIndex, onCommit);
    }
    callBackIndex++;
  }
}

abstract class _$AppDatabase implements _$AppDatabaseExecutor {
  int get schemaVersion => 1;

  @override
  late Database database;

  late final categoryHelper = _$CategoryHelper();
  late final itemHelper = _$ItemHelper();

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
    await categoryHelper.onCreate(version, batch: batch);
    await itemHelper.onCreate(version, batch: batch);
    await batch.commit();
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    await categoryHelper.onUpgrade(oldVersion, newVersion, batch: batch);
    await itemHelper.onUpgrade(oldVersion, newVersion, batch: batch);
    await batch.commit();
  }

  Future<void> onDowngrade(Database db, int oldVersion, int newVersion) async {
    throw UnimplementedError();
  }

  Future<void> onOpen(Database db) async {
    // do nothing
  }

  /// Insert or update Category.
  /// If id is 0, insert and sets id to generated value.
  /// If specified id already exists in table, update the record.
  /// If specified id does not exist in table, insert with the id.
  @override
  Future<int> registerCategory(Category item) =>
      categoryHelper.register(item, db: this);

  @override
  Future<List<Category>> queryCategory({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) => categoryHelper.query(
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    db: this,
  );

  @override
  Future<Category?> getCategory(int id) => categoryHelper.get(id, db: this);

  @override
  Future<int> deleteCategory(Category item) =>
      categoryHelper.delete(item, db: this);

  /// Insert or update Item.
  /// If id is 0, insert and sets id to generated value.
  /// If specified id already exists in table, update the record.
  /// If specified id does not exist in table, insert with the id.
  @override
  Future<int> registerItem(Item item) => itemHelper.register(item, db: this);

  @override
  Future<List<Item>> queryItem({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
  }) => itemHelper.query(
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    db: this,
  );

  @override
  Future<Item?> getItem(int id) => itemHelper.get(id, db: this);

  @override
  Future<int> deleteItem(Item item) => itemHelper.delete(item, db: this);

  Future<T> transaction<T>(
    Future<T> Function(_$AppDatabaseTransactionWrapper txn) action, {
    bool? exclusive,
  }) {
    return database.transaction<T>((txn) async {
      final transactionWrapper = _$AppDatabaseTransactionWrapper(this, txn);
      return await action(transactionWrapper);
    }, exclusive: exclusive);
  }

  Future<T> readTransaction<T>(
    Future<T> Function(_$AppDatabaseTransactionWrapper txn) action,
  ) {
    return database.readTransaction<T>((txn) async {
      final transactionWrapper = _$AppDatabaseTransactionWrapper(this, txn);
      return await action(transactionWrapper);
    });
  }

  @override
  _$AppDatabaseBatchWrapper batch() {
    final batch = database.batch();
    final wrapper = _$AppDatabaseBatchWrapper(this, this, batch);
    return wrapper;
  }

  // pass through methods
  String get path => database.path;

  Future<void> close() => database.close();

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
}

// **************************************************************************
// TableGenerator
// **************************************************************************

class _$CategoryHelper {
  final String tableName = 'category';
  final column = (id: 'id', name: 'name');
  final columnTypes = {
    'id': "INTEGER PRIMARY KEY AUTOINCREMENT",
    'name': "TEXT NOT NULL DEFAULT ''",
  };
  final columnList = ['id', 'name'];
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
      throw UnsupportedError(
        "No columns defined for Category version $version",
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

  static Map<String, Object?> toSqlMap(Category item) {
    final values = <String, Object?>{};

    if (item.id != 0) {
      values["id"] = item.id;
    }

    values["name"] = item.name;

    return values;
  }

  static Category fromSqlMap(Map<String, Object?> map) {
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

    final item = Category(name, id: id);

    return item;
  }

  Future<int> register(
    Category item, {
    _$AppDatabaseExecutor? db,
    _$AppDatabaseBatchWrapper? batch,
  }) async {
    assert((db != null) ^ (batch != null));

    final map = item.toSqlMap();
    var command = 'REPLACE INTO';
    if (item.id == 0) {
      command = 'INSERT INTO';
    }
    final sql =
        '$command $tableName (${map.keys.join(',')}) VALUES (${List.filled(map.length, '?').join(', ')})';
    // print('register sql: $sql');
    // print('args: ${map.values.toList()}');

    if (db != null) {
      final id = await db.rawInsert(sql, map.values.toList());
      item.id = id;
      return id;
    } else if (batch != null) {
      batch.rawInsert(sql, map.values.toList(), (noResult, object) async {
        if (item.id == 0) {
          if (noResult != true && object is int) {
            item.id = object;
          }
        }
        return object;
      });
    }
    return -1;
  }

  Future<List<Map<String, Object?>>> convertReferences(
    List<Map<String, Object?>> mapList,
    _$AppDatabaseExecutor db,
  ) async {
    var result = mapList;
    result = result.toList(); // convert to modifiable list
    final batch = db.batch();

    for (var i = 0; i < result.length; i++) {
      var map = result[i];
      map = Map.from(map); // convert to modifiable map
      result[i] = map;
    }
    await batch.commit();
    return result;
  }

  Future<List<Category>> query({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    _$AppDatabaseExecutor? db,
    _$AppDatabaseBatchWrapper? batch,
  }) async {
    assert((db != null) ^ (batch != null));

    if (db != null) {
      var result = await db.query(
        tableName,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );
      result = await convertReferences(result, db);

      return result.map((entry) => Category.fromSqlMap(entry)).toList();
    } else if (batch != null) {
      batch.query(
        tableName,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
        onCommit: (noResult, object) async {
          if (noResult == true || object is! List<Map<String, Object?>>) {
            throw StateError('returned object $object is not expected type.');
          }
          var result = await convertReferences(object, batch.executor);
          return result.map((entry) => Category.fromSqlMap(entry)).toList();
        },
      );
    }
    return [];
  }

  Future<Category?> get(
    int id, {
    _$AppDatabaseExecutor? db,
    _$AppDatabaseBatchWrapper? batch,
  }) async {
    assert((db != null) ^ (batch != null));

    if (db != null) {
      final result = await query(
        where: '${column.id} = ?',
        whereArgs: [id],
        db: db,
      );

      if (result.isEmpty) {
        return null;
      }

      assert(result.length == 1);
      return result[0];
    } else if (batch != null) {
      batch.query(
        tableName,
        where: '${column.id} = ?',
        whereArgs: [id],
        onCommit: (noResult, object) async {
          if (noResult == true || object is! List<Map<String, Object?>>) {
            throw StateError('returned object $object is not expected type.');
          }

          if (object.isEmpty) {
            return null;
          }

          var result = await convertReferences(object, batch.executor);
          assert(result.length == 1);
          return Category.fromSqlMap(result[0]);
        },
      );
    }
    return null;
  }

  Future<int> delete(
    Category item, {
    _$AppDatabaseExecutor? db,
    _$AppDatabaseBatchWrapper? batch,
  }) async {
    assert((db != null) ^ (batch != null));
    assert(item.id != 0);

    if (db != null) {
      final id = await db.delete(
        tableName,
        where: '${column.id} = ?',
        whereArgs: [item.id],
      );
      return id;
    } else if (batch != null) {
      batch.delete(tableName, where: '${column.id} = ?', whereArgs: [item.id]);
    }
    return -1;
  }
}

class _$ItemHelper {
  final String tableName = 'item';
  final column = (id: 'id', name: 'name', category: 'category_id');
  final columnTypes = {
    'id': "INTEGER PRIMARY KEY AUTOINCREMENT",
    'name': "TEXT NOT NULL DEFAULT ''",
    'category_id': "INTEGER REFERENCES category(id)",
  };
  final columnList = ['id', 'name', 'category_id'];
  static final v1ColumnList = ['id', 'name', 'category_id'];
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
      throw UnsupportedError("No columns defined for Item version $version");
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

  static Map<String, Object?> toSqlMap(Item item) {
    final values = <String, Object?>{};

    if (item.id != 0) {
      values["id"] = item.id;
    }

    values["name"] = item.name;

    final categoryId = item.category?.id;
    if (categoryId != null) {
      if (categoryId != 0) {
        values["category_id"] = categoryId;
      } else {
        throw StateError('Item.category.id is 0.');
      }
    }

    return values;
  }

  static Item fromSqlMap(Map<String, Object?> map) {
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

    Category? category;
    if (keys.contains('category_id')) {
      category = map['category_id'] as Category?;
      keys.remove("category_id");
    }

    if (keys.isNotEmpty) {
      throw ArgumentError('Unkown map keys. $keys');
    }

    final item = Item(name, id: id, category: category);

    return item;
  }

  Future<int> register(
    Item item, {
    _$AppDatabaseExecutor? db,
    _$AppDatabaseBatchWrapper? batch,
  }) async {
    assert((db != null) ^ (batch != null));

    final map = item.toSqlMap();
    var command = 'REPLACE INTO';
    if (item.id == 0) {
      command = 'INSERT INTO';
    }
    final sql =
        '$command $tableName (${map.keys.join(',')}) VALUES (${List.filled(map.length, '?').join(', ')})';
    // print('register sql: $sql');
    // print('args: ${map.values.toList()}');

    if (db != null) {
      final id = await db.rawInsert(sql, map.values.toList());
      item.id = id;
      return id;
    } else if (batch != null) {
      batch.rawInsert(sql, map.values.toList(), (noResult, object) async {
        if (item.id == 0) {
          if (noResult != true && object is int) {
            item.id = object;
          }
        }
        return object;
      });
    }
    return -1;
  }

  Future<List<Map<String, Object?>>> convertReferences(
    List<Map<String, Object?>> mapList,
    _$AppDatabaseExecutor db,
  ) async {
    var result = mapList;
    result = result.toList(); // convert to modifiable list
    final batch = db.batch();

    for (var i = 0; i < result.length; i++) {
      var map = result[i];
      map = Map.from(map); // convert to modifiable map
      result[i] = map;
      final categoryId = map['category_id'] as int?;
      if (categoryId != null) {
        batch.getCategory(categoryId, (noResult, object) async {
          map['category_id'] = object;
          return object;
        });
      }
    }
    await batch.commit();
    return result;
  }

  Future<List<Item>> query({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    _$AppDatabaseExecutor? db,
    _$AppDatabaseBatchWrapper? batch,
  }) async {
    assert((db != null) ^ (batch != null));

    if (db != null) {
      var result = await db.query(
        tableName,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
      );
      result = await convertReferences(result, db);

      return result.map((entry) => Item.fromSqlMap(entry)).toList();
    } else if (batch != null) {
      batch.query(
        tableName,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
        onCommit: (noResult, object) async {
          if (noResult == true || object is! List<Map<String, Object?>>) {
            throw StateError('returned object $object is not expected type.');
          }
          var result = await convertReferences(object, batch.executor);
          return result.map((entry) => Item.fromSqlMap(entry)).toList();
        },
      );
    }
    return [];
  }

  Future<Item?> get(
    int id, {
    _$AppDatabaseExecutor? db,
    _$AppDatabaseBatchWrapper? batch,
  }) async {
    assert((db != null) ^ (batch != null));

    if (db != null) {
      final result = await query(
        where: '${column.id} = ?',
        whereArgs: [id],
        db: db,
      );

      if (result.isEmpty) {
        return null;
      }

      assert(result.length == 1);
      return result[0];
    } else if (batch != null) {
      batch.query(
        tableName,
        where: '${column.id} = ?',
        whereArgs: [id],
        onCommit: (noResult, object) async {
          if (noResult == true || object is! List<Map<String, Object?>>) {
            throw StateError('returned object $object is not expected type.');
          }

          if (object.isEmpty) {
            return null;
          }

          var result = await convertReferences(object, batch.executor);
          assert(result.length == 1);
          return Item.fromSqlMap(result[0]);
        },
      );
    }
    return null;
  }

  Future<int> delete(
    Item item, {
    _$AppDatabaseExecutor? db,
    _$AppDatabaseBatchWrapper? batch,
  }) async {
    assert((db != null) ^ (batch != null));
    assert(item.id != 0);

    if (db != null) {
      final id = await db.delete(
        tableName,
        where: '${column.id} = ?',
        whereArgs: [item.id],
      );
      return id;
    } else if (batch != null) {
      batch.delete(tableName, where: '${column.id} = ?', whereArgs: [item.id]);
    }
    return -1;
  }
}
