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

    _generateTranactionWrapper(genClassName, tableNameList, buffer);
    _generateBatchWrapper(genClassName, tableNameList, buffer);

    buffer.writeln(
      'abstract class $genClassName implements DatabaseExecutor {',
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
          '  late final ${variableName}Helper = _\$${tableName}Helper();',
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
      buffer.writeln('Future<int> register$table($table item)');
      buffer.writeln('=> ${variableName}Helper.register(item, db: database);');
      buffer.writeln('');
      buffer.writeln('Future<List<$table>> query$table({'
        'String? where, List<Object?>? whereArgs, '
        '  String? orderBy, int? limit, int? offset, })');
      buffer.writeln('=>  ${variableName}Helper.query('
        'where: where, whereArgs: whereArgs, orderBy: orderBy, '
        'limit: limit, offset: offset, db: database);');
      buffer.writeln('');
      buffer.writeln('Future<$table?> get$table(int id)');
      buffer.writeln('=> ${variableName}Helper.get(id, db: database);');
      buffer.writeln('');
      buffer.writeln('Future<int> delete$table($table item)');
      buffer.writeln('=> ${variableName}Helper.delete(item, db: database);');
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
    buffer.writeln('  final wrapper = ${genClassName}BatchWrapper(this, batch);');
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

  void _generateTranactionWrapper(
    String genClassName, List<String?> tableNameList, StringBuffer buffer
  ) {
    buffer.writeln([
      'class ${genClassName}TransactionWrapper implements Transaction {',
      '  $genClassName appdb;'
      '  Transaction transaction;',
      '',
      '  ${genClassName}TransactionWrapper(this.appdb, this.transaction);',
      '',
      '@override Database get database => transaction.database;',
      '',
      '@override ${genClassName}BatchWrapper batch() {',
      '  final batch = database.batch();',
      '  final wrapper = ${genClassName}BatchWrapper(appdb, batch);',
      '  return wrapper;',
      '}'
    ].join('\n'));
    
    for(final table in tableNameList) {
      if (table == null) {
        continue;
      }
      final variableName = toLowerCamelCase(table);
      buffer.writeln([
        'Future<int> register$table($table item)',
        '=> appdb.${variableName}Helper.register(item, db: transaction);',
        '',
        'Future<List<$table>> query$table({',
        'String? where, List<Object?>? whereArgs, ',
        '  String? orderBy, int? limit, int? offset, })',
        '=>  appdb.${variableName}Helper.query(',
        'where: where, whereArgs: whereArgs, orderBy: orderBy, ',
        'limit: limit, offset: offset, db: transaction);',
        '',
        'Future<$table?> get$table(int id)',
        '=> appdb.${variableName}Helper.get(id, db: transaction);',
        '',
        'Future<int> delete$table($table item)',
        '=> appdb.${variableName}Helper.delete(item, db: transaction);',
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
      '  $genClassName appdb;'
      '  Batch batch;',
      '  int index = 0;',
      '  Map<int, Object? Function(bool? noResult, Object?)> callbacks = {};',
      '',
      '  ${genClassName}BatchWrapper(this.appdb, this.batch);',
      '',
      '@override Future<List<Object?>> commit({bool? exclusive, bool? noResult,',
      '  bool? continueOnError,}) async {',
      '    var result = await batch.commit(exclusive: exclusive, noResult:noResult,',
      '     continueOnError: continueOnError);',
      '',
      '    result = result.toList(); // read only list to writable list',
      '    for (final index in callbacks.keys) {',
      '      Object? object;',
      '      if (index < result.length) {',
      '         object = result[index];',
      '      }',
      '      final callback = callbacks[index];'
      '      final ret = callback?.call(noResult, object);'
      '      if (index < result.length) {',
      '         result[index] = ret;',
      '      }',
      '    }',
      '',
      '    callbacks = {};',
      '    index = 0;',
      '',
      '    return result;',
      '  }',
      '',
      '@override Future<List<Object?>> apply({bool? noResult, bool? continueOnError,}) async {',
      '    var result = await batch.apply(noResult:noResult, continueOnError: continueOnError);',
      '',
      '    result = result.toList(); // read only list to writable list',
      '    for (final index in callbacks.keys) {',
      '      Object? object;',
      '      if (index < result.length) {',
      '         object = result[index];',
      '      }',
      '      final callback = callbacks[index];'
      '      final ret = callback?.call(noResult, object);'
      '      if (index < result.length) {',
      '         result[index] = ret;',
      '      }',
      '    }',
      '',
      '    callbacks = {};',
      '    index = 0;',
      '',
      '    return result;',
      '  }',
      '',
    ].join('\n'));

    for(final table in tableNameList) {
      if (table == null) {
        continue;
      }
      final variableName = toLowerCamelCase(table);
      buffer.writeln([
        'void register$table($table item)',
        '=> appdb.${variableName}Helper.register(item, batch: this);',
        '',
        'void query$table({',
        'String? where, List<Object?>? whereArgs, ',
        '  String? orderBy, int? limit, int? offset, })',
        '=>  appdb.${variableName}Helper.query(',
        'where: where, whereArgs: whereArgs, orderBy: orderBy, ',
        'limit: limit, offset: offset, batch: this);',
        '',
        'void get$table(int id)',
        '=> appdb.${variableName}Helper.get(id, batch: this);',
        '',
        'void delete$table($table item)',
        '=> appdb.${variableName}Helper.delete(item, batch: this);',
        '',
      ].join('\n'));
    }

    buffer.writeln('// pass through methods');
    buffer.writeln('@override int get length => batch.length;');
    buffer.writeln('');
    for (var method in batchMethods) {
      var func = method.$1;
      func = func.replaceAll('%s', 'Object? Function(bool? noResult, Object?)? onCommit');
      buffer.writeln([
        '@override  $func {',
        '    batch.${method.$2};',
        '    if (onCommit != null) {',
        '      callbacks[index] = onCommit;',
        '    }',
        '    index++;',
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
