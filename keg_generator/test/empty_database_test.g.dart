// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'empty_database_test.dart';

// **************************************************************************
// DatabaseGenerator
// **************************************************************************

abstract class _$AppDatabaseExecutor extends DatabaseExecutor {
  @override
  _$AppDatabaseBatchWrapper batch();
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

  Future<void> openInMemory() async {
    database = await openDatabase(
      ':memory:',
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

  Future<void> onCreate(Database db, int version) async {}

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<void> onDowngrade(Database db, int oldVersion, int newVersion) async {
    throw UnimplementedError();
  }

  Future<void> onOpen(Database db) async {
    // do nothing
  }

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
