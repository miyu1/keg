// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sole_table_test.dart';

// **************************************************************************
// DatabaseGenerator
// **************************************************************************

abstract class _$AppDatabaseExecutor extends DatabaseExecutor {
  @override
  _$AppDatabaseBatchWrapper batch();

  /// Insert or update User.
  /// If id is 0, insert and sets id to generated value.
  /// If specified id already exists in table, update the record.
  /// If specified id does not exist in table, insert with the id.
  Future<int> registerUser(User item);

  Future<List<User>> queryUser({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String> dropKeys = const [],
  });

  Future<User?> getUser(int id, [List<String> dropKeys = const []]);

  Future<int> deleteUser({String? where, List<Object?>? whereArgs});

  Future<int> deleteUserByIds(List<User> itemList);

  /// Insert or update ItemInfo.
  /// If id is 0, insert and sets id to generated value.
  /// If specified id already exists in table, update the record.
  /// If specified id does not exist in table, insert with the id.
  Future<int> registerItemInfo(ItemInfo item);

  Future<List<ItemInfo>> queryItemInfo({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String> dropKeys = const [],
  });

  Future<ItemInfo?> getItemInfo(int id, [List<String> dropKeys = const []]);

  Future<int> deleteItemInfo({String? where, List<Object?>? whereArgs});

  Future<int> deleteItemInfoByIds(List<ItemInfo> itemList);
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
  Future<int> registerUser(User item) => appdb.userHelper.register(item, this);

  @override
  Future<List<User>> queryUser({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String> dropKeys = const [],
  }) => appdb.userHelper.query(
    this,
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    dropKeys: dropKeys,
  );

  @override
  Future<User?> getUser(int id, [List<String> dropKeys = const []]) =>
      appdb.userHelper.get(id, this, dropKeys);

  @override
  Future<int> deleteUser({String? where, List<Object?>? whereArgs}) =>
      appdb.userHelper.delete(this, where: where, whereArgs: whereArgs);

  @override
  Future<int> deleteUserByIds(List<User> itemList) =>
      appdb.userHelper.deleteByIds(this, itemList);

  @override
  Future<int> registerItemInfo(ItemInfo item) =>
      appdb.itemInfoHelper.register(item, this);

  @override
  Future<List<ItemInfo>> queryItemInfo({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String> dropKeys = const [],
  }) => appdb.itemInfoHelper.query(
    this,
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    dropKeys: dropKeys,
  );

  @override
  Future<ItemInfo?> getItemInfo(int id, [List<String> dropKeys = const []]) =>
      appdb.itemInfoHelper.get(id, this, dropKeys);

  @override
  Future<int> deleteItemInfo({String? where, List<Object?>? whereArgs}) =>
      appdb.itemInfoHelper.delete(this, where: where, whereArgs: whereArgs);

  @override
  Future<int> deleteItemInfoByIds(List<ItemInfo> itemList) =>
      appdb.itemInfoHelper.deleteByIds(this, itemList);

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

  void registerUser(
    User item, [
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    appdb.userHelper.registerBatch(item, this);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void queryUser({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String> dropKeys = const [],
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.userHelper.queryBatch(
      this,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
      dropKeys: dropKeys,
    );
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void getUser(
    int id, {
    List<String> dropKeys = const [],
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.userHelper.getBatch(id, this, dropKeys);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void deleteUser({
    String? where,
    List<Object?>? whereArgs,
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.userHelper.deleteBatch(this, where: where, whereArgs: whereArgs);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void deleteUserByIds(
    List<User> itemList, [
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    appdb.userHelper.deleteByIdsBatch(this, itemList);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void registerItemInfo(
    ItemInfo item, [
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    appdb.itemInfoHelper.registerBatch(item, this);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void queryItemInfo({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String> dropKeys = const [],
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.itemInfoHelper.queryBatch(
      this,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
      dropKeys: dropKeys,
    );
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void getItemInfo(
    int id, {
    List<String> dropKeys = const [],
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.itemInfoHelper.getBatch(id, this, dropKeys);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void deleteItemInfo({
    String? where,
    List<Object?>? whereArgs,
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.itemInfoHelper.deleteBatch(this, where: where, whereArgs: whereArgs);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void deleteItemInfoByIds(
    List<ItemInfo> itemList, [
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    appdb.itemInfoHelper.deleteByIdsBatch(this, itemList);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

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

  late final userHelper = _$UserHelper(this);
  late final itemInfoHelper = _$ItemInfoHelper(this);

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

  /// Insert or update User.
  /// If id is 0, insert and sets id to generated value.
  /// If specified id already exists in table, update the record.
  /// If specified id does not exist in table, insert with the id.
  @override
  Future<int> registerUser(User item) => userHelper.register(item, this);

  @override
  Future<List<User>> queryUser({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String> dropKeys = const [],
  }) => userHelper.query(
    this,
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    dropKeys: dropKeys,
  );

  @override
  Future<User?> getUser(int id, [List<String> dropKeys = const []]) =>
      userHelper.get(id, this, dropKeys);

  @override
  Future<int> deleteUser({String? where, List<Object?>? whereArgs}) =>
      userHelper.delete(this, where: where, whereArgs: whereArgs);

  @override
  Future<int> deleteUserByIds(List<User> itemsList) =>
      userHelper.deleteByIds(this, itemsList);

  /// Insert or update ItemInfo.
  /// If id is 0, insert and sets id to generated value.
  /// If specified id already exists in table, update the record.
  /// If specified id does not exist in table, insert with the id.
  @override
  Future<int> registerItemInfo(ItemInfo item) =>
      itemInfoHelper.register(item, this);

  @override
  Future<List<ItemInfo>> queryItemInfo({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String> dropKeys = const [],
  }) => itemInfoHelper.query(
    this,
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    dropKeys: dropKeys,
  );

  @override
  Future<ItemInfo?> getItemInfo(int id, [List<String> dropKeys = const []]) =>
      itemInfoHelper.get(id, this, dropKeys);

  @override
  Future<int> deleteItemInfo({String? where, List<Object?>? whereArgs}) =>
      itemInfoHelper.delete(this, where: where, whereArgs: whereArgs);

  @override
  Future<int> deleteItemInfoByIds(List<ItemInfo> itemsList) =>
      itemInfoHelper.deleteByIds(this, itemsList);

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

class _$UserHelper {
  final String tableName = '"user"';
  final column = (id: '"id"', name: '"name"');
  final columnTypes = {
    'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
    'name': 'TEXT NOT NULL DEFAULT \'\'',
  };
  final columnList = ['id', 'name'];

  _$AppDatabase appdb;

  _$UserHelper(this.appdb);

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
      params.add('"$column" ${columnTypes[column]}');
    }
    final sql = 'CREATE TABLE IF NOT EXISTS $tableName (${params.join(', ')})';
    //print('Creating table: $sql');
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
          'ALTER TABLE $tableName ADD COLUMN "$column" ${columnTypes[column]}';
      //print('Altering table: $sql');
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
      values['id'] = item.id;
    }

    values['name'] = item.name;

    return values;
  }

  static String _unquote(String s) {
    if (s.startsWith('"') && s.endsWith('"')) {
      return s.substring(1, s.length - 1);
    }
    return s;
  }

  /// unquote column names in map for fromSqlMap
  static Map<String, Object?> _unquoteMap(Map<String, Object?> map) {
    final newMap = <String, Object?>{};
    for (final entry in map.entries) {
      var key = _unquote(entry.key);
      newMap[key] = entry.value;
    }
    return newMap;
  }

  static User fromSqlMap(Map<String, Object?> map) {
    map = _unquoteMap(map);
    final keys = map.keys.toSet();
    if (!keys.contains('name')) {
      throw ArgumentError("Missing required key name in map");
    }

    var id = 0;
    if (keys.contains('id')) {
      id = map['id'] as int;
      keys.remove('id');
    }

    final name = map['name'] as String;
    keys.remove('name');

    if (keys.isNotEmpty) {
      throw ArgumentError('Unkown map keys. $keys');
    }

    final $item = User(name, id);

    return $item;
  }

  Future<int> register(User item, _$AppDatabaseExecutor db) async {
    final map = item.toSqlMap();
    var command = 'REPLACE INTO';
    final originalId = item.id;
    if (originalId == 0) {
      command = 'INSERT INTO';
    }
    final keys = map.keys.map((e) => '"$e"').toList();
    final sql =
        '$command $tableName (${keys.join(',')}) VALUES (${List.filled(map.length, '?').join(', ')})';
    // print('register sql: $sql');
    // print('args: ${map.values.toList()}');
    final id = await db.rawInsert(sql, map.values.toList());
    item.id = id;

    return id;
  }

  void registerBatch(User item, _$AppDatabaseBatchWrapper batch) {
    final map = item.toSqlMap();
    var command = 'REPLACE INTO';
    final originalId = item.id;
    if (originalId == 0) {
      command = 'INSERT INTO';
    }
    final keys = map.keys.map((e) => '"$e"').toList();
    final sql =
        '$command $tableName (${keys.join(',')}) VALUES (${List.filled(map.length, '?').join(', ')})';
    // print('register sql: $sql');
    // print('args: ${map.values.toList()}');
    batch.rawInsert(sql, map.values.toList(), (noResult, object) async {
      if (item.id == 0) {
        if (noResult == true || object is! int) {
          throw StateError('returned object $object is not int.');
        }
        item.id = object;
      }
      return object;
    });
  }

  Future<List<Map<String, Object?>>> convertReferences(
    List<Map<String, Object?>> mapList,
    _$AppDatabaseExecutor db,
    List<String> dropKeys,
  ) async {
    var result = mapList;
    result = result.toList(); // convert to modifiable list
    final batch = db.batch();

    for (var i = 0; i < result.length; i++) {
      var map = result[i];
      map = Map.from(map); // convert to modifiable map
      result[i] = map;

      // ignore: unused_local_variable
      final id = map['id'] as int;
      //print('User($id) $dropKeys');
      for (final key in dropKeys) {
        map.remove(_unquote(key));
      }
    }
    await batch.commit();

    return result;
  }

  /// convert map list from sql query to object list
  List<User> mapToObject(List<Map<String, Object?>> mapList) {
    final result = mapList.map((map) => User.fromSqlMap(map)).toList();
    return result;
  }

  Future<List<User>> query(
    _$AppDatabaseExecutor db, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String> dropKeys = const [],
  }) async {
    var queryResult = await db.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
    queryResult = await convertReferences(queryResult, db, dropKeys);

    final result = mapToObject(queryResult);
    return result;
  }

  void queryBatch(
    _$AppDatabaseBatchWrapper batch, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String> dropKeys = const [],
  }) {
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
        var queryResult = await convertReferences(
          object,
          batch.executor,
          dropKeys,
        );

        final result = mapToObject(queryResult);
        return result;
      },
    );
  }

  Future<User?> get(
    int id,
    _$AppDatabaseExecutor db, [
    List<String> dropKeys = const [],
  ]) async {
    final result = await query(
      db,
      where: '${column.id} = ?',
      whereArgs: [id],
      dropKeys: dropKeys,
    );

    if (result.isEmpty) {
      return null;
    }

    assert(result.length == 1);
    return result[0];
  }

  void getBatch(
    int id,
    _$AppDatabaseBatchWrapper batch, [
    List<String> dropKeys = const [],
  ]) {
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

        final queryResult = await convertReferences(
          object,
          batch.executor,
          dropKeys,
        );
        final result = mapToObject(queryResult);
        assert(result.length == 1);
        return result[0];
      },
    );
  }

  Future<int> delete(
    _$AppDatabaseExecutor db, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    return db.delete(tableName, where: where, whereArgs: whereArgs);
  }

  Future<void> deleteBatch(
    _$AppDatabaseBatchWrapper batch, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    batch.delete(tableName, where: where, whereArgs: whereArgs);
  }

  Future<int> deleteByIds(_$AppDatabaseExecutor db, List<User> itemList) async {
    final noids = itemList.where((e) => e.id == 0);
    if (noids.isNotEmpty) {
      throw ArgumentError('Cannot delete User because id is 0.');
    }
    final ids = itemList.map((e) => e.id).toSet().toList();

    final count = await db.delete(
      tableName,
      where: '${column.id} in (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
    return count;
  }

  void deleteByIdsBatch(_$AppDatabaseBatchWrapper batch, List<User> itemList) {
    final noids = itemList.where((e) => e.id == 0);
    if (noids.isNotEmpty) {
      throw ArgumentError('Cannot delete User because id is 0.');
    }
    final ids = itemList.map((e) => e.id).toSet().toList();

    batch.delete(
      tableName,
      where: '${column.id} in (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
  }
}

class _$ItemInfoHelper {
  final String tableName = '"item_info"';
  final column = (
    id: '"id"',
    name: '"name"',
    order: '"order"',
    color: '"color"',
    weight: '"weight"',
    isActive: '"is_active"',
    created: '"created"',
  );
  final columnTypes = {
    'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
    'name': 'TEXT NOT NULL DEFAULT \'\'',
    'order': 'INTEGER NOT NULL DEFAULT 0',
    'color': 'TEXT NOT NULL DEFAULT \'${Color.values[0].name}\'',
    'weight': 'REAL NOT NULL DEFAULT 0.0',
    'is_active': 'INTEGER NOT NULL DEFAULT 0',
    'created': 'INTEGER NOT NULL DEFAULT 0',
  };
  final columnList = [
    'id',
    'name',
    'order',
    'color',
    'weight',
    'is_active',
    'created',
  ];

  _$AppDatabase appdb;

  _$ItemInfoHelper(this.appdb);

  static final v1ColumnList = [
    'id',
    'name',
    'order',
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
      params.add('"$column" ${columnTypes[column]}');
    }
    final sql = 'CREATE TABLE IF NOT EXISTS $tableName (${params.join(', ')})';
    //print('Creating table: $sql');
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
          'ALTER TABLE $tableName ADD COLUMN "$column" ${columnTypes[column]}';
      //print('Altering table: $sql');
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
      values['id'] = item.id;
    }

    values['name'] = item.name;

    values['order'] = item.order;

    values['color'] = item.color.name;

    values['weight'] = item.weight;

    values['is_active'] = item.isActive ? 1 : 0;

    values['created'] = item.created.toUtc().microsecondsSinceEpoch;

    return values;
  }

  static String _unquote(String s) {
    if (s.startsWith('"') && s.endsWith('"')) {
      return s.substring(1, s.length - 1);
    }
    return s;
  }

  /// unquote column names in map for fromSqlMap
  static Map<String, Object?> _unquoteMap(Map<String, Object?> map) {
    final newMap = <String, Object?>{};
    for (final entry in map.entries) {
      var key = _unquote(entry.key);
      newMap[key] = entry.value;
    }
    return newMap;
  }

  static ItemInfo fromSqlMap(Map<String, Object?> map) {
    map = _unquoteMap(map);
    final keys = map.keys.toSet();
    final params = <String, Object>{};
    if (!keys.contains('name')) {
      throw ArgumentError("Missing required key name in map");
    }
    if (!keys.contains('color')) {
      throw ArgumentError("Missing required key color in map");
    }
    if (!keys.contains('weight')) {
      throw ArgumentError("Missing required key weight in map");
    }

    var id = 0;
    if (keys.contains('id')) {
      id = map['id'] as int;
      keys.remove('id');
    }

    final name = map['name'] as String;
    keys.remove('name');

    var order = 0;
    if (keys.contains('order')) {
      order = map['order'] as int;
      keys.remove('order');
    }

    final color = Color.values.byName(map['color'] as String);
    keys.remove('color');

    final weight = map['weight'] as double;
    keys.remove('weight');

    var isActive = true;
    if (keys.contains('is_active')) {
      isActive = (map['is_active'] as int) == 0 ? false : true;
      keys.remove('is_active');
    }

    if (keys.contains('created')) {
      params['created'] = DateTime.fromMicrosecondsSinceEpoch(
        map['created'] as int,
      ).toLocal();
      keys.remove('created');
    }

    if (keys.isNotEmpty) {
      throw ArgumentError('Unkown map keys. $keys');
    }

    final $item = ItemInfo(
      name,
      id: id,
      order: order,
      color: color,
      weight: weight,
      isActive: isActive,
    );

    if (params['created'] != null) {
      $item.created = params['created'] as DateTime;
    }
    return $item;
  }

  Future<int> register(ItemInfo item, _$AppDatabaseExecutor db) async {
    final map = item.toSqlMap();
    var command = 'REPLACE INTO';
    final originalId = item.id;
    if (originalId == 0) {
      command = 'INSERT INTO';
    }
    final keys = map.keys.map((e) => '"$e"').toList();
    final sql =
        '$command $tableName (${keys.join(',')}) VALUES (${List.filled(map.length, '?').join(', ')})';
    // print('register sql: $sql');
    // print('args: ${map.values.toList()}');
    final id = await db.rawInsert(sql, map.values.toList());
    item.id = id;

    return id;
  }

  void registerBatch(ItemInfo item, _$AppDatabaseBatchWrapper batch) {
    final map = item.toSqlMap();
    var command = 'REPLACE INTO';
    final originalId = item.id;
    if (originalId == 0) {
      command = 'INSERT INTO';
    }
    final keys = map.keys.map((e) => '"$e"').toList();
    final sql =
        '$command $tableName (${keys.join(',')}) VALUES (${List.filled(map.length, '?').join(', ')})';
    // print('register sql: $sql');
    // print('args: ${map.values.toList()}');
    batch.rawInsert(sql, map.values.toList(), (noResult, object) async {
      if (item.id == 0) {
        if (noResult == true || object is! int) {
          throw StateError('returned object $object is not int.');
        }
        item.id = object;
      }
      return object;
    });
  }

  Future<List<Map<String, Object?>>> convertReferences(
    List<Map<String, Object?>> mapList,
    _$AppDatabaseExecutor db,
    List<String> dropKeys,
  ) async {
    var result = mapList;
    result = result.toList(); // convert to modifiable list
    final batch = db.batch();

    for (var i = 0; i < result.length; i++) {
      var map = result[i];
      map = Map.from(map); // convert to modifiable map
      result[i] = map;

      // ignore: unused_local_variable
      final id = map['id'] as int;
      //print('ItemInfo($id) $dropKeys');
      for (final key in dropKeys) {
        map.remove(_unquote(key));
      }
    }
    await batch.commit();

    return result;
  }

  /// convert map list from sql query to object list
  List<ItemInfo> mapToObject(List<Map<String, Object?>> mapList) {
    final result = mapList.map((map) => ItemInfo.fromSqlMap(map)).toList();
    return result;
  }

  Future<List<ItemInfo>> query(
    _$AppDatabaseExecutor db, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String> dropKeys = const [],
  }) async {
    var queryResult = await db.query(
      tableName,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
    queryResult = await convertReferences(queryResult, db, dropKeys);

    final result = mapToObject(queryResult);
    return result;
  }

  void queryBatch(
    _$AppDatabaseBatchWrapper batch, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String> dropKeys = const [],
  }) {
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
        var queryResult = await convertReferences(
          object,
          batch.executor,
          dropKeys,
        );

        final result = mapToObject(queryResult);
        return result;
      },
    );
  }

  Future<ItemInfo?> get(
    int id,
    _$AppDatabaseExecutor db, [
    List<String> dropKeys = const [],
  ]) async {
    final result = await query(
      db,
      where: '${column.id} = ?',
      whereArgs: [id],
      dropKeys: dropKeys,
    );

    if (result.isEmpty) {
      return null;
    }

    assert(result.length == 1);
    return result[0];
  }

  void getBatch(
    int id,
    _$AppDatabaseBatchWrapper batch, [
    List<String> dropKeys = const [],
  ]) {
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

        final queryResult = await convertReferences(
          object,
          batch.executor,
          dropKeys,
        );
        final result = mapToObject(queryResult);
        assert(result.length == 1);
        return result[0];
      },
    );
  }

  Future<int> delete(
    _$AppDatabaseExecutor db, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    return db.delete(tableName, where: where, whereArgs: whereArgs);
  }

  Future<void> deleteBatch(
    _$AppDatabaseBatchWrapper batch, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    batch.delete(tableName, where: where, whereArgs: whereArgs);
  }

  Future<int> deleteByIds(
    _$AppDatabaseExecutor db,
    List<ItemInfo> itemList,
  ) async {
    final noids = itemList.where((e) => e.id == 0);
    if (noids.isNotEmpty) {
      throw ArgumentError('Cannot delete ItemInfo because id is 0.');
    }
    final ids = itemList.map((e) => e.id).toSet().toList();

    final count = await db.delete(
      tableName,
      where: '${column.id} in (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
    return count;
  }

  void deleteByIdsBatch(
    _$AppDatabaseBatchWrapper batch,
    List<ItemInfo> itemList,
  ) {
    final noids = itemList.where((e) => e.id == 0);
    if (noids.isNotEmpty) {
      throw ArgumentError('Cannot delete ItemInfo because id is 0.');
    }
    final ids = itemList.map((e) => e.id).toSet().toList();

    batch.delete(
      tableName,
      where: '${column.id} in (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
  }
}
