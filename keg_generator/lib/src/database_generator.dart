import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'package:keg_annotation/keg_annotation.dart';

class DatabaseGenerator extends GeneratorForAnnotation<KegDatabase> {
  final dbMethods = <(String, String)>[
    // Database methods
    ('String get path', 'path'),
    ('Future<void> close()', 'close()'),
    (
      'Future<T> transaction<T>(Future<T> Function(Transaction txn) action, {bool? exclusive,})',
      'transaction<T>(action, exclusive: exclusive)',
    ),
    (
      'Future<T> readTransaction<T>(Future<T> Function(Transaction txn) action)',
      'readTransaction<T>(action)',
    ),
    ('bool get isOpen', 'isOpen'),

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
    ('@override Batch batch()', 'batch()'),
    //('Database get database', 'db'),
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
      buffer.writeln('Future<int> delete$table($table item)');
      buffer.writeln('=> ${variableName}Helper.delete(item, db: database);');
      buffer.writeln('');
    }

    buffer.writeln('// pass through methods');
    for (var method in dbMethods) {
      buffer.writeln('  ${method.$1} => database.${method.$2};');
      buffer.writeln('');
    }

    buffer.writeln('');

    buffer.writeln('}'); // end of class

    return buffer.toString();
  }

  String toLowerCamelCase(String input) {
    if (input.isEmpty) return input;
    return input[0].toLowerCase() + input.substring(1);
  }
}
