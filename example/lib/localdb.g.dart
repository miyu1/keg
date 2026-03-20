// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localdb.dart';

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
    List<({String table, String column})> dropKeys = const [],
  });

  Future<User?> getUser(
    int id, [
    List<({String table, String column})> dropKeys = const [],
  ]);

  Future<int> deleteUser({String? where, List<Object?>? whereArgs});

  Future<int> deleteUserByIds(List<User> itemList);

  /// Insert or update Order.
  /// If id is 0, insert and sets id to generated value.
  /// If specified id already exists in table, update the record.
  /// If specified id does not exist in table, insert with the id.
  Future<int> registerOrder(Order item);

  Future<List<Order>> queryOrder({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<({String table, String column})> dropKeys = const [],
  });

  Future<Order?> getOrder(
    int id, [
    List<({String table, String column})> dropKeys = const [],
  ]);

  Future<int> deleteOrder({String? where, List<Object?>? whereArgs});

  Future<int> deleteOrderByIds(List<Order> itemList);

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
    List<({String table, String column})> dropKeys = const [],
  });

  Future<Category?> getCategory(
    int id, [
    List<({String table, String column})> dropKeys = const [],
  ]);

  Future<int> deleteCategory({String? where, List<Object?>? whereArgs});

  Future<int> deleteCategoryByIds(List<Category> itemList);

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
    List<({String table, String column})> dropKeys = const [],
  });

  Future<Item?> getItem(
    int id, [
    List<({String table, String column})> dropKeys = const [],
  ]);

  Future<int> deleteItem({String? where, List<Object?>? whereArgs});

  Future<int> deleteItemByIds(List<Item> itemList);

  /// Insert or update OrderToItem.
  /// If id is 0, insert and sets id to generated value.
  /// If specified id already exists in table, update the record.
  /// If specified id does not exist in table, insert with the id.
  Future<int> registerOrderToItem(OrderToItem item);

  Future<List<OrderToItem>> queryOrderToItem({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<({String table, String column})> dropKeys = const [],
  });

  Future<OrderToItem?> getOrderToItem(
    int id, [
    List<({String table, String column})> dropKeys = const [],
  ]);

  Future<int> deleteOrderToItem({String? where, List<Object?>? whereArgs});

  Future<int> deleteOrderToItemByIds(List<OrderToItem> itemList);
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
    List<({String table, String column})> dropKeys = const [],
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
  Future<User?> getUser(
    int id, [
    List<({String table, String column})> dropKeys = const [],
  ]) => appdb.userHelper.get(id, this, dropKeys);

  @override
  Future<int> deleteUser({String? where, List<Object?>? whereArgs}) =>
      appdb.userHelper.delete(this, where: where, whereArgs: whereArgs);

  @override
  Future<int> deleteUserByIds(List<User> itemList) =>
      appdb.userHelper.deleteByIds(this, itemList);

  @override
  Future<int> registerOrder(Order item) =>
      appdb.orderHelper.register(item, this);

  @override
  Future<List<Order>> queryOrder({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<({String table, String column})> dropKeys = const [],
  }) => appdb.orderHelper.query(
    this,
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    dropKeys: dropKeys,
  );

  @override
  Future<Order?> getOrder(
    int id, [
    List<({String table, String column})> dropKeys = const [],
  ]) => appdb.orderHelper.get(id, this, dropKeys);

  @override
  Future<int> deleteOrder({String? where, List<Object?>? whereArgs}) =>
      appdb.orderHelper.delete(this, where: where, whereArgs: whereArgs);

  @override
  Future<int> deleteOrderByIds(List<Order> itemList) =>
      appdb.orderHelper.deleteByIds(this, itemList);

  @override
  Future<int> registerCategory(Category item) =>
      appdb.categoryHelper.register(item, this);

  @override
  Future<List<Category>> queryCategory({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<({String table, String column})> dropKeys = const [],
  }) => appdb.categoryHelper.query(
    this,
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    dropKeys: dropKeys,
  );

  @override
  Future<Category?> getCategory(
    int id, [
    List<({String table, String column})> dropKeys = const [],
  ]) => appdb.categoryHelper.get(id, this, dropKeys);

  @override
  Future<int> deleteCategory({String? where, List<Object?>? whereArgs}) =>
      appdb.categoryHelper.delete(this, where: where, whereArgs: whereArgs);

  @override
  Future<int> deleteCategoryByIds(List<Category> itemList) =>
      appdb.categoryHelper.deleteByIds(this, itemList);

  @override
  Future<int> registerItem(Item item) => appdb.itemHelper.register(item, this);

  @override
  Future<List<Item>> queryItem({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<({String table, String column})> dropKeys = const [],
  }) => appdb.itemHelper.query(
    this,
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    dropKeys: dropKeys,
  );

  @override
  Future<Item?> getItem(
    int id, [
    List<({String table, String column})> dropKeys = const [],
  ]) => appdb.itemHelper.get(id, this, dropKeys);

  @override
  Future<int> deleteItem({String? where, List<Object?>? whereArgs}) =>
      appdb.itemHelper.delete(this, where: where, whereArgs: whereArgs);

  @override
  Future<int> deleteItemByIds(List<Item> itemList) =>
      appdb.itemHelper.deleteByIds(this, itemList);

  @override
  Future<int> registerOrderToItem(OrderToItem item) =>
      appdb.orderToItemHelper.register(item, this);

  @override
  Future<List<OrderToItem>> queryOrderToItem({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<({String table, String column})> dropKeys = const [],
  }) => appdb.orderToItemHelper.query(
    this,
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    dropKeys: dropKeys,
  );

  @override
  Future<OrderToItem?> getOrderToItem(
    int id, [
    List<({String table, String column})> dropKeys = const [],
  ]) => appdb.orderToItemHelper.get(id, this, dropKeys);

  @override
  Future<int> deleteOrderToItem({String? where, List<Object?>? whereArgs}) =>
      appdb.orderToItemHelper.delete(this, where: where, whereArgs: whereArgs);

  @override
  Future<int> deleteOrderToItemByIds(List<OrderToItem> itemList) =>
      appdb.orderToItemHelper.deleteByIds(this, itemList);

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
    List<({String table, String column})> dropKeys = const [],
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
    List<({String table, String column})> dropKeys = const [],
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

  void registerOrder(
    Order item, [
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    appdb.orderHelper.registerBatch(item, this);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void queryOrder({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<({String table, String column})> dropKeys = const [],
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.orderHelper.queryBatch(
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

  void getOrder(
    int id, {
    List<({String table, String column})> dropKeys = const [],
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.orderHelper.getBatch(id, this, dropKeys);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void deleteOrder({
    String? where,
    List<Object?>? whereArgs,
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.orderHelper.deleteBatch(this, where: where, whereArgs: whereArgs);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void deleteOrderByIds(
    List<Order> itemList, [
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    appdb.orderHelper.deleteByIdsBatch(this, itemList);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void registerCategory(
    Category item, [
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    appdb.categoryHelper.registerBatch(item, this);
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
    List<({String table, String column})> dropKeys = const [],
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.categoryHelper.queryBatch(
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

  void getCategory(
    int id, {
    List<({String table, String column})> dropKeys = const [],
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.categoryHelper.getBatch(id, this, dropKeys);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void deleteCategory({
    String? where,
    List<Object?>? whereArgs,
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.categoryHelper.deleteBatch(this, where: where, whereArgs: whereArgs);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void deleteCategoryByIds(
    List<Category> itemList, [
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    appdb.categoryHelper.deleteByIdsBatch(this, itemList);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void registerItem(
    Item item, [
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    appdb.itemHelper.registerBatch(item, this);
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
    List<({String table, String column})> dropKeys = const [],
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.itemHelper.queryBatch(
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

  void getItem(
    int id, {
    List<({String table, String column})> dropKeys = const [],
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.itemHelper.getBatch(id, this, dropKeys);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void deleteItem({
    String? where,
    List<Object?>? whereArgs,
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.itemHelper.deleteBatch(this, where: where, whereArgs: whereArgs);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void deleteItemByIds(
    List<Item> itemList, [
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    appdb.itemHelper.deleteByIdsBatch(this, itemList);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void registerOrderToItem(
    OrderToItem item, [
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    appdb.orderToItemHelper.registerBatch(item, this);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void queryOrderToItem({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<({String table, String column})> dropKeys = const [],
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.orderToItemHelper.queryBatch(
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

  void getOrderToItem(
    int id, {
    List<({String table, String column})> dropKeys = const [],
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.orderToItemHelper.getBatch(id, this, dropKeys);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void deleteOrderToItem({
    String? where,
    List<Object?>? whereArgs,
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.orderToItemHelper.deleteBatch(
      this,
      where: where,
      whereArgs: whereArgs,
    );
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void deleteOrderToItemByIds(
    List<OrderToItem> itemList, [
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    appdb.orderToItemHelper.deleteByIdsBatch(this, itemList);
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
  late final orderHelper = _$OrderHelper(this);
  late final categoryHelper = _$CategoryHelper(this);
  late final itemHelper = _$ItemHelper(this);
  late final orderToItemHelper = _$OrderToItemHelper(this);

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
    await orderHelper.onCreate(version, batch: batch);
    await categoryHelper.onCreate(version, batch: batch);
    await itemHelper.onCreate(version, batch: batch);
    await orderToItemHelper.onCreate(version, batch: batch);
    await batch.commit();
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    await userHelper.onUpgrade(oldVersion, newVersion, batch: batch);
    await orderHelper.onUpgrade(oldVersion, newVersion, batch: batch);
    await categoryHelper.onUpgrade(oldVersion, newVersion, batch: batch);
    await itemHelper.onUpgrade(oldVersion, newVersion, batch: batch);
    await orderToItemHelper.onUpgrade(oldVersion, newVersion, batch: batch);
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
    List<({String table, String column})> dropKeys = const [],
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
  Future<User?> getUser(
    int id, [
    List<({String table, String column})> dropKeys = const [],
  ]) => userHelper.get(id, this, dropKeys);

  @override
  Future<int> deleteUser({String? where, List<Object?>? whereArgs}) =>
      userHelper.delete(this, where: where, whereArgs: whereArgs);

  @override
  Future<int> deleteUserByIds(List<User> itemsList) =>
      userHelper.deleteByIds(this, itemsList);

  /// Insert or update Order.
  /// If id is 0, insert and sets id to generated value.
  /// If specified id already exists in table, update the record.
  /// If specified id does not exist in table, insert with the id.
  @override
  Future<int> registerOrder(Order item) => orderHelper.register(item, this);

  @override
  Future<List<Order>> queryOrder({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<({String table, String column})> dropKeys = const [],
  }) => orderHelper.query(
    this,
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    dropKeys: dropKeys,
  );

  @override
  Future<Order?> getOrder(
    int id, [
    List<({String table, String column})> dropKeys = const [],
  ]) => orderHelper.get(id, this, dropKeys);

  @override
  Future<int> deleteOrder({String? where, List<Object?>? whereArgs}) =>
      orderHelper.delete(this, where: where, whereArgs: whereArgs);

  @override
  Future<int> deleteOrderByIds(List<Order> itemsList) =>
      orderHelper.deleteByIds(this, itemsList);

  /// Insert or update Category.
  /// If id is 0, insert and sets id to generated value.
  /// If specified id already exists in table, update the record.
  /// If specified id does not exist in table, insert with the id.
  @override
  Future<int> registerCategory(Category item) =>
      categoryHelper.register(item, this);

  @override
  Future<List<Category>> queryCategory({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<({String table, String column})> dropKeys = const [],
  }) => categoryHelper.query(
    this,
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    dropKeys: dropKeys,
  );

  @override
  Future<Category?> getCategory(
    int id, [
    List<({String table, String column})> dropKeys = const [],
  ]) => categoryHelper.get(id, this, dropKeys);

  @override
  Future<int> deleteCategory({String? where, List<Object?>? whereArgs}) =>
      categoryHelper.delete(this, where: where, whereArgs: whereArgs);

  @override
  Future<int> deleteCategoryByIds(List<Category> itemsList) =>
      categoryHelper.deleteByIds(this, itemsList);

  /// Insert or update Item.
  /// If id is 0, insert and sets id to generated value.
  /// If specified id already exists in table, update the record.
  /// If specified id does not exist in table, insert with the id.
  @override
  Future<int> registerItem(Item item) => itemHelper.register(item, this);

  @override
  Future<List<Item>> queryItem({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<({String table, String column})> dropKeys = const [],
  }) => itemHelper.query(
    this,
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    dropKeys: dropKeys,
  );

  @override
  Future<Item?> getItem(
    int id, [
    List<({String table, String column})> dropKeys = const [],
  ]) => itemHelper.get(id, this, dropKeys);

  @override
  Future<int> deleteItem({String? where, List<Object?>? whereArgs}) =>
      itemHelper.delete(this, where: where, whereArgs: whereArgs);

  @override
  Future<int> deleteItemByIds(List<Item> itemsList) =>
      itemHelper.deleteByIds(this, itemsList);

  /// Insert or update OrderToItem.
  /// If id is 0, insert and sets id to generated value.
  /// If specified id already exists in table, update the record.
  /// If specified id does not exist in table, insert with the id.
  @override
  Future<int> registerOrderToItem(OrderToItem item) =>
      orderToItemHelper.register(item, this);

  @override
  Future<List<OrderToItem>> queryOrderToItem({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<({String table, String column})> dropKeys = const [],
  }) => orderToItemHelper.query(
    this,
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    dropKeys: dropKeys,
  );

  @override
  Future<OrderToItem?> getOrderToItem(
    int id, [
    List<({String table, String column})> dropKeys = const [],
  ]) => orderToItemHelper.get(id, this, dropKeys);

  @override
  Future<int> deleteOrderToItem({String? where, List<Object?>? whereArgs}) =>
      orderToItemHelper.delete(this, where: where, whereArgs: whereArgs);

  @override
  Future<int> deleteOrderToItemByIds(List<OrderToItem> itemsList) =>
      orderToItemHelper.deleteByIds(this, itemsList);

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

    final nameIndexSql =
        'CREATE UNIQUE INDEX IF NOT EXISTS "${_unquote(tableName)}_name_idx" ON $tableName ("name" ASC)';
    if (db != null) {
      await db.execute(nameIndexSql);
    } else if (batch != null) {
      batch.execute(nameIndexSql);
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

    final nameIndexSql =
        'CREATE UNIQUE INDEX IF NOT EXISTS "${_unquote(tableName)}_name_idx" ON $tableName ("name" ASC)';
    if (db != null) {
      await db.execute(nameIndexSql);
    } else if (batch != null) {
      batch.execute(nameIndexSql);
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
    final params = <String, Object>{};
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

    if (keys.contains('order_list')) {
      params['orderList'] = map['order_list'] as List<Order>;
      keys.remove('order_list');
    }

    if (keys.isNotEmpty) {
      throw ArgumentError('Unkown map keys. $keys');
    }

    final $item = User(name, id: id);

    if (params['orderList'] != null) {
      $item.orderList = params['orderList'] as List<Order>;
    }
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
    // set id if possible
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
        // set id if possible
        item.id = object;
      }
      return object;
    });
  }

  Future<List<Map<String, Object?>>> convertReferences(
    List<Map<String, Object?>> mapList,
    _$AppDatabaseExecutor db,
    List<({String table, String column})> dropKeys,
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
      //print('User($id) ${dropKeys.map((e) => '${_unquote(e.table)}.${_unquote(e.column)}').join(', ')}');
      for (final key in dropKeys) {
        if (_unquote(key.table) == 'user') {
          map.remove(_unquote(key.column));
        }
      }
      batch.queryOrder(
        where: '${appdb.orderHelper.column.user} = ?',
        whereArgs: [id],
        orderBy: '${appdb.orderHelper.column.id} ASC',
        dropKeys: [
          (
            table: appdb.orderHelper.tableName,
            column: appdb.orderHelper.column.user,
          ),
          ...dropKeys,
        ],
        onCommit: (noResult, object) async {
          if (noResult == true || object is! List<Order>) {
            throw StateError('returned object $object is not expected type.');
          }
          map['order_list'] = object;
          return object;
        },
      );
    }
    await batch.commit();

    return result;
  }

  /// convert map list from sql query to object list
  List<User> mapToObject(List<Map<String, Object?>> mapList) {
    final result = mapList.map((map) => User.fromSqlMap(map)).toList();
    for (final object in result) {
      for (final item in object.orderList) {
        item.user = object;
      }
    }
    return result;
  }

  Future<List<User>> query(
    _$AppDatabaseExecutor db, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<({String table, String column})> dropKeys = const [],
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
    List<({String table, String column})> dropKeys = const [],
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
    List<({String table, String column})> dropKeys = const [],
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
    List<({String table, String column})> dropKeys = const [],
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

class _$OrderHelper {
  final String tableName = '"order"';
  final column = (id: '"id"', user: '"user_id"', created: '"created"');
  final columnTypes = {
    'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
    'user_id': 'INTEGER REFERENCES "user"("id")',
    'created': 'INTEGER NOT NULL DEFAULT 0',
  };
  final columnList = ['id', 'user_id', 'created'];

  _$AppDatabase appdb;

  _$OrderHelper(this.appdb);

  static final v1ColumnList = ['id', 'user_id', 'created'];
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
      throw UnsupportedError("No columns defined for Order version $version");
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

    final userIndexSql =
        'CREATE  INDEX IF NOT EXISTS "${_unquote(tableName)}_user_id_idx" ON $tableName ("user_id" ASC)';
    if (db != null) {
      await db.execute(userIndexSql);
    } else if (batch != null) {
      batch.execute(userIndexSql);
    }
    final createdIndexSql =
        'CREATE  INDEX IF NOT EXISTS "${_unquote(tableName)}_created_idx" ON $tableName ("created" DESC)';
    if (db != null) {
      await db.execute(createdIndexSql);
    } else if (batch != null) {
      batch.execute(createdIndexSql);
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

    final userIndexSql =
        'CREATE  INDEX IF NOT EXISTS "${_unquote(tableName)}_user_id_idx" ON $tableName ("user_id" ASC)';
    if (db != null) {
      await db.execute(userIndexSql);
    } else if (batch != null) {
      batch.execute(userIndexSql);
    }
    final createdIndexSql =
        'CREATE  INDEX IF NOT EXISTS "${_unquote(tableName)}_created_idx" ON $tableName ("created" DESC)';
    if (db != null) {
      await db.execute(createdIndexSql);
    } else if (batch != null) {
      batch.execute(createdIndexSql);
    }
  }

  static Map<String, Object?> toSqlMap(Order item) {
    final values = <String, Object?>{};

    if (item.id != 0) {
      values['id'] = item.id;
    }

    if (item.user != null) {
      final userId = item.user!.id;
      if (userId != 0) {
        values['user_id'] = userId;
      } else {
        throw StateError('Order.user.id is 0.');
      }
    }

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

  static Order fromSqlMap(Map<String, Object?> map) {
    map = _unquoteMap(map);
    final keys = map.keys.toSet();
    final params = <String, Object>{};

    var id = 0;
    if (keys.contains('id')) {
      id = map['id'] as int;
      keys.remove('id');
    }

    User? user;
    if (keys.contains('user_id')) {
      user = map['user_id'] as User?;
      keys.remove('user_id');
    }

    if (keys.contains('created')) {
      params['created'] = DateTime.fromMicrosecondsSinceEpoch(
        map['created'] as int,
      ).toLocal();
      keys.remove('created');
    }

    if (keys.contains('item_list')) {
      params['itemList'] = map['item_list'] as List<Item>;
      keys.remove('item_list');
    }

    if (keys.isNotEmpty) {
      throw ArgumentError('Unkown map keys. $keys');
    }

    final $item = Order(id: id, user: user);

    if (params['created'] != null) {
      $item.created = params['created'] as DateTime;
    }
    if (params['itemList'] != null) {
      $item.itemList = params['itemList'] as List<Item>;
    }
    return $item;
  }

  bool compareItemList(Order item1, Set<int> set2) {
    if (item1.itemList.length != set2.length) {
      return false;
    }
    final list1 = item1.itemList.map((e) => e.id).toList();
    for (final item in list1) {
      if (!set2.contains(item)) {
        return false;
      }
    }
    return true;
  }

  Future<void> registerItemList(
    Order item,
    _$AppDatabaseExecutor executor,
  ) async {
    final batch = executor.batch();
    for (final target in item.itemList) {
      Map<String, Object?> middleMap = {};
      middleMap[appdb.orderToItemHelper.column.order] = item;
      middleMap[appdb.orderToItemHelper.column.item] = target;
      middleMap[appdb.orderToItemHelper.column.field] = 'itemList';
      final middle = OrderToItem.fromSqlMap(middleMap);
      batch.registerOrderToItem(middle);
    }
    await batch.commit();
  }

  Future<int> register(Order item, _$AppDatabaseExecutor db) async {
    final itemListNoids = item.itemList.where((e) => e.id == 0);
    if (itemListNoids.isNotEmpty) {
      throw ArgumentError(
        'Cannot register Order because itemList has unregistered items.',
      );
    }
    if (item.itemList.length != item.itemList.toSet().length) {
      throw ArgumentError(
        'Cannot register Order because itemList has duplicate items.',
      );
    }
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
    // set id if possible
    item.id = id;

    final executor = db;
    // handle many to many relation for itemList
    bool addItemList = true;
    if (originalId != 0) {
      // compare existing middle records
      final existingMiddleList = await executor.query(
        appdb.orderToItemHelper.tableName,
        where:
            '${appdb.orderToItemHelper.column.order} = ? AND ${appdb.orderToItemHelper.column.field} = ?',
        whereArgs: [originalId, 'itemList'],
      );
      final existingTargetIds = existingMiddleList
          .where((e) => e[appdb.orderToItemHelper.column.item] != null)
          .map((e) => e[appdb.orderToItemHelper.column.item] as int)
          .toSet();
      if (!compareItemList(item, existingTargetIds)) {
        // delete middle records
        await executor.deleteOrderToItem(
          where:
              '${appdb.orderToItemHelper.column.order} = ? AND ${appdb.orderToItemHelper.column.field} = ?',
          whereArgs: [originalId, 'itemList'],
        );
      } else {
        addItemList = false;
      }
    }
    if (addItemList) {
      // register middle records
      await registerItemList(item, executor);
    }

    return id;
  }

  void registerBatch(Order item, _$AppDatabaseBatchWrapper batch) {
    final itemListNoids = item.itemList.where((e) => e.id == 0);
    if (itemListNoids.isNotEmpty) {
      throw ArgumentError(
        'Cannot register Order because itemList has unregistered items.',
      );
    }
    if (item.itemList.length != item.itemList.toSet().length) {
      throw ArgumentError(
        'Cannot register Order because itemList has duplicate items.',
      );
    }
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
      final executor = batch.executor;
      if (item.id == 0) {
        if (noResult == true || object is! int) {
          throw StateError('returned object $object is not int.');
        }
        // set id if possible
        item.id = object;
      }
      // handle many to many relation for itemList
      bool addItemList = true;
      if (originalId != 0) {
        // compare existing middle records
        final existingMiddleList = await executor.query(
          appdb.orderToItemHelper.tableName,
          where:
              '${appdb.orderToItemHelper.column.order} = ? AND ${appdb.orderToItemHelper.column.field} = ?',
          whereArgs: [originalId, 'itemList'],
        );
        final existingTargetIds = existingMiddleList
            .where((e) => e[appdb.orderToItemHelper.column.item] != null)
            .map((e) => e[appdb.orderToItemHelper.column.item] as int)
            .toSet();
        if (!compareItemList(item, existingTargetIds)) {
          // delete middle records
          await executor.deleteOrderToItem(
            where:
                '${appdb.orderToItemHelper.column.order} = ? AND ${appdb.orderToItemHelper.column.field} = ?',
            whereArgs: [originalId, 'itemList'],
          );
        } else {
          addItemList = false;
        }
      }
      if (addItemList) {
        // register middle records
        await registerItemList(item, executor);
      }
      return object;
    });
  }

  Future<List<Map<String, Object?>>> convertReferences(
    List<Map<String, Object?>> mapList,
    _$AppDatabaseExecutor db,
    List<({String table, String column})> dropKeys,
  ) async {
    final itemListColumnList = <String>[];
    for (final col in appdb.orderToItemHelper.columnList) {
      itemListColumnList.add(
        '${appdb.orderToItemHelper.tableName}."$col" as "${_unquote(appdb.orderToItemHelper.tableName)}-$col"',
      );
    }
    for (final col in appdb.itemHelper.columnList) {
      itemListColumnList.add(
        '${appdb.itemHelper.tableName}."$col" as "${_unquote(appdb.itemHelper.tableName)}-$col"',
      );
    }
    final itemListSql =
        '''SELECT ${itemListColumnList.join(', ')} 
        FROM ${appdb.orderToItemHelper.tableName} 
        INNER JOIN ${appdb.itemHelper.tableName} 
        ON ${appdb.orderToItemHelper.tableName}.${appdb.orderToItemHelper.column.item} = 
        ${appdb.itemHelper.tableName}."id" 
        WHERE ${appdb.orderToItemHelper.tableName}.${appdb.orderToItemHelper.column.order} = ? 
        AND ${appdb.orderToItemHelper.tableName}.${appdb.orderToItemHelper.column.field} ='itemList' 
        ORDER BY ${appdb.itemHelper.tableName}.${appdb.itemHelper.column.name} ASC''';

    var result = mapList;
    result = result.toList(); // convert to modifiable list
    final batch = db.batch();

    for (var i = 0; i < result.length; i++) {
      var map = result[i];
      map = Map.from(map); // convert to modifiable map
      result[i] = map;

      // ignore: unused_local_variable
      final id = map['id'] as int;
      //print('Order($id) ${dropKeys.map((e) => '${_unquote(e.table)}.${_unquote(e.column)}').join(', ')}');
      for (final key in dropKeys) {
        if (_unquote(key.table) == 'order') {
          map.remove(_unquote(key.column));
        }
      }
      final userId = map['user_id'] as int?;
      if (userId != null) {
        batch.getUser(
          userId,
          dropKeys: dropKeys,
          onCommit: (noResult, object) async {
            map['user_id'] = object;
            return object;
          },
        );
      }
      if (dropKeys
          .where((e) => _unquote(e.table) == 'order' && e.column == 'item_list')
          .isEmpty) {
        batch.rawQuery(itemListSql, [id], (noResult, object) async {
          if (noResult == true || object is! List<Map<String, Object?>>) {
            throw StateError('returned object $object is not expected type.');
          }
          final middleList = object;
          var targetMapList = <Map<String, Object?>>[];
          for (final middleMap in middleList) {
            final targetMap = <String, Object?>{};
            for (final key in middleMap.keys) {
              if (key.startsWith('${_unquote(appdb.itemHelper.tableName)}-')) {
                final newKey = key.substring(
                  _unquote(appdb.itemHelper.tableName).length + 1,
                );
                targetMap[newKey] = middleMap[key];
              }
            }
            targetMapList.add(targetMap);
          }
          targetMapList = await appdb.itemHelper.convertReferences(
            targetMapList,
            db,
            [
              ...dropKeys,
              (table: appdb.itemHelper.tableName, column: 'order_list'),
            ],
          );
          final targetList = targetMapList
              .map((targetMap) => Item.fromSqlMap(targetMap))
              .toList();
          map['item_list'] = targetList;
          return targetList;
        });
      }
    }
    await batch.commit();

    return result;
  }

  /// convert map list from sql query to object list
  List<Order> mapToObject(List<Map<String, Object?>> mapList) {
    final result = mapList.map((map) => Order.fromSqlMap(map)).toList();
    return result;
  }

  Future<List<Order>> query(
    _$AppDatabaseExecutor db, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<({String table, String column})> dropKeys = const [],
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
    List<({String table, String column})> dropKeys = const [],
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

  Future<Order?> get(
    int id,
    _$AppDatabaseExecutor db, [
    List<({String table, String column})> dropKeys = const [],
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
    List<({String table, String column})> dropKeys = const [],
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
    // delete many to many middle records
    await db.deleteOrderToItem(
      where:
          '${appdb.orderToItemHelper.column.order} in (SELECT id FROM $tableName  ${where != null ? ' WHERE $where' : ''})',
      whereArgs: whereArgs,
    );
    return db.delete(tableName, where: where, whereArgs: whereArgs);
  }

  Future<void> deleteBatch(
    _$AppDatabaseBatchWrapper batch, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    // delete many to many middle records
    batch.deleteOrderToItem(
      where:
          '${appdb.orderToItemHelper.column.order} in (SELECT id FROM $tableName  ${where != null ? ' WHERE $where' : ''})',
      whereArgs: whereArgs,
    );
    batch.delete(tableName, where: where, whereArgs: whereArgs);
  }

  Future<int> deleteByIds(
    _$AppDatabaseExecutor db,
    List<Order> itemList,
  ) async {
    final noids = itemList.where((e) => e.id == 0);
    if (noids.isNotEmpty) {
      throw ArgumentError('Cannot delete Order because id is 0.');
    }
    final ids = itemList.map((e) => e.id).toSet().toList();

    // delete many to many middle records for itemList
    await db.deleteOrderToItem(
      where:
          '${appdb.orderToItemHelper.column.order} in (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );

    final count = await db.delete(
      tableName,
      where: '${column.id} in (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
    return count;
  }

  void deleteByIdsBatch(_$AppDatabaseBatchWrapper batch, List<Order> itemList) {
    final noids = itemList.where((e) => e.id == 0);
    if (noids.isNotEmpty) {
      throw ArgumentError('Cannot delete Order because id is 0.');
    }
    final ids = itemList.map((e) => e.id).toSet().toList();

    // delete many to many middle records for itemList
    batch.deleteOrderToItem(
      where:
          '${appdb.orderToItemHelper.column.order} in (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );

    batch.delete(
      tableName,
      where: '${column.id} in (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
  }
}

class _$CategoryHelper {
  final String tableName = '"category"';
  final column = (id: '"id"', name: '"name"');
  final columnTypes = {
    'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
    'name': 'TEXT NOT NULL DEFAULT \'\'',
  };
  final columnList = ['id', 'name'];

  _$AppDatabase appdb;

  _$CategoryHelper(this.appdb);

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
      params.add('"$column" ${columnTypes[column]}');
    }
    final sql = 'CREATE TABLE IF NOT EXISTS $tableName (${params.join(', ')})';
    //print('Creating table: $sql');
    if (db != null) {
      await db.execute(sql);
    } else if (batch != null) {
      batch.execute(sql);
    }

    final nameIndexSql =
        'CREATE UNIQUE INDEX IF NOT EXISTS "${_unquote(tableName)}_name_idx" ON $tableName ("name" ASC)';
    if (db != null) {
      await db.execute(nameIndexSql);
    } else if (batch != null) {
      batch.execute(nameIndexSql);
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

    final nameIndexSql =
        'CREATE UNIQUE INDEX IF NOT EXISTS "${_unquote(tableName)}_name_idx" ON $tableName ("name" ASC)';
    if (db != null) {
      await db.execute(nameIndexSql);
    } else if (batch != null) {
      batch.execute(nameIndexSql);
    }
  }

  static Map<String, Object?> toSqlMap(Category item) {
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

  static Category fromSqlMap(Map<String, Object?> map) {
    map = _unquoteMap(map);
    final keys = map.keys.toSet();
    final params = <String, Object>{};
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

    if (keys.contains('item_list')) {
      params['itemList'] = map['item_list'] as List<Item>;
      keys.remove('item_list');
    }

    if (keys.isNotEmpty) {
      throw ArgumentError('Unkown map keys. $keys');
    }

    final $item = Category(name, id: id);

    if (params['itemList'] != null) {
      $item.itemList = params['itemList'] as List<Item>;
    }
    return $item;
  }

  Future<int> register(Category item, _$AppDatabaseExecutor db) async {
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
    // set id if possible
    item.id = id;

    return id;
  }

  void registerBatch(Category item, _$AppDatabaseBatchWrapper batch) {
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
        // set id if possible
        item.id = object;
      }
      return object;
    });
  }

  Future<List<Map<String, Object?>>> convertReferences(
    List<Map<String, Object?>> mapList,
    _$AppDatabaseExecutor db,
    List<({String table, String column})> dropKeys,
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
      //print('Category($id) ${dropKeys.map((e) => '${_unquote(e.table)}.${_unquote(e.column)}').join(', ')}');
      for (final key in dropKeys) {
        if (_unquote(key.table) == 'category') {
          map.remove(_unquote(key.column));
        }
      }
      batch.queryItem(
        where: '${appdb.itemHelper.column.category} = ?',
        whereArgs: [id],
        orderBy: '${appdb.itemHelper.column.id} ASC',
        dropKeys: [
          (
            table: appdb.itemHelper.tableName,
            column: appdb.itemHelper.column.category,
          ),
          ...dropKeys,
        ],
        onCommit: (noResult, object) async {
          if (noResult == true || object is! List<Item>) {
            throw StateError('returned object $object is not expected type.');
          }
          map['item_list'] = object;
          return object;
        },
      );
    }
    await batch.commit();

    return result;
  }

  /// convert map list from sql query to object list
  List<Category> mapToObject(List<Map<String, Object?>> mapList) {
    final result = mapList.map((map) => Category.fromSqlMap(map)).toList();
    for (final object in result) {
      for (final item in object.itemList) {
        item.category = object;
      }
    }
    return result;
  }

  Future<List<Category>> query(
    _$AppDatabaseExecutor db, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<({String table, String column})> dropKeys = const [],
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
    List<({String table, String column})> dropKeys = const [],
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

  Future<Category?> get(
    int id,
    _$AppDatabaseExecutor db, [
    List<({String table, String column})> dropKeys = const [],
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
    List<({String table, String column})> dropKeys = const [],
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
    List<Category> itemList,
  ) async {
    final noids = itemList.where((e) => e.id == 0);
    if (noids.isNotEmpty) {
      throw ArgumentError('Cannot delete Category because id is 0.');
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
    List<Category> itemList,
  ) {
    final noids = itemList.where((e) => e.id == 0);
    if (noids.isNotEmpty) {
      throw ArgumentError('Cannot delete Category because id is 0.');
    }
    final ids = itemList.map((e) => e.id).toSet().toList();

    batch.delete(
      tableName,
      where: '${column.id} in (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
  }
}

class _$ItemHelper {
  final String tableName = '"item"';
  final column = (id: '"id"', name: '"name"', category: '"category_id"');
  final columnTypes = {
    'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
    'name': 'TEXT NOT NULL DEFAULT \'\'',
    'category_id': 'INTEGER REFERENCES "category"("id")',
  };
  final columnList = ['id', 'name', 'category_id'];

  _$AppDatabase appdb;

  _$ItemHelper(this.appdb);

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
      params.add('"$column" ${columnTypes[column]}');
    }
    final sql = 'CREATE TABLE IF NOT EXISTS $tableName (${params.join(', ')})';
    //print('Creating table: $sql');
    if (db != null) {
      await db.execute(sql);
    } else if (batch != null) {
      batch.execute(sql);
    }

    final nameIndexSql =
        'CREATE UNIQUE INDEX IF NOT EXISTS "${_unquote(tableName)}_name_idx" ON $tableName ("name" ASC)';
    if (db != null) {
      await db.execute(nameIndexSql);
    } else if (batch != null) {
      batch.execute(nameIndexSql);
    }
    final categoryIndexSql =
        'CREATE  INDEX IF NOT EXISTS "${_unquote(tableName)}_category_id_idx" ON $tableName ("category_id" ASC)';
    if (db != null) {
      await db.execute(categoryIndexSql);
    } else if (batch != null) {
      batch.execute(categoryIndexSql);
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

    final nameIndexSql =
        'CREATE UNIQUE INDEX IF NOT EXISTS "${_unquote(tableName)}_name_idx" ON $tableName ("name" ASC)';
    if (db != null) {
      await db.execute(nameIndexSql);
    } else if (batch != null) {
      batch.execute(nameIndexSql);
    }
    final categoryIndexSql =
        'CREATE  INDEX IF NOT EXISTS "${_unquote(tableName)}_category_id_idx" ON $tableName ("category_id" ASC)';
    if (db != null) {
      await db.execute(categoryIndexSql);
    } else if (batch != null) {
      batch.execute(categoryIndexSql);
    }
  }

  static Map<String, Object?> toSqlMap(Item item) {
    final values = <String, Object?>{};

    if (item.id != 0) {
      values['id'] = item.id;
    }

    values['name'] = item.name;

    if (item.category != null) {
      final categoryId = item.category!.id;
      if (categoryId != 0) {
        values['category_id'] = categoryId;
      } else {
        throw StateError('Item.category.id is 0.');
      }
    }

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

  static Item fromSqlMap(Map<String, Object?> map) {
    map = _unquoteMap(map);
    final keys = map.keys.toSet();
    final params = <String, Object>{};
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

    Category? category;
    if (keys.contains('category_id')) {
      category = map['category_id'] as Category?;
      keys.remove('category_id');
    }

    if (keys.contains('order_list')) {
      params['orderList'] = map['order_list'] as List<Order>;
      keys.remove('order_list');
    }

    if (keys.isNotEmpty) {
      throw ArgumentError('Unkown map keys. $keys');
    }

    final $item = Item(name, id: id, category: category);

    if (params['orderList'] != null) {
      $item.orderList = params['orderList'] as List<Order>;
    }
    return $item;
  }

  Future<int> register(Item item, _$AppDatabaseExecutor db) async {
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
    // set id if possible
    item.id = id;

    return id;
  }

  void registerBatch(Item item, _$AppDatabaseBatchWrapper batch) {
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
        // set id if possible
        item.id = object;
      }
      return object;
    });
  }

  Future<List<Map<String, Object?>>> convertReferences(
    List<Map<String, Object?>> mapList,
    _$AppDatabaseExecutor db,
    List<({String table, String column})> dropKeys,
  ) async {
    final orderListColumnList = <String>[];
    for (final col in appdb.orderToItemHelper.columnList) {
      orderListColumnList.add(
        '${appdb.orderToItemHelper.tableName}."$col" as "${_unquote(appdb.orderToItemHelper.tableName)}-$col"',
      );
    }
    for (final col in appdb.orderHelper.columnList) {
      orderListColumnList.add(
        '${appdb.orderHelper.tableName}."$col" as "${_unquote(appdb.orderHelper.tableName)}-$col"',
      );
    }
    final orderListSql =
        '''SELECT ${orderListColumnList.join(', ')} 
        FROM ${appdb.orderToItemHelper.tableName} 
        INNER JOIN ${appdb.orderHelper.tableName} 
        ON ${appdb.orderToItemHelper.tableName}.${appdb.orderToItemHelper.column.order} = 
        ${appdb.orderHelper.tableName}."id" 
        WHERE ${appdb.orderToItemHelper.tableName}.${appdb.orderToItemHelper.column.item} = ? 
        AND ${appdb.orderToItemHelper.tableName}.${appdb.orderToItemHelper.column.field} ='itemList' 
        ORDER BY ${appdb.orderHelper.tableName}.${appdb.orderHelper.column.id} ASC''';

    var result = mapList;
    result = result.toList(); // convert to modifiable list
    final batch = db.batch();

    for (var i = 0; i < result.length; i++) {
      var map = result[i];
      map = Map.from(map); // convert to modifiable map
      result[i] = map;

      // ignore: unused_local_variable
      final id = map['id'] as int;
      //print('Item($id) ${dropKeys.map((e) => '${_unquote(e.table)}.${_unquote(e.column)}').join(', ')}');
      for (final key in dropKeys) {
        if (_unquote(key.table) == 'item') {
          map.remove(_unquote(key.column));
        }
      }
      final categoryId = map['category_id'] as int?;
      if (categoryId != null) {
        batch.getCategory(
          categoryId,
          dropKeys: dropKeys,
          onCommit: (noResult, object) async {
            map['category_id'] = object;
            return object;
          },
        );
      }
      if (dropKeys
          .where((e) => _unquote(e.table) == 'item' && e.column == 'order_list')
          .isEmpty) {
        batch.rawQuery(orderListSql, [id], (noResult, object) async {
          if (noResult == true || object is! List<Map<String, Object?>>) {
            throw StateError('returned object $object is not expected type.');
          }
          final middleList = object;
          var targetMapList = <Map<String, Object?>>[];
          for (final middleMap in middleList) {
            final targetMap = <String, Object?>{};
            for (final key in middleMap.keys) {
              if (key.startsWith('${_unquote(appdb.orderHelper.tableName)}-')) {
                final newKey = key.substring(
                  _unquote(appdb.orderHelper.tableName).length + 1,
                );
                targetMap[newKey] = middleMap[key];
              }
            }
            targetMapList.add(targetMap);
          }
          targetMapList = await appdb.orderHelper.convertReferences(
            targetMapList,
            db,
            [
              ...dropKeys,
              (table: appdb.orderHelper.tableName, column: 'item_list'),
            ],
          );
          final targetList = targetMapList
              .map((targetMap) => Order.fromSqlMap(targetMap))
              .toList();
          map['order_list'] = targetList;
          return targetList;
        });
      }
    }
    await batch.commit();

    return result;
  }

  /// convert map list from sql query to object list
  List<Item> mapToObject(List<Map<String, Object?>> mapList) {
    final result = mapList.map((map) => Item.fromSqlMap(map)).toList();
    return result;
  }

  Future<List<Item>> query(
    _$AppDatabaseExecutor db, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<({String table, String column})> dropKeys = const [],
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
    List<({String table, String column})> dropKeys = const [],
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

  Future<Item?> get(
    int id,
    _$AppDatabaseExecutor db, [
    List<({String table, String column})> dropKeys = const [],
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
    List<({String table, String column})> dropKeys = const [],
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

  Future<int> deleteByIds(_$AppDatabaseExecutor db, List<Item> itemList) async {
    final noids = itemList.where((e) => e.id == 0);
    if (noids.isNotEmpty) {
      throw ArgumentError('Cannot delete Item because id is 0.');
    }
    final ids = itemList.map((e) => e.id).toSet().toList();

    final count = await db.delete(
      tableName,
      where: '${column.id} in (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
    return count;
  }

  void deleteByIdsBatch(_$AppDatabaseBatchWrapper batch, List<Item> itemList) {
    final noids = itemList.where((e) => e.id == 0);
    if (noids.isNotEmpty) {
      throw ArgumentError('Cannot delete Item because id is 0.');
    }
    final ids = itemList.map((e) => e.id).toSet().toList();

    batch.delete(
      tableName,
      where: '${column.id} in (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
  }
}

class _$OrderToItemHelper {
  final String tableName = '"order_to_item"';
  final column = (
    id: '"id"',
    order: '"order_id"',
    item: '"item_id"',
    field: '"field"',
  );
  final columnTypes = {
    'id': 'INTEGER PRIMARY KEY AUTOINCREMENT',
    'order_id': 'INTEGER REFERENCES "order"("id")',
    'item_id': 'INTEGER REFERENCES "item"("id")',
    'field': 'TEXT NOT NULL DEFAULT \'\'',
  };
  final columnList = ['id', 'order_id', 'item_id', 'field'];

  _$AppDatabase appdb;

  _$OrderToItemHelper(this.appdb);

  static final v1ColumnList = ['id', 'order_id', 'item_id', 'field'];
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
        "No columns defined for OrderToItem version $version",
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

    final orderIndexSql =
        'CREATE  INDEX IF NOT EXISTS "${_unquote(tableName)}_order_id_idx" ON $tableName ("order_id" ASC)';
    if (db != null) {
      await db.execute(orderIndexSql);
    } else if (batch != null) {
      batch.execute(orderIndexSql);
    }
    final itemIndexSql =
        'CREATE  INDEX IF NOT EXISTS "${_unquote(tableName)}_item_id_idx" ON $tableName ("item_id" ASC)';
    if (db != null) {
      await db.execute(itemIndexSql);
    } else if (batch != null) {
      batch.execute(itemIndexSql);
    }
    final fieldIndexSql =
        'CREATE  INDEX IF NOT EXISTS "${_unquote(tableName)}_field_idx" ON $tableName ("field" ASC)';
    if (db != null) {
      await db.execute(fieldIndexSql);
    } else if (batch != null) {
      batch.execute(fieldIndexSql);
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

    final orderIndexSql =
        'CREATE  INDEX IF NOT EXISTS "${_unquote(tableName)}_order_id_idx" ON $tableName ("order_id" ASC)';
    if (db != null) {
      await db.execute(orderIndexSql);
    } else if (batch != null) {
      batch.execute(orderIndexSql);
    }
    final itemIndexSql =
        'CREATE  INDEX IF NOT EXISTS "${_unquote(tableName)}_item_id_idx" ON $tableName ("item_id" ASC)';
    if (db != null) {
      await db.execute(itemIndexSql);
    } else if (batch != null) {
      batch.execute(itemIndexSql);
    }
    final fieldIndexSql =
        'CREATE  INDEX IF NOT EXISTS "${_unquote(tableName)}_field_idx" ON $tableName ("field" ASC)';
    if (db != null) {
      await db.execute(fieldIndexSql);
    } else if (batch != null) {
      batch.execute(fieldIndexSql);
    }
  }

  static Map<String, Object?> toSqlMap(OrderToItem item) {
    final values = <String, Object?>{};

    if (item.id != 0) {
      values['id'] = item.id;
    }

    if (item.order != null) {
      final orderId = item.order!.id;
      if (orderId != 0) {
        values['order_id'] = orderId;
      } else {
        throw StateError('OrderToItem.order.id is 0.');
      }
    }

    if (item.item != null) {
      final itemId = item.item!.id;
      if (itemId != 0) {
        values['item_id'] = itemId;
      } else {
        throw StateError('OrderToItem.item.id is 0.');
      }
    }

    values['field'] = item.field;

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

  static OrderToItem fromSqlMap(Map<String, Object?> map) {
    map = _unquoteMap(map);
    final keys = map.keys.toSet();
    if (!keys.contains('field')) {
      throw ArgumentError("Missing required key field in map");
    }

    var id = 0;
    if (keys.contains('id')) {
      id = map['id'] as int;
      keys.remove('id');
    }

    Order? order;
    if (keys.contains('order_id')) {
      order = map['order_id'] as Order?;
      keys.remove('order_id');
    }

    Item? item;
    if (keys.contains('item_id')) {
      item = map['item_id'] as Item?;
      keys.remove('item_id');
    }

    final field = map['field'] as String;
    keys.remove('field');

    if (keys.isNotEmpty) {
      throw ArgumentError('Unkown map keys. $keys');
    }

    final $item = OrderToItem(id: id, order: order, item: item, field: field);

    return $item;
  }

  Future<int> register(OrderToItem item, _$AppDatabaseExecutor db) async {
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
    // set id if possible
    item.id = id;

    return id;
  }

  void registerBatch(OrderToItem item, _$AppDatabaseBatchWrapper batch) {
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
        // set id if possible
        item.id = object;
      }
      return object;
    });
  }

  Future<List<Map<String, Object?>>> convertReferences(
    List<Map<String, Object?>> mapList,
    _$AppDatabaseExecutor db,
    List<({String table, String column})> dropKeys,
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
      //print('OrderToItem($id) ${dropKeys.map((e) => '${_unquote(e.table)}.${_unquote(e.column)}').join(', ')}');
      for (final key in dropKeys) {
        if (_unquote(key.table) == 'order_to_item') {
          map.remove(_unquote(key.column));
        }
      }
      final orderId = map['order_id'] as int?;
      if (orderId != null) {
        batch.getOrder(
          orderId,
          dropKeys: dropKeys,
          onCommit: (noResult, object) async {
            map['order_id'] = object;
            return object;
          },
        );
      }
      final itemId = map['item_id'] as int?;
      if (itemId != null) {
        batch.getItem(
          itemId,
          dropKeys: dropKeys,
          onCommit: (noResult, object) async {
            map['item_id'] = object;
            return object;
          },
        );
      }
    }
    await batch.commit();

    return result;
  }

  /// convert map list from sql query to object list
  List<OrderToItem> mapToObject(List<Map<String, Object?>> mapList) {
    final result = mapList.map((map) => OrderToItem.fromSqlMap(map)).toList();
    return result;
  }

  Future<List<OrderToItem>> query(
    _$AppDatabaseExecutor db, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<({String table, String column})> dropKeys = const [],
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
    List<({String table, String column})> dropKeys = const [],
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

  Future<OrderToItem?> get(
    int id,
    _$AppDatabaseExecutor db, [
    List<({String table, String column})> dropKeys = const [],
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
    List<({String table, String column})> dropKeys = const [],
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
    List<OrderToItem> itemList,
  ) async {
    final noids = itemList.where((e) => e.id == 0);
    if (noids.isNotEmpty) {
      throw ArgumentError('Cannot delete OrderToItem because id is 0.');
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
    List<OrderToItem> itemList,
  ) {
    final noids = itemList.where((e) => e.id == 0);
    if (noids.isNotEmpty) {
      throw ArgumentError('Cannot delete OrderToItem because id is 0.');
    }
    final ids = itemList.map((e) => e.id).toSet().toList();

    batch.delete(
      tableName,
      where: '${column.id} in (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
  }
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends
        $FunctionalProvider<
          AsyncValue<AppDatabase>,
          AppDatabase,
          FutureOr<AppDatabase>
        >
    with $FutureModifier<AppDatabase>, $FutureProvider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $FutureProviderElement<AppDatabase> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AppDatabase> create(Ref ref) {
    return appDatabase(ref);
  }
}

String _$appDatabaseHash() => r'3ac0eebd8fc912d0e0e119cfb846a339612fcae8';

@ProviderFor(categoryList)
final categoryListProvider = CategoryListProvider._();

final class CategoryListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          FutureOr<List<Category>>
        >
    with $FutureModifier<List<Category>>, $FutureProvider<List<Category>> {
  CategoryListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryListHash();

  @$internal
  @override
  $FutureProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Category>> create(Ref ref) {
    return categoryList(ref);
  }
}

String _$categoryListHash() => r'd9348612515ac9e4460df39580e446b24cfff63f';

@ProviderFor(userList)
final userListProvider = UserListProvider._();

final class UserListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<User>>,
          List<User>,
          FutureOr<List<User>>
        >
    with $FutureModifier<List<User>>, $FutureProvider<List<User>> {
  UserListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userListHash();

  @$internal
  @override
  $FutureProviderElement<List<User>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<User>> create(Ref ref) {
    return userList(ref);
  }
}

String _$userListHash() => r'ec9698881455f44f690128a1e35ba1f2851ada84';
