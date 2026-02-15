// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'many_to_many_test.dart';

// **************************************************************************
// DatabaseGenerator
// **************************************************************************

abstract class _$AppDatabaseExecutor extends DatabaseExecutor {
  @override
  _$AppDatabaseBatchWrapper batch();

  /// Insert or update Cart.
  /// If id is 0, insert and sets id to generated value.
  /// If specified id already exists in table, update the record.
  /// If specified id does not exist in table, insert with the id.
  Future<int> registerCart(Cart item);

  Future<List<Cart>> queryCart({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String> dropKeys = const [],
  });

  Future<Cart?> getCart(int id, [List<String> dropKeys = const []]);

  Future<int> deleteCart({String? where, List<Object?>? whereArgs});

  Future<int> deleteCartByIds(List<Cart> itemList);

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
    List<String> dropKeys = const [],
  });

  Future<Item?> getItem(int id, [List<String> dropKeys = const []]);

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
    List<String> dropKeys = const [],
  });

  Future<OrderToItem?> getOrderToItem(
    int id, [
    List<String> dropKeys = const [],
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
  Future<int> registerCart(Cart item) => appdb.cartHelper.register(item, this);

  @override
  Future<List<Cart>> queryCart({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String> dropKeys = const [],
  }) => appdb.cartHelper.query(
    this,
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    dropKeys: dropKeys,
  );

  @override
  Future<Cart?> getCart(int id, [List<String> dropKeys = const []]) =>
      appdb.cartHelper.get(id, this, dropKeys);

  @override
  Future<int> deleteCart({String? where, List<Object?>? whereArgs}) =>
      appdb.cartHelper.delete(this, where: where, whereArgs: whereArgs);

  @override
  Future<int> deleteCartByIds(List<Cart> itemList) =>
      appdb.cartHelper.deleteByIds(this, itemList);

  @override
  Future<int> registerItem(Item item) => appdb.itemHelper.register(item, this);

  @override
  Future<List<Item>> queryItem({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String> dropKeys = const [],
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
  Future<Item?> getItem(int id, [List<String> dropKeys = const []]) =>
      appdb.itemHelper.get(id, this, dropKeys);

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
    List<String> dropKeys = const [],
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
    List<String> dropKeys = const [],
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

  void registerCart(
    Cart item, [
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    appdb.cartHelper.registerBatch(item, this);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void queryCart({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String> dropKeys = const [],
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.cartHelper.queryBatch(
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

  void getCart(
    int id, {
    List<String> dropKeys = const [],
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.cartHelper.getBatch(id, this, dropKeys);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void deleteCart({
    String? where,
    List<Object?>? whereArgs,
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  }) {
    appdb.cartHelper.deleteBatch(this, where: where, whereArgs: whereArgs);
    if (onCommit != null) {
      _addCallBack(callBackIndex - 1, onCommit);
    }
  }

  void deleteCartByIds(
    List<Cart> itemList, [
    Future<Object?> Function(bool? noResult, Object?)? onCommit,
  ]) {
    appdb.cartHelper.deleteByIdsBatch(this, itemList);
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
    List<String> dropKeys = const [],
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
    List<String> dropKeys = const [],
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
    List<String> dropKeys = const [],
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
    List<String> dropKeys = const [],
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

  late final cartHelper = _$CartHelper(this);
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
    await cartHelper.onCreate(version, batch: batch);
    await itemHelper.onCreate(version, batch: batch);
    await orderToItemHelper.onCreate(version, batch: batch);
    await batch.commit();
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    final batch = db.batch();
    await cartHelper.onUpgrade(oldVersion, newVersion, batch: batch);
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

  /// Insert or update Cart.
  /// If id is 0, insert and sets id to generated value.
  /// If specified id already exists in table, update the record.
  /// If specified id does not exist in table, insert with the id.
  @override
  Future<int> registerCart(Cart item) => cartHelper.register(item, this);

  @override
  Future<List<Cart>> queryCart({
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
    int? offset,
    List<String> dropKeys = const [],
  }) => cartHelper.query(
    this,
    where: where,
    whereArgs: whereArgs,
    orderBy: orderBy,
    limit: limit,
    offset: offset,
    dropKeys: dropKeys,
  );

  @override
  Future<Cart?> getCart(int id, [List<String> dropKeys = const []]) =>
      cartHelper.get(id, this, dropKeys);

  @override
  Future<int> deleteCart({String? where, List<Object?>? whereArgs}) =>
      cartHelper.delete(this, where: where, whereArgs: whereArgs);

  @override
  Future<int> deleteCartByIds(List<Cart> itemsList) =>
      cartHelper.deleteByIds(this, itemsList);

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
    List<String> dropKeys = const [],
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
  Future<Item?> getItem(int id, [List<String> dropKeys = const []]) =>
      itemHelper.get(id, this, dropKeys);

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
    List<String> dropKeys = const [],
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
    List<String> dropKeys = const [],
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

class _$CartHelper {
  final String tableName = 'cart';
  final column = (id: 'id', user: 'user');
  final columnTypes = {
    'id': "INTEGER PRIMARY KEY AUTOINCREMENT",
    'user': "TEXT NOT NULL DEFAULT ''",
  };
  final columnList = ['id', 'user'];

  _$AppDatabase appdb;

  _$CartHelper(this.appdb);

  static final v1ColumnList = ['id', 'user'];
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
      throw UnsupportedError("No columns defined for Cart version $version");
    }
    var params = [];
    for (final column in columnList) {
      params.add('$column ${columnTypes[column]}');
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
          'ALTER TABLE $tableName ADD COLUMN $column ${columnTypes[column]}';
      print('Altering table: $sql');
      if (db != null) {
        await db.execute(sql);
      } else if (batch != null) {
        batch.execute(sql);
      }
    }
  }

  static Map<String, Object?> toSqlMap(Cart item) {
    final values = <String, Object?>{};

    if (item.id != 0) {
      values["id"] = item.id;
    }

    values["user"] = item.user;

    return values;
  }

  static Cart fromSqlMap(Map<String, Object?> map) {
    final keys = map.keys.toSet();
    final params = <String, Object>{};
    if (!keys.contains("user")) {
      throw ArgumentError("Missing required key user in map");
    }

    var id = 0;
    if (keys.contains('id')) {
      id = map['id'] as int;
      keys.remove("id");
    }

    final user = map['user'] as String;
    keys.remove("user");

    if (keys.contains('item_list')) {
      params['itemList'] = map['item_list'] as List<Item>;
      keys.remove("item_list");
    }

    if (keys.contains('item_list2')) {
      params['itemList2'] = map['item_list2'] as List<Item>;
      keys.remove("item_list2");
    }

    if (keys.isNotEmpty) {
      throw ArgumentError('Unkown map keys. $keys');
    }

    final $item = Cart(user, id: id);

    if (params['itemList'] != null) {
      $item.itemList = params['itemList'] as List<Item>;
    }
    if (params['itemList2'] != null) {
      $item.itemList2 = params['itemList2'] as List<Item>;
    }
    return $item;
  }

  bool compareItemList(Cart item1, Set<int> set2) {
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

  bool compareItemList2(Cart item1, Set<int> set2) {
    if (item1.itemList2.length != set2.length) {
      return false;
    }
    final list1 = item1.itemList2.map((e) => e.id).toList();
    for (final item in list1) {
      if (!set2.contains(item)) {
        return false;
      }
    }
    return true;
  }

  Future<void> registerItemList(
    Cart item,
    _$AppDatabaseExecutor executor,
  ) async {
    final batch = executor.batch();
    for (final target in item.itemList) {
      Map<String, Object?> middleMap = {};
      middleMap[appdb.orderToItemHelper.column.cart] = item;
      middleMap[appdb.orderToItemHelper.column.item] = target;
      middleMap[appdb.orderToItemHelper.column.field] = 'itemList';
      final middle = OrderToItem.fromSqlMap(middleMap);
      batch.registerOrderToItem(middle);
    }
    await batch.commit();
  }

  Future<void> registerItemList2(
    Cart item,
    _$AppDatabaseExecutor executor,
  ) async {
    final batch = executor.batch();
    for (final target in item.itemList2) {
      Map<String, Object?> middleMap = {};
      middleMap[appdb.orderToItemHelper.column.cart] = item;
      middleMap[appdb.orderToItemHelper.column.item] = target;
      middleMap[appdb.orderToItemHelper.column.field] = 'itemList2';
      final middle = OrderToItem.fromSqlMap(middleMap);
      batch.registerOrderToItem(middle);
    }
    await batch.commit();
  }

  Future<int> register(Cart item, _$AppDatabaseExecutor db) async {
    final itemListNoids = item.itemList.where((e) => e.id == 0);
    if (itemListNoids.isNotEmpty) {
      throw ArgumentError(
        'Cannot register Cart because itemList has unregistered items.',
      );
    }
    if (item.itemList.length != item.itemList.toSet().length) {
      throw ArgumentError(
        'Cannot register Cart because itemList has duplicate items.',
      );
    }
    final itemList2Noids = item.itemList2.where((e) => e.id == 0);
    if (itemList2Noids.isNotEmpty) {
      throw ArgumentError(
        'Cannot register Cart because itemList2 has unregistered items.',
      );
    }
    if (item.itemList2.length != item.itemList2.toSet().length) {
      throw ArgumentError(
        'Cannot register Cart because itemList2 has duplicate items.',
      );
    }
    final map = item.toSqlMap();
    var command = 'REPLACE INTO';
    final originalId = item.id;
    if (originalId == 0) {
      command = 'INSERT INTO';
    }
    final sql =
        '$command $tableName (${map.keys.join(',')}) VALUES (${List.filled(map.length, '?').join(', ')})';
    // print('register sql: $sql');
    // print('args: ${map.values.toList()}');
    final id = await db.rawInsert(sql, map.values.toList());
    item.id = id;

    final executor = db;
    // handle many to many relation for itemList
    bool addItemList = true;
    if (originalId != 0) {
      // compare existing middle records
      final existingMiddleList = await executor.query(
        appdb.orderToItemHelper.tableName,
        where:
            '${appdb.orderToItemHelper.column.cart} = ? AND ${appdb.orderToItemHelper.column.field} = ?',
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
              '${appdb.orderToItemHelper.column.cart} = ? AND ${appdb.orderToItemHelper.column.field} = ?',
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
    // handle many to many relation for itemList2
    bool addItemList2 = true;
    if (originalId != 0) {
      // compare existing middle records
      final existingMiddleList = await executor.query(
        appdb.orderToItemHelper.tableName,
        where:
            '${appdb.orderToItemHelper.column.cart} = ? AND ${appdb.orderToItemHelper.column.field} = ?',
        whereArgs: [originalId, 'itemList2'],
      );
      final existingTargetIds = existingMiddleList
          .where((e) => e[appdb.orderToItemHelper.column.item] != null)
          .map((e) => e[appdb.orderToItemHelper.column.item] as int)
          .toSet();
      if (!compareItemList2(item, existingTargetIds)) {
        // delete middle records
        await executor.deleteOrderToItem(
          where:
              '${appdb.orderToItemHelper.column.cart} = ? AND ${appdb.orderToItemHelper.column.field} = ?',
          whereArgs: [originalId, 'itemList2'],
        );
      } else {
        addItemList2 = false;
      }
    }
    if (addItemList2) {
      // register middle records
      await registerItemList2(item, executor);
    }

    return id;
  }

  void registerBatch(Cart item, _$AppDatabaseBatchWrapper batch) {
    final itemListNoids = item.itemList.where((e) => e.id == 0);
    if (itemListNoids.isNotEmpty) {
      throw ArgumentError(
        'Cannot register Cart because itemList has unregistered items.',
      );
    }
    if (item.itemList.length != item.itemList.toSet().length) {
      throw ArgumentError(
        'Cannot register Cart because itemList has duplicate items.',
      );
    }
    final itemList2Noids = item.itemList2.where((e) => e.id == 0);
    if (itemList2Noids.isNotEmpty) {
      throw ArgumentError(
        'Cannot register Cart because itemList2 has unregistered items.',
      );
    }
    if (item.itemList2.length != item.itemList2.toSet().length) {
      throw ArgumentError(
        'Cannot register Cart because itemList2 has duplicate items.',
      );
    }
    final map = item.toSqlMap();
    var command = 'REPLACE INTO';
    final originalId = item.id;
    if (originalId == 0) {
      command = 'INSERT INTO';
    }
    final sql =
        '$command $tableName (${map.keys.join(',')}) VALUES (${List.filled(map.length, '?').join(', ')})';
    // print('register sql: $sql');
    // print('args: ${map.values.toList()}');
    batch.rawInsert(sql, map.values.toList(), (noResult, object) async {
      final executor = batch.executor;
      if (item.id == 0) {
        if (noResult == true || object is! int) {
          throw StateError('returned object $object is not int.');
        }
        item.id = object;
      }
      // handle many to many relation for itemList
      bool addItemList = true;
      if (originalId != 0) {
        // compare existing middle records
        final existingMiddleList = await executor.query(
          appdb.orderToItemHelper.tableName,
          where:
              '${appdb.orderToItemHelper.column.cart} = ? AND ${appdb.orderToItemHelper.column.field} = ?',
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
                '${appdb.orderToItemHelper.column.cart} = ? AND ${appdb.orderToItemHelper.column.field} = ?',
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
      // handle many to many relation for itemList2
      bool addItemList2 = true;
      if (originalId != 0) {
        // compare existing middle records
        final existingMiddleList = await executor.query(
          appdb.orderToItemHelper.tableName,
          where:
              '${appdb.orderToItemHelper.column.cart} = ? AND ${appdb.orderToItemHelper.column.field} = ?',
          whereArgs: [originalId, 'itemList2'],
        );
        final existingTargetIds = existingMiddleList
            .where((e) => e[appdb.orderToItemHelper.column.item] != null)
            .map((e) => e[appdb.orderToItemHelper.column.item] as int)
            .toSet();
        if (!compareItemList2(item, existingTargetIds)) {
          // delete middle records
          await executor.deleteOrderToItem(
            where:
                '${appdb.orderToItemHelper.column.cart} = ? AND ${appdb.orderToItemHelper.column.field} = ?',
            whereArgs: [originalId, 'itemList2'],
          );
        } else {
          addItemList2 = false;
        }
      }
      if (addItemList2) {
        // register middle records
        await registerItemList2(item, executor);
      }
      return object;
    });
  }

  Future<List<Map<String, Object?>>> convertReferences(
    List<Map<String, Object?>> mapList,
    _$AppDatabaseExecutor db,
    List<String> dropKeys,
  ) async {
    final itemListColumnList = <String>[];
    for (final col in appdb.orderToItemHelper.columnList) {
      itemListColumnList.add(
        '${appdb.orderToItemHelper.tableName}.$col as "${appdb.orderToItemHelper.tableName}-$col"',
      );
    }
    for (final col in appdb.itemHelper.columnList) {
      itemListColumnList.add(
        '${appdb.itemHelper.tableName}.$col as "${appdb.itemHelper.tableName}-$col"',
      );
    }
    final itemListSql =
        '''SELECT ${itemListColumnList.join(', ')} 
        FROM ${appdb.orderToItemHelper.tableName} 
        INNER JOIN ${appdb.itemHelper.tableName} 
        ON ${appdb.orderToItemHelper.tableName}.${appdb.orderToItemHelper.column.item} = 
        ${appdb.itemHelper.tableName}.id 
        WHERE ${appdb.orderToItemHelper.tableName}.${appdb.orderToItemHelper.column.cart} = ? 
        AND ${appdb.orderToItemHelper.tableName}.${appdb.orderToItemHelper.column.field} ='itemList' 
        ORDER BY ${appdb.itemHelper.tableName}.${appdb.itemHelper.column.name} DESC''';

    final itemList2ColumnList = <String>[];
    for (final col in appdb.orderToItemHelper.columnList) {
      itemList2ColumnList.add(
        '${appdb.orderToItemHelper.tableName}.$col as "${appdb.orderToItemHelper.tableName}-$col"',
      );
    }
    for (final col in appdb.itemHelper.columnList) {
      itemList2ColumnList.add(
        '${appdb.itemHelper.tableName}.$col as "${appdb.itemHelper.tableName}-$col"',
      );
    }
    final itemList2Sql =
        '''SELECT ${itemList2ColumnList.join(', ')} 
        FROM ${appdb.orderToItemHelper.tableName} 
        INNER JOIN ${appdb.itemHelper.tableName} 
        ON ${appdb.orderToItemHelper.tableName}.${appdb.orderToItemHelper.column.item} = 
        ${appdb.itemHelper.tableName}.id 
        WHERE ${appdb.orderToItemHelper.tableName}.${appdb.orderToItemHelper.column.cart} = ? 
        AND ${appdb.orderToItemHelper.tableName}.${appdb.orderToItemHelper.column.field} ='itemList2' 
        ORDER BY ${appdb.itemHelper.tableName}.${appdb.itemHelper.column.name} DESC''';

    var result = mapList;
    result = result.toList(); // convert to modifiable list
    final batch = db.batch();

    for (var i = 0; i < result.length; i++) {
      var map = result[i];
      map = Map.from(map); // convert to modifiable map
      result[i] = map;

      // ignore: unused_local_variable
      final id = map[column.id] as int;
      //print('Cart($id) $dropKeys');
      for (final key in dropKeys) {
        map.remove(key);
      }
      if (!dropKeys.contains('item_list')) {
        batch.rawQuery(itemListSql, [id], (noResult, object) async {
          if (noResult == true || object is! List<Map<String, Object?>>) {
            throw StateError('returned object $object is not expected type.');
          }
          final middleList = object;
          final targetList = <Item>[];
          for (final middleMap in middleList) {
            final targetMap = <String, Object?>{};
            for (final key in middleMap.keys) {
              if (key.startsWith('${appdb.itemHelper.tableName}-')) {
                final newKey = key.substring(
                  appdb.itemHelper.tableName.length + 1,
                );
                targetMap[newKey] = middleMap[key];
              }
            }
            final target = Item.fromSqlMap(targetMap);
            targetList.add(target);
          }
          map['item_list'] = targetList;
          return targetList;
        });
      }

      if (!dropKeys.contains('item_list2')) {
        batch.rawQuery(itemList2Sql, [id], (noResult, object) async {
          if (noResult == true || object is! List<Map<String, Object?>>) {
            throw StateError('returned object $object is not expected type.');
          }
          final middleList = object;
          final targetList = <Item>[];
          for (final middleMap in middleList) {
            final targetMap = <String, Object?>{};
            for (final key in middleMap.keys) {
              if (key.startsWith('${appdb.itemHelper.tableName}-')) {
                final newKey = key.substring(
                  appdb.itemHelper.tableName.length + 1,
                );
                targetMap[newKey] = middleMap[key];
              }
            }
            final target = Item.fromSqlMap(targetMap);
            targetList.add(target);
          }
          map['item_list2'] = targetList;
          return targetList;
        });
      }
    }
    await batch.commit();

    return result;
  }

  /// convert map list from sql query to object list
  List<Cart> mapToObject(List<Map<String, Object?>> mapList) {
    final result = mapList.map((map) => Cart.fromSqlMap(map)).toList();
    return result;
  }

  Future<List<Cart>> query(
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

  Future<Cart?> get(
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
    // delete many to many middle records
    await db.deleteOrderToItem(
      where:
          '${appdb.orderToItemHelper.column.cart} in (SELECT id FROM $tableName  ${where != null ? ' WHERE $where' : ''})',
      whereArgs: whereArgs,
    );
    await db.deleteOrderToItem(
      where:
          '${appdb.orderToItemHelper.column.cart} in (SELECT id FROM $tableName  ${where != null ? ' WHERE $where' : ''})',
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
          '${appdb.orderToItemHelper.column.cart} in (SELECT id FROM $tableName  ${where != null ? ' WHERE $where' : ''})',
      whereArgs: whereArgs,
    );
    batch.deleteOrderToItem(
      where:
          '${appdb.orderToItemHelper.column.cart} in (SELECT id FROM $tableName  ${where != null ? ' WHERE $where' : ''})',
      whereArgs: whereArgs,
    );
    batch.delete(tableName, where: where, whereArgs: whereArgs);
  }

  Future<int> deleteByIds(_$AppDatabaseExecutor db, List<Cart> itemList) async {
    final noids = itemList.where((e) => e.id == 0);
    if (noids.isNotEmpty) {
      throw ArgumentError(
        'Cannot delete Cart because it has unregistered items.',
      );
    }
    final ids = itemList.map((e) => e.id).toSet().toList();

    // delete many to many middle records for itemList
    await db.deleteOrderToItem(
      where:
          '${appdb.orderToItemHelper.column.cart} in (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
    // delete many to many middle records for itemList2
    await db.deleteOrderToItem(
      where:
          '${appdb.orderToItemHelper.column.cart} in (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );

    final count = await db.delete(
      tableName,
      where: '${column.id} in (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
    return count;
  }

  void deleteByIdsBatch(_$AppDatabaseBatchWrapper batch, List<Cart> itemList) {
    final noids = itemList.where((e) => e.id == 0);
    if (noids.isNotEmpty) {
      throw ArgumentError(
        'Cannot delete Cart because it has unregistered items.',
      );
    }
    final ids = itemList.map((e) => e.id).toSet().toList();

    // delete many to many middle records for itemList
    batch.deleteOrderToItem(
      where:
          '${appdb.orderToItemHelper.column.cart} in (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
    // delete many to many middle records for itemList2
    batch.deleteOrderToItem(
      where:
          '${appdb.orderToItemHelper.column.cart} in (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );

    batch.delete(
      tableName,
      where: '${column.id} in (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
  }
}

class _$ItemHelper {
  final String tableName = 'item';
  final column = (id: 'id', name: 'name');
  final columnTypes = {
    'id': "INTEGER PRIMARY KEY AUTOINCREMENT",
    'name': "TEXT NOT NULL DEFAULT ''",
  };
  final columnList = ['id', 'name'];

  _$AppDatabase appdb;

  _$ItemHelper(this.appdb);

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
      throw UnsupportedError("No columns defined for Item version $version");
    }
    var params = [];
    for (final column in columnList) {
      params.add('$column ${columnTypes[column]}');
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

    return values;
  }

  static Item fromSqlMap(Map<String, Object?> map) {
    final keys = map.keys.toSet();
    final params = <String, Object>{};
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

    if (keys.contains('order_list')) {
      params['orderList'] = map['order_list'] as List<Cart>;
      keys.remove("order_list");
    }

    if (keys.isNotEmpty) {
      throw ArgumentError('Unkown map keys. $keys');
    }

    final $item = Item(name, id: id);

    if (params['orderList'] != null) {
      $item.orderList = params['orderList'] as List<Cart>;
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
    final sql =
        '$command $tableName (${map.keys.join(',')}) VALUES (${List.filled(map.length, '?').join(', ')})';
    // print('register sql: $sql');
    // print('args: ${map.values.toList()}');
    final id = await db.rawInsert(sql, map.values.toList());
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
    final sql =
        '$command $tableName (${map.keys.join(',')}) VALUES (${List.filled(map.length, '?').join(', ')})';
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
    final orderListColumnList = <String>[];
    for (final col in appdb.orderToItemHelper.columnList) {
      orderListColumnList.add(
        '${appdb.orderToItemHelper.tableName}.$col as "${appdb.orderToItemHelper.tableName}-$col"',
      );
    }
    for (final col in appdb.cartHelper.columnList) {
      orderListColumnList.add(
        '${appdb.cartHelper.tableName}.$col as "${appdb.cartHelper.tableName}-$col"',
      );
    }
    final orderListSql =
        '''SELECT ${orderListColumnList.join(', ')} 
        FROM ${appdb.orderToItemHelper.tableName} 
        INNER JOIN ${appdb.cartHelper.tableName} 
        ON ${appdb.orderToItemHelper.tableName}.${appdb.orderToItemHelper.column.cart} = 
        ${appdb.cartHelper.tableName}.id 
        WHERE ${appdb.orderToItemHelper.tableName}.${appdb.orderToItemHelper.column.item} = ? 
        AND ${appdb.orderToItemHelper.tableName}.${appdb.orderToItemHelper.column.field} ='itemList' 
        ORDER BY ${appdb.cartHelper.tableName}.${appdb.cartHelper.column.id} ASC''';

    var result = mapList;
    result = result.toList(); // convert to modifiable list
    final batch = db.batch();

    for (var i = 0; i < result.length; i++) {
      var map = result[i];
      map = Map.from(map); // convert to modifiable map
      result[i] = map;

      // ignore: unused_local_variable
      final id = map[column.id] as int;
      //print('Item($id) $dropKeys');
      for (final key in dropKeys) {
        map.remove(key);
      }
      if (!dropKeys.contains('order_list')) {
        batch.rawQuery(orderListSql, [id], (noResult, object) async {
          if (noResult == true || object is! List<Map<String, Object?>>) {
            throw StateError('returned object $object is not expected type.');
          }
          final middleList = object;
          final targetList = <Cart>[];
          for (final middleMap in middleList) {
            final targetMap = <String, Object?>{};
            for (final key in middleMap.keys) {
              if (key.startsWith('${appdb.cartHelper.tableName}-')) {
                final newKey = key.substring(
                  appdb.cartHelper.tableName.length + 1,
                );
                targetMap[newKey] = middleMap[key];
              }
            }
            final target = Cart.fromSqlMap(targetMap);
            targetList.add(target);
          }
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

  Future<Item?> get(
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

  Future<int> deleteByIds(_$AppDatabaseExecutor db, List<Item> itemList) async {
    final noids = itemList.where((e) => e.id == 0);
    if (noids.isNotEmpty) {
      throw ArgumentError(
        'Cannot delete Item because it has unregistered items.',
      );
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
      throw ArgumentError(
        'Cannot delete Item because it has unregistered items.',
      );
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
  final String tableName = 'order_to_item';
  final column = (id: 'id', cart: 'cart_id', field: 'field', item: 'item_id');
  final columnTypes = {
    'id': "INTEGER PRIMARY KEY AUTOINCREMENT",
    'cart_id': "INTEGER REFERENCES cart(id)",
    'field': "TEXT NOT NULL DEFAULT ''",
    'item_id': "INTEGER REFERENCES item(id)",
  };
  final columnList = ['id', 'cart_id', 'field', 'item_id'];

  _$AppDatabase appdb;

  _$OrderToItemHelper(this.appdb);

  static final v1ColumnList = ['id', 'cart_id', 'field', 'item_id'];
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
      params.add('$column ${columnTypes[column]}');
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
          'ALTER TABLE $tableName ADD COLUMN $column ${columnTypes[column]}';
      print('Altering table: $sql');
      if (db != null) {
        await db.execute(sql);
      } else if (batch != null) {
        batch.execute(sql);
      }
    }
  }

  static Map<String, Object?> toSqlMap(OrderToItem item) {
    final values = <String, Object?>{};

    if (item.id != 0) {
      values["id"] = item.id;
    }

    if (item.cart != null) {
      final cartId = item.cart!.id;
      if (cartId != 0) {
        values["cart_id"] = cartId;
      } else {
        throw StateError('OrderToItem.cart.id is 0.');
      }
    }

    values["field"] = item.field;

    if (item.item != null) {
      final itemId = item.item!.id;
      if (itemId != 0) {
        values["item_id"] = itemId;
      } else {
        throw StateError('OrderToItem.item.id is 0.');
      }
    }

    return values;
  }

  static OrderToItem fromSqlMap(Map<String, Object?> map) {
    final keys = map.keys.toSet();
    if (!keys.contains("cart_id")) {
      throw ArgumentError("Missing required key cart_id in map");
    }
    if (!keys.contains("field")) {
      throw ArgumentError("Missing required key field in map");
    }
    if (!keys.contains("item_id")) {
      throw ArgumentError("Missing required key item_id in map");
    }

    var id = 0;
    if (keys.contains('id')) {
      id = map['id'] as int;
      keys.remove("id");
    }

    final cart = map['cart_id'] as Cart?;
    keys.remove("cart_id");

    final field = map['field'] as String;
    keys.remove("field");

    final item = map['item_id'] as Item?;
    keys.remove("item_id");

    if (keys.isNotEmpty) {
      throw ArgumentError('Unkown map keys. $keys');
    }

    final $item = OrderToItem(id: id, cart: cart, field: field, item: item);

    return $item;
  }

  Future<int> register(OrderToItem item, _$AppDatabaseExecutor db) async {
    final map = item.toSqlMap();
    var command = 'REPLACE INTO';
    final originalId = item.id;
    if (originalId == 0) {
      command = 'INSERT INTO';
    }
    final sql =
        '$command $tableName (${map.keys.join(',')}) VALUES (${List.filled(map.length, '?').join(', ')})';
    // print('register sql: $sql');
    // print('args: ${map.values.toList()}');
    final id = await db.rawInsert(sql, map.values.toList());
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
    final sql =
        '$command $tableName (${map.keys.join(',')}) VALUES (${List.filled(map.length, '?').join(', ')})';
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
      final id = map[column.id] as int;
      //print('OrderToItem($id) $dropKeys');
      for (final key in dropKeys) {
        map.remove(key);
      }
      final cartId = map['cart_id'] as int?;
      if (cartId != null) {
        batch.getCart(
          cartId,
          onCommit: (noResult, object) async {
            map['cart_id'] = object;
            return object;
          },
        );
      }
      final itemId = map['item_id'] as int?;
      if (itemId != null) {
        batch.getItem(
          itemId,
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

  Future<OrderToItem?> get(
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
    List<OrderToItem> itemList,
  ) async {
    final noids = itemList.where((e) => e.id == 0);
    if (noids.isNotEmpty) {
      throw ArgumentError(
        'Cannot delete OrderToItem because it has unregistered items.',
      );
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
      throw ArgumentError(
        'Cannot delete OrderToItem because it has unregistered items.',
      );
    }
    final ids = itemList.map((e) => e.id).toSet().toList();

    batch.delete(
      tableName,
      where: '${column.id} in (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
  }
}
