import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'package:keg_annotation/keg_annotation.dart';

class DatabaseGenerator extends GeneratorForAnnotation<KegDatabase> {
  final dbMethods = <(String, String)>[
    // Database methods
    ('String get path', 'path'),
    ('Future<void> close()', 'close()'),
    // (
    //   'Future<T> transaction<T>(Future<T> Function(Transaction txn) action, {bool? exclusive,})',
    //   'transaction<T>(action, exclusive: exclusive)',
    // ),
    // (
    //   'Future<T> readTransaction<T>(Future<T> Function(Transaction txn) action)',
    //   'readTransaction<T>(action)',
    // ),
    ('bool get isOpen', 'isOpen'),];

  final execMethods = <(String, String)>[
    // DatabaseExecutor methods
    (
      '@override Future<void> execute(String sql, [List<Object?>? arguments])',
      'execute(sql, arguments)',
    ),
    (
      '@override Future<int> rawInsert(String sql, [List<Object?>? arguments])',
      'rawInsert(sql, arguments)',
    ),
    (
      '''@override Future<int> insert(String table, Map<String, Object?> values,
     {String? nullColumnHack, ConflictAlgorithm? conflictAlgorithm,})''',
      'insert(table, values, nullColumnHack: nullColumnHack, conflictAlgorithm: conflictAlgorithm)',
    ),
    (
      '''@override Future<List<Map<String, Object?>>> query(String table, 
     {bool? distinct, List<String>? columns, String? where, List<Object?>? whereArgs,
     String? groupBy, String? having, String? orderBy, int? limit, int? offset,})''',
      '''query(table, distinct: distinct, columns: columns, where: where, whereArgs: whereArgs,
     groupBy: groupBy, having: having, orderBy: orderBy, limit: limit, offset: offset)''',
    ),
    (
      '@override Future<List<Map<String, Object?>>> rawQuery(String sql, [List<Object?>? arguments])',
      'rawQuery(sql, arguments)',
    ),
    (
      '''@override Future<QueryCursor> rawQueryCursor(String sql, List<Object?>? arguments,
     {int? bufferSize,})''',
      'rawQueryCursor(sql, arguments, bufferSize: bufferSize)',
    ),
    (
      '''@override Future<QueryCursor> queryCursor(String table, {bool? distinct, List<String>? columns,
     String? where, List<Object?>? whereArgs, String? groupBy, String? having, String? orderBy,
     int? limit, int? offset, int? bufferSize,})''',
      '''queryCursor(table, distinct: distinct, columns: columns, where: where, whereArgs: whereArgs,
     groupBy: groupBy, having: having, orderBy: orderBy, limit: limit, offset: offset, bufferSize: bufferSize)''',
    ),
    (
      '@override Future<int> rawUpdate(String sql, [List<Object?>? arguments])',
      'rawUpdate(sql, arguments)',
    ),
    (
      '''@override Future<int> update(String table, Map<String, Object?> values,
     {String? where, List<Object?>? whereArgs, ConflictAlgorithm? conflictAlgorithm,})''',
      'update(table, values, where: where, whereArgs: whereArgs, conflictAlgorithm: conflictAlgorithm)',
    ),
    (
      '@override Future<int> rawDelete(String sql, [List<Object?>? arguments])',
      'rawDelete(sql, arguments)',
    ),
    (
      '''@override Future<int> delete(String table, {String? where, List<Object?>? whereArgs})''',
      'delete(table, where: where, whereArgs: whereArgs)',
    ),
    //('@override Batch batch()', 'batch()'),
    //('Database get database', 'db'),
  ];

  final batchMethods = [ 
    ('void rawInsert(String sql, [List<Object?>? arguments, %s])',
     'rawInsert(sql, arguments)'),
    ('void insert(String table, Map<String, Object?> values, {'
     'String? nullColumnHack, ConflictAlgorithm? conflictAlgorithm, %s})',
     'insert(table, values,'
     'nullColumnHack:nullColumnHack, conflictAlgorithm:conflictAlgorithm,)'),
    ('void rawUpdate(String sql, [List<Object?>? arguments, %s])',
     'rawUpdate(sql, arguments,)'),
    ('void update(String table, Map<String, Object?> values, {'
     'String? where, List<Object?>? whereArgs, ConflictAlgorithm? conflictAlgorithm, %s})',
     'update(table, values, where: where, whereArgs: whereArgs,'
     'conflictAlgorithm: conflictAlgorithm,)'),
    ('void rawDelete(String sql, [List<Object?>? arguments, %s])',
     'rawDelete(sql, arguments)'),
    ('void delete(String table, {String? where, List<Object?>? whereArgs, %s})',
     'delete(table, where: where, whereArgs: whereArgs)'),
    ('void execute(String sql, [List<Object?>? arguments, %s])',
      'execute(sql, arguments)'),
    ('void query(String table, {bool? distinct, List<String>? columns,'
     'String? where, List<Object?>? whereArgs, String? groupBy, String? having,'
     'String? orderBy, int? limit, int? offset, %s})',
     'query(table, distinct: distinct, columns: columns,'
     'where: where, whereArgs: whereArgs, groupBy: groupBy, having: having,'
     'orderBy: orderBy, limit: limit, offset: offset,)'),
    ('void rawQuery(String sql, [List<Object?>? arguments, %s])',
     'rawQuery(sql, arguments,)'),
    //('int get length', 'length'),
  ];

  @override
  String generateForAnnotatedElement(
    element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError('${element.name} is not a class');
    }

    int schemaVersion = annotation.read('schemaVersion').intValue;

    final tablesReader = annotation.read('tables');
    final dartObjectList = tablesReader.listValue;
    // final item0 = dartObjectList[0];
    // final type = item0.toTypeValue()
    // memo: covariant
    final tableNameList = dartObjectList.map((dObj) {
      final t = dObj.toTypeValue();
      return t?.getDisplayString();
    }).toList();
    //final type = item0.type;

    final buffer = StringBuffer();

    final className = element.name;
    final genClassName = '_\$$className';

    _generateAppExecutor(genClassName, tableNameList, buffer);
    _generateTranactionWrapper(genClassName, tableNameList, buffer);
    _generateBatchWrapper(genClassName, tableNameList, buffer);

    buffer.writeln(
      'abstract class $genClassName implements ${genClassName}Executor {',
    );
    buffer.writeln('');
    buffer.writeln('  int get  schemaVersion => $schemaVersion;');
    buffer.writeln('');
    buffer.writeln('  @override late Database database;');
    buffer.writeln('');

    // helper fields
    for (var tableName in tableNameList) {
      if (tableName != null) {
        final variableName = toLowerCamelCase(tableName);
        buffer.writeln(
          '  late final ${variableName}Helper = _\$${tableName}Helper(this);',
        );
      }
    }
    buffer.writeln('');

    buffer.writeln('  Future<String> getPathToOpen();');
    buffer.writeln('');
    buffer.writeln('  Future<void> open() async {');
    buffer.writeln('    final path = await getPathToOpen();');
    buffer.writeln(
      '    database = await openDatabase(path, version: schemaVersion,',
    );
    buffer.writeln('      onConfigure: onConfigure,');
    buffer.writeln('      onCreate: onCreate, onUpgrade: onUpgrade,');
    buffer.writeln('      onDowngrade: onDowngrade, onOpen: onOpen);');
    buffer.writeln('  }');
    buffer.writeln('');

    // onConfigure
    buffer.writeln('  Future<void> onConfigure(Database db) async {');
    buffer.writeln('   // do nothing');
    buffer.writeln('  }'); // end function
    buffer.writeln('');

    // onCreate
    buffer.writeln('  Future<void> onCreate(Database db, int version) async {');
    if (tableNameList.isNotEmpty) {
      buffer.writeln('  final batch = db.batch();');

      for (var tableName in tableNameList) {
        if (tableName != null) {
          final variableName = toLowerCamelCase(tableName);
          buffer.writeln(
            '    await ${variableName}Helper.onCreate(version, batch:batch);',
          );
        }
      }
      buffer.writeln('  await batch.commit();');
    }
    buffer.writeln('  }'); // end function
    buffer.writeln('');

    // onUpgrade
    buffer.writeln(
      '  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {',
    );
    if (tableNameList.isNotEmpty) {
      buffer.writeln('  final batch = db.batch();');
      for (var tableName in tableNameList) {
        if (tableName != null) {
          final variableName = toLowerCamelCase(tableName);
          buffer.writeln(
            '    await ${variableName}Helper.onUpgrade(oldVersion, newVersion, batch:batch);',
          );
        }
      }
      buffer.writeln('  await batch.commit();');
    }
    buffer.writeln('  }'); // end function
    buffer.writeln('');

    // onDowngrade
    buffer.writeln(
      '  Future<void> onDowngrade(Database db, int oldVersion, int newVersion) async {',
    );
    buffer.writeln('    throw UnimplementedError();');
    buffer.writeln('  }'); // end function
    buffer.writeln('');

    // onOpen
    buffer.writeln('  Future<void> onOpen(Database db) async {');
    buffer.writeln('    // do nothing');
    buffer.writeln('  }'); // end function
    buffer.writeln('');

    // register, query, delete 
    for(final table in tableNameList) {
      if (table == null) {
        continue;
      }
      final variableName = toLowerCamelCase(table);
      buffer.writeln('/// Insert or update $table.');
      buffer.writeln('/// If id is 0, insert and sets id to generated value.');
      buffer.writeln('/// If specified id already exists in table, update the record.');
      buffer.writeln('/// If specified id does not exist in table, insert with the id.');
      buffer.writeln('@override Future<int> register$table($table item)');
      buffer.writeln('=> ${variableName}Helper.register(item, this);');
      buffer.writeln('');
      buffer.writeln('@override Future<List<$table>> query$table({'
        'String? where, List<Object?>? whereArgs, '
        '  String? orderBy, int? limit, int? offset,'
        '  List<({String table, String column})> dropKeys = const [] })');
      buffer.writeln('=>  ${variableName}Helper.query(this,'
        'where: where, whereArgs: whereArgs, orderBy: orderBy, '
        'limit: limit, offset: offset, dropKeys: dropKeys);');
      buffer.writeln('');
      buffer.writeln('@override Future<$table?> get$table(int id, '
      '[List<({String table, String column})> dropKeys = const[]])');
      buffer.writeln('=> ${variableName}Helper.get(id, this, dropKeys);');
      buffer.writeln('');
      buffer.writeln('@override Future<int> delete$table({String? where,'
        'List<Object?>? whereArgs,})');
      buffer.writeln('=> ${variableName}Helper.delete(this, where: where,'
        ' whereArgs: whereArgs);');
      buffer.writeln('');
      buffer.writeln('@override Future<int> delete${table}ByIds(List<$table> itemsList)');
      buffer.writeln('=> ${variableName}Helper.deleteByIds(this, itemsList);');
      buffer.writeln('');
    }

    // transaction
    buffer.writeln('Future<T> transaction<T>(');
    buffer.writeln('Future<T> Function(${genClassName}TransactionWrapper txn) action,');
    buffer.writeln('{bool? exclusive,}) {');
    buffer.writeln('return database.transaction<T>((txn) async {');
    buffer.writeln('final transactionWrapper = ${genClassName}TransactionWrapper(this, txn);');
    buffer.writeln('return await action(transactionWrapper);');
    buffer.writeln('}, exclusive: exclusive);');
    buffer.writeln('}');
    buffer.writeln();

    buffer.writeln('Future<T> readTransaction<T>(');
    buffer.writeln('Future<T> Function(${genClassName}TransactionWrapper txn) action,) {');
    buffer.writeln('return database.readTransaction<T>((txn) async {');
    buffer.writeln('final transactionWrapper = ${genClassName}TransactionWrapper(this, txn);');
    buffer.writeln('return await action(transactionWrapper);');
    buffer.writeln('});');
    buffer.writeln('}');
    buffer.writeln();

    // batch
    buffer.writeln('@override ${genClassName}BatchWrapper batch() {');
    buffer.writeln('  final batch = database.batch();');
    buffer.writeln('  final wrapper = ${genClassName}BatchWrapper(this, this, batch);');
    buffer.writeln('  return wrapper;');
    buffer.writeln('}');
    buffer.writeln('');

    buffer.writeln('// pass through methods');
    for (var method in dbMethods) {
      buffer.writeln('  ${method.$1} => database.${method.$2};');
      buffer.writeln('');
    }
    for (var method in execMethods) {
      buffer.writeln('  ${method.$1} => database.${method.$2};');
      buffer.writeln('');
    }

    buffer.writeln('');

    buffer.writeln('}'); // end of class

    return buffer.toString();
  }

  void _generateAppExecutor(
    String genClassName, List<String?> tableNameList, StringBuffer buffer
  ) {
    buffer.writeln('abstract class ${genClassName}Executor extends DatabaseExecutor {');
    buffer.writeln('@override ${genClassName}BatchWrapper batch();');

    for(final table in tableNameList) {
      if (table == null) {
        continue;
      }
      buffer.writeln('/// Insert or update $table.');
      buffer.writeln('/// If id is 0, insert and sets id to generated value.');
      buffer.writeln('/// If specified id already exists in table, update the record.');
      buffer.writeln('/// If specified id does not exist in table, insert with the id.');
      buffer.writeln('Future<int> register$table($table item);');
      buffer.writeln('');
      buffer.writeln('Future<List<$table>> query$table({'
        'String? where, List<Object?>? whereArgs, '
        '  String? orderBy, int? limit, int? offset, List<({String table, String column})> dropKeys = const []});');
      buffer.writeln('');
      buffer.writeln('Future<$table?> get$table(int id, [List<({String table, String column})> dropKeys = const []]);');
      buffer.writeln('');
      buffer.writeln('Future<int> delete$table({String? where, List<Object?>? whereArgs});');
      buffer.writeln('');      
      buffer.writeln('Future<int> delete${table}ByIds(List<$table> itemList);');
      buffer.writeln('');
    }
    buffer.writeln('}');
  }

  void _generateTranactionWrapper(
    String genClassName, List<String?> tableNameList, StringBuffer buffer
  ) {
    buffer.writeln([
      'class ${genClassName}TransactionWrapper implements ${genClassName}Executor {',
      '  $genClassName appdb;'
      '  Transaction transaction;',
      '',
      '  ${genClassName}TransactionWrapper(this.appdb, this.transaction);',
      '',
      '@override Database get database => transaction.database;',
      '',
      '@override ${genClassName}BatchWrapper batch() {',
      '  final batch = transaction.batch();',
      '  final wrapper = ${genClassName}BatchWrapper(appdb, this, batch);',
      '  return wrapper;',
      '}'
    ].join('\n'));
    
    for(final table in tableNameList) {
      if (table == null) {
        continue;
      }
      final variableName = toLowerCamelCase(table);
      buffer.writeln([
        '@override Future<int> register$table($table item)',
        '=> appdb.${variableName}Helper.register(item, this);',
        '',
        '@override Future<List<$table>> query$table({',
        'String? where, List<Object?>? whereArgs, ',
        '  String? orderBy, int? limit, int? offset,',
        '  List<({String table, String column})> dropKeys = const []})',
        '=>  appdb.${variableName}Helper.query(this,',
        'where: where, whereArgs: whereArgs, orderBy: orderBy, ',
        'limit: limit, offset: offset, dropKeys:dropKeys);',
        '',
        '@override Future<$table?> get$table(int id, [List<({String table, String column})> dropKeys = const []])',
        '=> appdb.${variableName}Helper.get(id, this, dropKeys);',
        '',
        '@override Future<int> delete$table({String? where, List<Object?>? whereArgs,})',
        '=> appdb.${variableName}Helper.delete(this, where: where, whereArgs: whereArgs);',
        '',
        '@override Future<int> delete${table}ByIds(List<$table> itemList)',
        '=> appdb.${variableName}Helper.deleteByIds(this, itemList);',
        '',
      ].join('\n'));
    }

    buffer.writeln('// passthrough methods');
    for (var method in execMethods) {
      buffer.writeln('  ${method.$1} => transaction.${method.$2};');
      buffer.writeln('');
    }
    buffer.writeln('}'); // end of class
    buffer.writeln('');
  }

  void _generateBatchWrapper(
    String genClassName, List<String?> tableNameList, StringBuffer buffer
  ) {
    buffer.writeln([
      'class ${genClassName}BatchWrapper implements Batch {',
      '  $genClassName appdb; // used for refer helpers',
      '  ${genClassName}Executor executor; // database or transaction used for exec sqls',
      '  Batch batch;',
      '  int callBackIndex = 0;',
      '  Map<int, List<Future<Object?> Function(bool? noResult, Object?)>> callBacks = {};',
      '',
      '  ${genClassName}BatchWrapper(this.appdb, this.executor, this.batch);',
      '',
      'void _addCallBack(int index, Future<Object?> Function(bool? noResult, Object?) callback) {', 
      'var callBackList = callBacks[index];',
      'if (callBackList == null) {',
      '  callBackList = [];',
      '  callBacks[index] = callBackList;',
      '}',
      'callBackList.add(callback);',
      '}',
      ''
      'Future<List<Object?>> _execCallBacks(List<Object?> result, bool? noResult) async {',
      ''
      '  for (final index in callBacks.keys) {',
      '    Object? object;',
      '    if (index < result.length) {',
      '       object = result[index];',
      '    }',
      '    final callbackList = callBacks[index];'
      '    if (callbackList == null) {',
      '      continue;',
      '    }',
      '    for(final callback in callbackList) {'
      '     object = await callback(noResult, object);'
      '    }'
      '    if (index < result.length) {',
      '       result[index] = object;',
      '    }',
      '  }',
      '  return result;'
      '}',
      '',
      '@override Future<List<Object?>> commit({bool? exclusive, bool? noResult,',
      '  bool? continueOnError,}) async {',
      '    var result = await batch.commit(exclusive: exclusive, noResult:noResult,',
      '     continueOnError: continueOnError);',
      '',
      '    result = result.toList(); // read only list to writable list',
      '    result = await _execCallBacks(result, noResult);'
      '',
      '    callBacks = {};',
      '    callBackIndex = 0;',
      '',
      '    return result;',
      '  }',
      '',
      '@override Future<List<Object?>> apply({bool? noResult, bool? continueOnError,}) async {',
      '    var result = await batch.apply(noResult:noResult, continueOnError: continueOnError);',
      '',
      '    result = result.toList(); // read only list to writable list',
      '    result = await _execCallBacks(result, noResult);'
      '',
      '    callBacks = {};',
      '    callBackIndex = 0;',
      '',
      '    return result;',
      '  }',
      '',
    ].join('\n'));

    final onCommitArg = 'Future<Object?> Function(bool? noResult, Object?)? onCommit';
    for(final table in tableNameList) {
      if (table == null) {
        continue;
      }
      final variableName = toLowerCamelCase(table);
      buffer.writeln([
        'void register$table($table item, [$onCommitArg]) {',
        '  appdb.${variableName}Helper.registerBatch(item, this);',
        '  if (onCommit != null) {',
        '    _addCallBack(callBackIndex-1, onCommit);',
        '  }',
        '}'
        '',
        'void query$table({',
        'String? where, List<Object?>? whereArgs, ',
        ' String? orderBy, int? limit, int? offset,',
        ' List<({String table, String column})> dropKeys = const [], $onCommitArg}) {',
        ' appdb.${variableName}Helper.queryBatch(this,',
        ' where: where, whereArgs: whereArgs, orderBy: orderBy, ',
        '  limit: limit, offset: offset, dropKeys: dropKeys);',
        '  if (onCommit != null) {',
        '    _addCallBack(callBackIndex-1, onCommit);',
        '  }',
        '}'
        '',
        'void get$table(int id, {List<({String table, String column})> dropKeys = const [], $onCommitArg}) {',
        ' appdb.${variableName}Helper.getBatch(id, this, dropKeys,);',
        '  if (onCommit != null) {',
        '    _addCallBack(callBackIndex-1, onCommit);',
        '  }',
        '}'
        '',
        'void delete$table({String? where, List<Object?>? whereArgs, $onCommitArg}) {',
        '  appdb.${variableName}Helper.deleteBatch(this, where: where, whereArgs: whereArgs);',
        '  if (onCommit != null) {',
        '    _addCallBack(callBackIndex-1, onCommit);',
        '  }',
        '}'
        '',
        'void delete${table}ByIds(List<$table> itemList, [$onCommitArg]) {',
        ' appdb.${variableName}Helper.deleteByIdsBatch(this, itemList);',
        '  if (onCommit != null) {',
        '    _addCallBack(callBackIndex-1, onCommit);',
        '  }',
        '}'
        '',
      ].join('\n'));
    }

    buffer.writeln('// pass through methods');
    buffer.writeln('@override int get length => batch.length;');
    buffer.writeln('');
    for (var method in batchMethods) {
      var func = method.$1;
      func = func.replaceAll('%s', onCommitArg);
      buffer.writeln([
        '@override  $func {',
        '    batch.${method.$2};',
        '    if (onCommit != null) {',
        //'      callbacks[index] = onCommit;',
        '       _addCallBack(callBackIndex, onCommit);'
        '    }',
        '    callBackIndex++;',
        '   }',
        ''
      ].join('\n'));
    }

    buffer.writeln('}'); // end of wrapper class
  }

  /// Convert class name to variable name
  String toLowerCamelCase(String input) {
    if (input.isEmpty) return input;
    return input[0].toLowerCase() + input.substring(1);
  }
}
