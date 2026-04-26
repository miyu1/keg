import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'package:keg_annotation/keg_annotation.dart';

class TableGenerator extends GeneratorForAnnotation<Table> {
  String className = '';
  String tableName = '';
  bool isFreezed = false;
  Map<String, _FieldInfo> _fieldMap = {};
  final List<String> _requiredPositional = [];
  final List<String> _optionalPositional = [];
  final Map<String, List<String>> _columnMap = {};
  String appDbName = '';
  int schemaVersion = 0;
  List<String?> tableNameList = [];

  @override
  Future<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError('${element.name} is not a class');
    }
    //print('Generating table for class ${element.name}');

    // initialize values
    _fieldMap.clear();
    _requiredPositional.clear();
    _optionalPositional.clear();
    _columnMap.clear();
    appDbName = '';
    schemaVersion = 0;
    tableNameList = [];

    className = element.displayName;
    tableName = toSnakeCase(className);
    isFreezed = _annotatedWith(element, 'Freezed', package: 'package:freezed_annotation');

    await _getSchemaVersion(className, buildStep);
    if (schemaVersion == 0) {
      final msg = 'class $className is not included in any database.';
      log.warning(msg);
      return '// $msg';
    }

    final oldColumnList = <String>[];
    if (schemaVersion > 1) {
      // read previously generated helper class
      final library = await buildStep.inputLibrary;
      final helperElement = library.getClass('_\$${className}Helper');
      if (helperElement != null) {
        await _analyzeStaticFields(helperElement, schemaVersion, buildStep);
      }
      await _analyzeStaticFields(element, schemaVersion, buildStep);

      for (var version = 1; version < schemaVersion; version++) {
        final key = 'v${version}ColumnList';
        oldColumnList.addAll(_columnMap[key] ?? []);
      }
    }

    _fieldMap = await _analyzeFields(element, buildStep);
    await _analyzeConstructor(element);

    // helper fields
    if (!_fieldMap.containsKey('id')) {
      final msg = '$className must have an "id" field as primary key';
      throw InvalidGenerationSourceError(msg);
    }
    final idInfo = _fieldMap['id']!;
    if (idInfo.type != _DataType.dtInteger) {
      final msg = '$className: field "id" must be of type int';
      throw InvalidGenerationSourceError(msg);
    }

    var columnRecord = '('; // record
    var columnList = '['; // list
    var columnTypes = '{'; // map

    for (final field in _fieldMap.values) {
      if (field.type == _DataType.dtBackLink ||
          field.type == _DataType.dtManyReference ||
          field.type == _DataType.dtBackLinkMany) {
        continue;
      }

      if (field.type == .dtUnknown) {
        final msg = '$className: field ${field.name} undetermined type';
        throw InvalidGenerationSourceError(msg);
      }
      columnRecord += "${field.name}:'\"${field.columnName}\"', ";
      if (!oldColumnList.contains(field.columnName)) {
        columnList += "'${field.columnName}', ";
      }

      var dbTypeStr = switch (field.type) {
        .dtInteger => 'INTEGER',
        .dtDouble => 'REAL',
        .dtString => 'TEXT',
        .dtBool => 'INTEGER',
        .dtDateTime => 'INTEGER',
        .dtEnum => 'TEXT',
        .dtReference => 'INTEGER',
        _ => '',
      };
      if (dbTypeStr.isEmpty) {
        final msg = "$className: field '${field.name}' is unsupported type";
        throw InvalidGenerationSourceError(msg);
      }

      if (field.name == 'id') {
        dbTypeStr += ' PRIMARY KEY AUTOINCREMENT';
      } else if (field.type == .dtReference) {
        var className = field.className;
        if (className.endsWith('?')) {
          className = className.substring(0, className.length - 1);
        }
        className = toSnakeCase(className);
        dbTypeStr += ' REFERENCES "$className"("id")';
      } else {
        dbTypeStr += ' NOT NULL';
        dbTypeStr += switch (field.type) {
          .dtInteger => ' DEFAULT 0',
          .dtDouble => ' DEFAULT 0.0',
          .dtString => " DEFAULT \\'\\'",
          .dtBool => ' DEFAULT 0',
          .dtDateTime => ' DEFAULT 0',
          .dtEnum => " DEFAULT \\'\${${field.className}.values[0].name}\\'",
          _ => '',
        };
      }
      columnTypes += "'${field.columnName}':'$dbTypeStr', ";
    }
    var fullColumnList = columnList.substring(1);
    columnRecord += ')';
    columnList += ']';
    columnTypes += '}';

    fullColumnList = oldColumnList.map((e) => "'$e', ").join() + fullColumnList;
    fullColumnList = '[$fullColumnList]';

    final lines = <String>[
      'class _\$${className}Helper {',
      "  final String tableName = '\"$tableName\"';",
      '  final column = $columnRecord;',
      '  final columnTypes = $columnTypes;',
      '  final columnList = $fullColumnList;',
      '',
      '  _\$$appDbName appdb;',
      //'  Map<int, Map<String, Object?>> cachedMap = {}; // to prevent eternal loop'
      //'  Map<int, $className> cachedObjects = {};'
      '',
      '  _\$${className}Helper(this.appdb);',
      '',
    ];

    var columnListByVersion = '';
    for (var version = 1; version < schemaVersion; version++) {
      final key = 'v${version}ColumnList';
      if (_columnMap.containsKey(key)) {
        final value = _columnMap[key]?.map((e) => "'$e'").join(', ');
        lines.add('  static final $key = [$value];');
        columnListByVersion += '$version: $key, ';
      }
    }
    columnListByVersion += '$schemaVersion: v${schemaVersion}ColumnList';

    lines.addAll([
      '  static final v${schemaVersion}ColumnList = $columnList;',
      //'  final columnListByVersion = {1: v1ColumnList};',
      '  final columnListByVersion = {$columnListByVersion};',
      '',
    ]);

    lines.addAll(_generateTableCreators(className));
    lines.addAll(_generateMapConverters(className));
    lines.addAll(_generateRegisterMethods(className, appDbName));
    lines.addAll(_generateDataHandlers(className, appDbName));

    lines.add('}'); // end of class

    return lines.join('\n');
  }

  List<String> _generateTableCreators(String className) {
    // indexes
    final indexLines = <String>[];
    final indexedFields = _fieldMap.values.where((field) => field.isIndexed);
    for (final field in indexedFields) {
      final indexName = '\${_unquote(tableName)}_${field.columnName}_idx';
      final index = field.annotationObject as Index;
      final uniqueStr = index.unique ? 'UNIQUE' : '';
      final descStr = index.descendant ? 'DESC' : 'ASC';
      indexLines.addAll([
        '    final ${field.name}IndexSql = \'CREATE $uniqueStr INDEX IF NOT EXISTS "$indexName" ON \$tableName ("${field.columnName}" $descStr)\';',
        '    if (db != null) {',
        '      await db.execute(${field.name}IndexSql);',
        '    } else if (batch != null) {',
        '      batch.execute(${field.name}IndexSql);',
        '    }',
      ]);
    }

    final lines = [
      '  /// on create database table',
      '  Future<void> onCreate(int version, {DatabaseExecutor? db, Batch? batch}) async {',
      '    assert((db != null) ^ (batch != null));',
      '',
      '    var columnList = [];',
      '    for(var i = 1; i <= version; i++) {',
      '      final oneColumnList = columnListByVersion[i] ?? [];',
      '      columnList.addAll(oneColumnList);',
      '    }',
      '    if (columnList.isEmpty) {',
      '      throw UnsupportedError("No columns defined for $className version \$version");',
      '    }',
      '    var params = [];',
      '    for (final column in columnList) {',
      '      params.add(\'"\$column" \${columnTypes[column]}\');',
      '    }',
      '    final sql = \'CREATE TABLE IF NOT EXISTS \$tableName (\${params.join(\', \')})\';',
      '    //print(\'Creating table: \$sql\');',
      '    if (db != null) {',
      '      await db.execute(sql);',
      '    } else if (batch != null) {',
      '      batch.execute(sql);',
      '    }',
      '',
      ...indexLines,
      '  }',
      '',
      '  /// on upgrade database table',
      '  Future<void> onUpgrade(int oldVersion, int newVersion,',
      '    {DatabaseExecutor? db, Batch? batch}) async {',
      '    var columnList = [];',
      '    for(var i = 1; i <= oldVersion; i++) {',
      '      final oneColumnList = columnListByVersion[i] ?? [];',
      '      columnList.addAll(oneColumnList);',
      '    }',
      '    if (columnList.isEmpty) {',
      '      await onCreate(newVersion, db:db, batch:batch);',
      '      return;',
      '    }',
      '',
      '    columnList = [];',
      '    for(var i = oldVersion + 1; i <= newVersion; i++) {',
      '      final newColumnList = columnListByVersion[i] ?? [];',
      '      columnList.addAll(newColumnList);',
      '    }',
      '    for (final column in columnList) {',
      '      final sql = \'ALTER TABLE \$tableName ADD COLUMN "\$column" \${columnTypes[column]}\';',
      '      //print(\'Altering table: \$sql\');',
      '      if (db != null) {',
      '        await db.execute(sql);',
      '      } else if (batch != null) {',
      '        batch.execute(sql);',
      '      }',
      '    }',
      '',
      ...indexLines,
      '  }',
      '',
    ];

    return lines;
  }

  List<String> _generateMapConverters(String className) {
    var lines = <String>[];

    // Generate the toSqlMap method
    lines += [
      'static Map<String, Object?> toSqlMap($className item) {',
      '  final values = <String, Object?>{};',
      '',
    ];

    for (final field in _fieldMap.values) {
      if (field.type == _DataType.dtBackLink ||
          field.type == _DataType.dtManyReference ||
          field.type == _DataType.dtBackLinkMany) {
        continue;
      }

      var valueStr = 'item.${field.name}';
      if (field.type == _DataType.dtBool) {
        valueStr = 'item.${field.name} ? 1 : 0';
      } else if (field.type == _DataType.dtDateTime) {
        valueStr = 'item.${field.name}.toUtc().microsecondsSinceEpoch';
      } else if (field.type == _DataType.dtEnum) {
        valueStr = 'item.${field.name}.name';
      } else if (field.type == .dtReference) {
        valueStr = 'item.${field.name}!.id';
      }

      if (field.name == 'id') {
        lines.addAll([
          'if (item.id != 0) {',
          "  values['${field.columnName}'] = $valueStr;",
          '}',
        ]);
      } else if (field.type == .dtReference) {
        lines.addAll([
          'if (item.${field.name} != null) {'
              'final ${field.name}Id = $valueStr;',
          'if (${field.name}Id != 0) {',
          "  values['${field.columnName}'] = ${field.name}Id;",
          '} else {',
          "  throw StateError('$className.${field.name}.id is 0.');"
              '}',
          '}',
        ]);
      } else {
        lines.add("values['${field.columnName}'] = $valueStr;");
      }
      lines.add('');
    }
    lines.add('    return values;');
    lines.add('  }');

    // unquote column names in map for fromSqlMap
    lines.addAll([
      '',
      'static String _unquote(String s) {',
      '  if (s.startsWith(\'"\') && s.endsWith(\'"\')) {',
      '    return s.substring(1, s.length - 1);',
      '  }',
      '  return s;',
      '}',
      '',
      '  /// unquote column names in map for fromSqlMap',
      '  static Map<String, Object?> _unquoteMap(Map<String, Object?> map) {',
      '    final newMap = <String, Object?>{};',
      '    for (final entry in map.entries) {',
      '      var key = _unquote(entry.key);',
      '      newMap[key] = entry.value;',
      '    }',
      '    return newMap;',
      '  }',
    ]);

    // Generate the fromSqlMap method
    lines.addAll([
      'static $className fromSqlMap(Map<String, Object?> map) {',
      '  map = _unquoteMap(map);',
      '  final keys = map.keys.toSet();',
    ]);
    if (_fieldMap.values.any((field) => field.constructType == .notIncluded)) {
      lines.add(' final params = <String, Object>{};');
    }

    // check required fields
    for (final field in _fieldMap.values.where(
      (field) => field.constructType == .required,
    )) {
      lines.add("if (!keys.contains('${field.columnName}')) {");
      lines.add(
        '  throw ArgumentError("Missing required key ${field.columnName} in map");',
      );
      lines.add('}');
    }
    lines.add('');

    for (final field in _fieldMap.values) {
      if (field.constructType == .required) {
        lines.add('final ${field.name} =');
      } else if (field.constructType == .optional) {
        if (field.type == .dtReference) {
          lines.add('${field.className}? ${field.name};');
        } else if (field.type == _DataType.dtBackLink ||
            field.type == _DataType.dtManyReference ||
            field.type == _DataType.dtBackLinkMany) {
          lines.add(
            'List<${field.className}> ${field.name} = ${field.defaultValue};',
          );
        } else {
          lines.add('var ${field.name} = ${field.defaultValue};');
        }
        lines.add("if (keys.contains('${field.columnName}')) {");
        lines.add('${field.name} =');
      } else if (field.constructType == .notIncluded) {
        lines.add("if (keys.contains('${field.columnName}')) {");
        if (field.type == .dtReference) {
          lines.add('${field.className}? ${field.name} =');
        } else {
          lines.add("params['${field.name}'] = ");
        }
      }
      if (field.type == .dtUnknown) {
        throw InvalidGenerationSourceError(
          '$className: type of ${field.name} is not valid',
        );
      } else if (field.type == .dtBool) {
        lines.add("(map['${field.columnName}'] as int) == 0 ? false : true;");
      } else if (field.type == .dtDateTime) {
        lines.add(
          "DateTime.fromMicrosecondsSinceEpoch(map['${field.columnName}'] as int).toLocal();",
        );
      } else if (field.type == .dtEnum) {
        lines.add(
          "${field.className}.values.byName(map['${field.columnName}'] as String);",
        );
      } else if (field.type == .dtReference) {
        var typeName = '${field.className}?';
        // if (field.constructType == .optional) {
        //  typeName = '$typeName?';
        //}
        lines.add("map['${field.columnName}'] as $typeName;");
        if (field.constructType == .notIncluded) {
          lines.addAll([
            'if (${field.name} != null) {',
            "params['${field.name}'] = ${field.name};",
            '}',
          ]);
        }
      } else if (field.type == _DataType.dtBackLink ||
          field.type == _DataType.dtManyReference ||
          field.type == _DataType.dtBackLinkMany) {
        lines.add("map['${field.columnName}'] as List<${field.className}>;");
      } else {
        lines.add("map['${field.columnName}'] as ${field.type.dartType};");
      }
      lines.add("keys.remove('${field.columnName}');");

      if (field.constructType != .required) {
        lines.add('}');
      }
      lines.add('');
    }

    lines.add('if (keys.isNotEmpty) {');
    lines.add(' throw ArgumentError(\'Unkown map keys. \$keys\');');
    lines.add('}');
    lines.add('');

    lines.add('final \$item = $className(');
    for (final param in _requiredPositional) {
      lines.add('$param,');
    }
    for (final param in _optionalPositional) {
      lines.add('$param,');
    }

    for (final field in _fieldMap.values) {
      if (_requiredPositional.contains(field.name)) {
        continue;
      }
      if (_optionalPositional.contains(field.name)) {
        continue;
      }
      if (field.constructType == .notIncluded) {
        continue;
      }
      lines.add('${field.name}: ${field.name},');
    }
    lines.add(');');
    lines.add('');

    for (final field in _fieldMap.values.where(
      (field) => field.constructType == .notIncluded,
    )) {
      lines.add("if (params['${field.name}'] != null) {");
      var type = field.type.dartType;
      if (type.isEmpty) {
        type = field.className;
      }
      if (field.type == _DataType.dtBackLink ||
          field.type == _DataType.dtManyReference ||
          field.type == _DataType.dtBackLinkMany) {
        type = 'List<${field.className}>';
      }
      lines.add("\$item.${field.name} = params['${field.name}'] as $type;");
      lines.add('}');
    }

    lines.add('return \$item;');
    lines.add('}'); // end of function

    return lines;
  }

  List<String> _generateRegisterMethods(String className, String appDbName) {
    final batch = '_\$${appDbName}BatchWrapper';
    var lines = <String>[];

    // compare many reference fields
    final manyFields = _fieldMap.values.where(
      (field) => field.type == .dtManyReference,
    );
    for (final field in manyFields) {
      final upperCamel = toUpperCamelCase(field.name);
      lines.addAll([
        'bool compare$upperCamel(',
        '  $className item1, Set<int> set2) {',
        '  if (item1.${field.name}.length != set2.length) {',
        '    return false;',
        '  }',
        '  final list1 = item1.${field.name}.map((e) => e.id).toList();',
        '  for (final item in list1) {',
        '    if (!set2.contains(item)) {',
        '      return false;',
        '    }',
        '  }',
        '  return true;',
        '}',
        '',
      ]);
    }

    // register middle records for many to many fields
    for (final field in manyFields) {
      final manyToMany = field.annotationObject as _ManyToManyInternal;
      final upperCamel = toUpperCamelCase(field.name);
      final middleHelper = 'appdb.${toLowerCamelCase(manyToMany.middle)}Helper';
      lines.addAll([
        'Future<void> register$upperCamel($className item,',
        ' _\$${appDbName}Executor executor) async {',
        '  final batch = executor.batch();',
        '  for (final target in item.${field.name}) {',
        '    Map<String, Object?> middleMap = {};',
        '    middleMap[$middleHelper.column.${manyToMany.self}] = item;',
        '    middleMap[$middleHelper.column.${manyToMany.target}] = target;',
        "    middleMap[$middleHelper.column.${manyToMany.field}] = '${field.name}';",
        '    final middle = ${manyToMany.middle}.fromSqlMap(middleMap);',
        //'    final middle = ${manyToMany.middle}(',
        // '      ${manyToMany.self}: id,',
        // '      ${manyToMany.target}: target.id,',
        // '    );',
        '    batch.register${manyToMany.middle}(middle);',
        '  }',
        '  await batch.commit();',
        '}',
      ]);
    }

    // register
    final registerCommon = [];
    for (final field in manyFields) {
      registerCommon.addAll([
        'final ${field.name}Noids = item.${field.name}.where((e) => e.id == 0);',
        'if (${field.name}Noids.isNotEmpty) {',
        '  throw ArgumentError('
            "'Cannot register $className because ${field.name} has unregistered items.'"
            ');',
        '}',
        'if (item.${field.name}.length != item.${field.name}.toSet().length) {',
        '  throw ArgumentError(',
        "'Cannot register $className because ${field.name} has duplicate items.');",
        '}',
      ]);
    }

    registerCommon.addAll([
      'final map = item.toSqlMap();',
      "var command = 'REPLACE INTO';",
      'final originalId = item.id;',
      'if (originalId == 0) {',
      "  command = 'INSERT INTO';",
      '}',
      'final keys = map.keys.map((e) => \'"\$e"\').toList();',
      "final sql = '\$command \$tableName (\${keys.join(',')}) VALUES (\${List.filled(map.length, '?').join(', ')})';",
      "// print('register sql: \$sql');",
      "// print('args: \${map.values.toList()}');",
    ]);

    final registerCommon2 = [];
    for (final field in manyFields) {
      final upperCamel = toUpperCamelCase(field.name);
      final manyToMany = field.annotationObject as _ManyToManyInternal;
      final middleClassName = manyToMany.middle;
      final middleHelper = '${toLowerCamelCase(middleClassName)}Helper';
      final selfField = manyToMany.self;
      final targetField = manyToMany.target;

      registerCommon2.addAll([
        '// handle many to many relation for ${field.name}',
        'bool add$upperCamel = true;',
        'if (originalId != 0) {',
        ' // compare existing middle records',
        ' final existingMiddleList = await executor.query(',
        '   appdb.$middleHelper.tableName,',
        "   where:'\${appdb.$middleHelper.column.$selfField} = ? AND \${appdb.$middleHelper.column.${manyToMany.field}} = ?',",
        "   whereArgs: [originalId, '${field.name}'],",
        ' );',
        ' final existingTargetIds = existingMiddleList',
        '   .where((e) => e[appdb.$middleHelper.column.$targetField] != null)',
        '   .map((e) => e[appdb.$middleHelper.column.$targetField] as int)',
        '   .toSet();',
        ' if (!compare$upperCamel(item, existingTargetIds)) {',
        '   // delete middle records',
        '   await executor.delete$middleClassName(',
        "     where: '\${appdb.$middleHelper.column.$selfField} = ? AND \${appdb.$middleHelper.column.${manyToMany.field}} = ?',",
        "     whereArgs: [originalId, '${field.name}'],",
        '   );',
        ' } else {',
        '   add$upperCamel = false;',
        ' }',
        '}',
        //'if (item.id == 0) {',
        //'item.id = id;',
        //'}',
        'if (add$upperCamel) {',
        '  // register middle records',
        '  await register$upperCamel(item, executor);',
        '}',
      ]);
    }

    final registerCommand = 'rawInsert(sql, map.values.toList(),';
    final idField = _fieldMap['id']!;
    lines.addAll([
      'Future<int> register($className item , _\$${appDbName}Executor db) async {',
      ...registerCommon,
      'final id = await db.$registerCommand);',
      '  // set id if possible',
      if (!idField.isFinal)  '  item.id = id;',
      '',
      if (registerCommon2.isNotEmpty) 'final executor = db;',
      ...registerCommon2,
      '',
      'return id;',
      '}',
      '',
      'void registerBatch($className item, $batch batch) {',
      ...registerCommon,
      '  batch.$registerCommand (noResult, object) async {',
      if (registerCommon2.isNotEmpty) '    final executor = batch.executor;',
      '    if (item.id == 0) {',
      '      if (noResult == true || object is! int) {',
      "        throw StateError('returned object \$object is not int.');",
      '     }',
      '     // set id if possible',
      if (!idField.isFinal)  '      item.id = object;',
      '    }',
      ...registerCommon2,
      '    return object;',
      '  });',
      '}',
      '',
    ]);

    return lines;
  }

  List<String> _generateDataHandlers(String className, String appDbName) {
    final batch = '_\$${appDbName}BatchWrapper';
    var lines = <String>[];

    // convert reference
    lines.addAll([
      'Future<List<Map<String, Object?>>> convertReferences(',
      'List<Map<String, Object?>> mapList, _\$${appDbName}Executor db,',
      ' List<({String table, String column})> dropKeys) async {',
    ]);

    for (final field in _fieldMap.values) {
      if (field.type == .dtManyReference) {
        var varName = toLowerCamelCase(field.className);
        varName = '${varName}Helper';
        final manyToMany = field.annotationObject as _ManyToManyInternal;
        final middleHelper = '${toLowerCamelCase(manyToMany.middle)}Helper';
        var asc = 'ASC';
        if (manyToMany.descendant) {
          asc = 'DESC';
        }

        lines.addAll([
          'final ${field.name}ColumnList = <String>[];',
          'for (final col in appdb.$middleHelper.columnList) {',
          '  ${field.name}ColumnList.add(\'\${appdb.$middleHelper.tableName}."\$col" as "\${_unquote(appdb.$middleHelper.tableName)}-\$col"\');',
          '}',
          'for (final col in appdb.$varName.columnList) {',
          '  ${field.name}ColumnList.add(\'\${appdb.$varName.tableName}."\$col" as "\${_unquote(appdb.$varName.tableName)}-\$col"\');',
          '}',
          "final ${field.name}Sql = '''SELECT \${${field.name}ColumnList.join(', ')} ",
          '        FROM \${appdb.$middleHelper.tableName} ',
          '        INNER JOIN \${appdb.$varName.tableName} ',
          '        ON \${appdb.$middleHelper.tableName}.\${appdb.$middleHelper.column.${manyToMany.target}} = ',
          '        \${appdb.$varName.tableName}."id" ',
          '        WHERE \${appdb.$middleHelper.tableName}.\${appdb.$middleHelper.column.${manyToMany.self}} = ? ',
          "        AND \${appdb.$middleHelper.tableName}.\${appdb.$middleHelper.column.${manyToMany.field}} ='${field.name}' ",
          "        ORDER BY \${appdb.$varName.tableName}.\${appdb.$varName.column.${manyToMany.order}} $asc''';",
          '',
        ]);
      } else if (field.type == .dtBackLinkMany) {
        var varName = toLowerCamelCase(field.className);
        varName = '${varName}Helper';
        final backLink = field.annotationObject as BackLink;
        final manyToMany = field.annotationObject2 as _ManyToManyInternal;
        final middleHelper = '${toLowerCamelCase(manyToMany.middle)}Helper';
        var asc = 'ASC';
        if (backLink.descendant) {
          asc = 'DESC';
        }

        lines.addAll([
          'final ${field.name}ColumnList = <String>[];',
          'for (final col in appdb.$middleHelper.columnList) {',
          '  ${field.name}ColumnList.add(\'\${appdb.$middleHelper.tableName}."\$col" as "\${_unquote(appdb.$middleHelper.tableName)}-\$col"\');',
          '}',
          'for (final col in appdb.$varName.columnList) {',
          '  ${field.name}ColumnList.add(\'\${appdb.$varName.tableName}."\$col" as "\${_unquote(appdb.$varName.tableName)}-\$col"\');',
          '}',
          "final ${field.name}Sql = '''SELECT \${${field.name}ColumnList.join(', ')} ",
          '        FROM \${appdb.$middleHelper.tableName} ',
          '        INNER JOIN \${appdb.$varName.tableName} ',
          '        ON \${appdb.$middleHelper.tableName}.\${appdb.$middleHelper.column.${manyToMany.self}} = ',
          '        \${appdb.$varName.tableName}."id" ',
          '        WHERE \${appdb.$middleHelper.tableName}.\${appdb.$middleHelper.column.${manyToMany.target}} = ? ',
          "        AND \${appdb.$middleHelper.tableName}.\${appdb.$middleHelper.column.${manyToMany.field}} ='${backLink.to}' ",
          "        ORDER BY \${appdb.$varName.tableName}.\${appdb.$varName.column.${backLink.order}} $asc''';",
          '',
        ]);
      }
    }

    lines.addAll([
      '  var result = mapList;',
      '  result = result.toList(); // convert to modifiable list',
      '  final batch = db.batch();',
      '',
      'for (var i = 0; i < result.length; i++) {',
      '  var map = result[i];',
      '  map = Map.from(map); // convert to modifiable map',
      '  result[i] = map;',
      '',
      '  // ignore: unused_local_variable',
      "  final id = map['id'] as int;",
      "  //print('$className(\$id) \${dropKeys.map((e) => '\${_unquote(e.table)}.\${_unquote(e.column)}').join(', ')}');",
      'for (final key in dropKeys) {',
      " if (_unquote(key.table) == '$tableName') {",
      '  map.remove(_unquote(key.column));',
      ' }',
      '}',
    ]);

    for (final field in _fieldMap.values) {
      if (field.type == .dtReference) {
        var className = field.className;
        if (className.endsWith('?')) {
          className = className.substring(0, className.length - 1);
        }
        var varName = toLowerCamelCase(className);
        varName = '${varName}Helper';

        lines.addAll([
          "final ${field.name}Id = map['${field.columnName}'] as int?;",
          "if (${field.name}Id != null) {",
          '  batch.get$className(${field.name}Id, dropKeys: dropKeys,',
          '  onCommit: (noResult, object) async {',
          "    map['${field.columnName}'] = object;",
          '    return object;',
          '});',
          '}',
        ]);
      } else if (field.type == .dtBackLink) {
        var varName = toLowerCamelCase(field.className);
        varName = '${varName}Helper';
        final backLink = field.annotationObject as BackLink;
        var asc = 'ASC';
        if (backLink.descendant) {
          asc = 'DESC';
        }

        lines.addAll([
          //'  final id = map[column.id] as int;',
          'batch.query${field.className}(',
          "where:'\${appdb.$varName.column.${backLink.to}} = ?',",
          'whereArgs: [id],',
          "orderBy: '\${appdb.$varName.column.${backLink.order}} $asc',",
          'dropKeys: [(table: appdb.$varName.tableName, column: appdb.$varName.column.${backLink.to}), ...dropKeys],',
          'onCommit: (noResult, object) async {',
          'if(noResult == true || object is! List<${field.className}>) {',
          "  throw StateError('returned object \$object is not expected type.');",
          '}',
          "map['${field.columnName}'] = object;",
          '  return object;',
          '}',
          ');',
          '',
        ]);
      } else if (field.type == .dtManyReference ||
          field.type == .dtBackLinkMany) {
        var varName = toLowerCamelCase(field.className);
        varName = '${varName}Helper';
        var dropKeys = <String>[];
        if (field.type == .dtBackLinkMany) {
          final backLink = field.annotationObject as BackLink;
          dropKeys.add(
            "(table: appdb.$varName.tableName, column: '${toSnakeCase(backLink.to)}')",
          );
        } else if (field.type == .dtManyReference) {
          dropKeys.addAll(
            field.dropList.map(
              (e) => "(table: appdb.$varName.tableName, column:'$e')",
            ),
          );
        }
        for (final otherField in _fieldMap.values) {
          if (otherField.name == field.name) {
            continue;
          }
          if (otherField.className == field.className) {
            if (otherField.type == .dtBackLinkMany) {
              final backLink2 = otherField.annotationObject as BackLink;
              dropKeys.add(
                "(table: appdb.$varName.tableName, column:'${toSnakeCase(backLink2.to)}')",
              );
            } else if (otherField.type == .dtManyReference) {
              dropKeys.addAll(
                otherField.dropList.map(
                  (e) => "(table: appdb.$varName.tableName, column:'$e')",
                ),
              );
            }
          }
        }
        lines.addAll([
          //"if (!dropKeys.contains('${field.columnName}')) {",
          "if (dropKeys.where((e) => _unquote(e.table) == '$tableName' && e.column == '${field.columnName}').isEmpty) {"
              'batch.rawQuery(',
          '${field.name}Sql,',
          '[id],',
          '(noResult, object) async {',
          '  if(noResult == true || object is! List<Map<String, Object?>>) {',
          "    throw StateError('returned object \$object is not expected type.');",
          '  }',
          '  final middleList = object;',

          '  var targetMapList = <Map<String, Object?>>[];',
          '  for (final middleMap in middleList) {',
          '    final targetMap = <String, Object?>{};',
          '    for (final key in middleMap.keys) {',
          "      if (key.startsWith('\${_unquote(appdb.$varName.tableName)}-')) {",
          "        final newKey = key.substring(_unquote(appdb.$varName.tableName).length + 1);",
          '        targetMap[newKey] = middleMap[key];',
          '      }',
          '    }',
          '      targetMapList.add(targetMap);',
          '  }',
          "  targetMapList = await appdb.$varName.convertReferences(targetMapList, db, [...dropKeys, ${dropKeys.join(', ')}]);",
          '  final targetList = targetMapList.map((targetMap) => ${field.className}.fromSqlMap(targetMap)).toList();',
          "  map['${field.columnName}'] = targetList;",
          '  return targetList;',
          '},',
          ');',
          '}',
          '',
        ]);
      }
    }
    lines.addAll([
      '}', // end for
      'await batch.commit();',
      '',
      '',
      'return result;',
      '}', // end function
      '',
    ]);

    // mapToObject
    lines.addAll([
      '/// convert map list from sql query to object list',
      'List<$className> mapToObject(List<Map<String, Object?>> mapList) {',
      ' final result = mapList.map((map) => $className.fromSqlMap(map)).toList();',
    ]);
    final backLinkFields = _fieldMap.values.where(
      (field) => field.type == .dtBackLink,
    );
    if (backLinkFields.isNotEmpty) {
      lines.add('for (final object in result){');
      for (final field in _fieldMap.values) {
        if (field.type == .dtBackLink) {
          final backLink = field.annotationObject as BackLink;
          if (isFreezed) {
            lines.addAll([
              'for (var i = 0; i < object.${field.name}.length; i++) {',
              'final item = object.${field.name}[i];',
              'final item2 = item.copyWith(${backLink.to}: object);',
              'object.${field.name}[i] = item2;',
              '}',
            ]);
          } else {
            lines.addAll([
              'for (final item in object.${field.name}) {',
              'item.${backLink.to} = object;',
              '}',
            ]);
          }
        }
      }
      lines.add('}'); // end for
    }
    lines.addAll([
      'return result;'
          '}', // end func
      '',
    ]);

    // query
    final queryCommon = [
      '',
      '  final result = mapToObject(queryResult);',
      '  return result;',
    ];
    final queryCommand =
        'query(tableName, where: where, whereArgs: whereArgs, orderBy: orderBy, limit: limit, offset: offset,';
    lines.addAll([
      'Future<List<$className>> query(_\$${appDbName}Executor db, '
          '  {String? where, List<Object?>? whereArgs, ',
      '  String? orderBy, int? limit, int? offset,',
      '  List<({String table, String column})> dropKeys = const [], ',
      '  }) async {',
      '',
      '  var queryResult = await db.$queryCommand);',
      '  queryResult = await convertReferences(queryResult, db, dropKeys);',
      ...queryCommon,
      '}',
      '',
      'void queryBatch($batch batch, ',
      '{String? where, List<Object?>? whereArgs, ',
      '  String? orderBy, int? limit, int? offset,',
      '  List<({String table, String column})> dropKeys = const [], ',
      '  }) {',
      '  batch.$queryCommand',
      '  onCommit: (noResult, object) async {',
      '    if(noResult == true || object is! List<Map<String, Object?>>) {',
      "      throw StateError('returned object \$object is not expected type.');",
      '    }',
      '    var queryResult = await convertReferences(object, batch.executor, dropKeys);',
      ...queryCommon,
      '  },',
      ');',
      '}',
      '',
    ]);

    // get
    lines.addAll([
      'Future<$className?> get(int id, _\$${appDbName}Executor db, [',
      'List<({String table, String column})> dropKeys = const []]) async {',
      '  final result = await query(db, ',
      "    where: '\${column.id} = ?',",
      '    whereArgs: [id],',
      '    dropKeys: dropKeys);',
      '',
      '  if (result.isEmpty) {',
      '    return null;',
      '  }',
      '',
      '  assert(result.length == 1);',
      '  return result[0];',
      '}',
      '',
      'void getBatch(int id, $batch batch, [',
      '  List<({String table, String column})> dropKeys = const []]) {',
      "  batch.query(tableName, where: '\${column.id} = ?', whereArgs: [id],",
      '    onCommit: (noResult, object) async {',
      '    if(noResult == true || object is! List<Map<String, Object?>>) {',
      "      throw StateError('returned object \$object is not expected type.');",
      '    }',
      '',
      '    if (object.isEmpty) {',
      '       return null;',
      '    }',
      '',
      '    final queryResult = await convertReferences(object, batch.executor, dropKeys);',
      '    final result = mapToObject(queryResult);',
      '    assert(result.length == 1);',
      '    return result[0];',
      '',
      '    },',
      ' );',
      '}',
      '',
    ]);

    // delete
    final deleteCommon = [
      'final noids = itemList.where((e) => e.id == 0);',
      'if (noids.isNotEmpty) {',
      '  throw ArgumentError(',
      "    'Cannot delete $className because id is 0.'",
      '  );',
      '}',
      'final ids = itemList.map((e) => e.id).toSet().toList();',
      '',
    ];
    final deleteCommon2 = <String>[];
    final deleteCommon3 = <String>[];
    for (final field in _fieldMap.values) {
      if (field.type == .dtManyReference) {
        final manyToMany = field.annotationObject as _ManyToManyInternal;
        final middleHelper = '${toLowerCamelCase(manyToMany.middle)}Helper';
        final selfField = manyToMany.self;

        deleteCommon2.addAll([
          '// delete many to many middle records for ${field.name}',
          'await db.delete${manyToMany.middle}(',
          "  where:'\${appdb.$middleHelper.column.$selfField} in (\${List.filled(ids.length, '?').join(',')})',",
          '  whereArgs: ids,',
          ');',
        ]);
        deleteCommon3.addAll([
          '// delete many to many middle records for ${field.name}',
          'batch.delete${manyToMany.middle}(',
          "  where:'\${appdb.$middleHelper.column.$selfField} in (\${List.filled(ids.length, '?').join(',')})',",
          '  whereArgs: ids,',
          ');',
        ]);
      }
    }

    final deleteCmd =
        "delete(tableName, where: '\${column.id} in (\${List.filled(ids.length, '?').join(',')})', whereArgs: ids);";

    final manyFields = _fieldMap.values.where(
      (field) => field.type == .dtManyReference,
    );

    lines.addAll([
      'Future<int> delete(_\$${appDbName}Executor db, {String? where, List<Object?>? whereArgs}) async {',
    ]);
    if (manyFields.isNotEmpty) {
      lines.addAll(['  // delete many to many middle records']);
      for (final field in manyFields) {
        final manyToMany = field.annotationObject as _ManyToManyInternal;
        final middleHelper = '${toLowerCamelCase(manyToMany.middle)}Helper';
        final selfField = manyToMany.self;

        lines.addAll([
          '  await db.delete${manyToMany.middle}(',
          "    where:'\${appdb.$middleHelper.column.$selfField} in (SELECT id FROM \$tableName "
              " \${where != null ? ' WHERE \$where' : ''})',"
              "    whereArgs: whereArgs,",
          '  );',
        ]);
      }
    }
    lines.addAll([
      'return db.delete(tableName, where: where, whereArgs: whereArgs);',
      '}',
      '',
      'Future<void> deleteBatch($batch batch, {String? where, List<Object?>? whereArgs}) async {',
    ]);
    if (manyFields.isNotEmpty) {
      lines.addAll(['  // delete many to many middle records']);
      for (final field in manyFields) {
        final manyToMany = field.annotationObject as _ManyToManyInternal;
        final middleHelper = '${toLowerCamelCase(manyToMany.middle)}Helper';
        lines.addAll([
          '  batch.delete${manyToMany.middle}(',
          "    where:'\${appdb.$middleHelper.column.${manyToMany.self}} in (SELECT id FROM \$tableName "
              " \${where != null ? ' WHERE \$where' : ''})',"
              "    whereArgs: whereArgs,",
          '  );',
        ]);
      }
    }

    lines.addAll([
      'batch.delete(tableName, where: where, whereArgs: whereArgs);',
      '}',
      '',
      'Future<int> deleteByIds( _\$${appDbName}Executor db, List<$className> itemList) async {',
      ...deleteCommon,
      '',
      ...deleteCommon2,
      '',
      'final count = await db.$deleteCmd',
      'return count;',
      '}',
      '',
      'void deleteByIdsBatch($batch batch, List<$className> itemList) {',
      ...deleteCommon,
      '',
      ...deleteCommon3,
      '',
      'batch.$deleteCmd',
      '}',
      '',
    ]);
    return lines;
  }

  Future<Map<String, _FieldInfo>> _analyzeFields(
    ClassElement element,
    BuildStep buildStep, {
    bool avoidRecursive = false,
  }) async {
    final fieldMap = <String, _FieldInfo>{};
    //_fieldMap.clear();

    //print('analyzing fields of ${element.name}');

    for (final field in element.fields) {
      if (field.isPrivate) {
        continue;
      }
      if (field.isStatic) {
        continue;
      }

      if (_annotatedWith(field, 'Ignore')) {
        continue;
      }

      final name = field.displayName;

      final fieldInfo = _FieldInfo();
      fieldInfo.name = field.displayName;
      fieldInfo.columnName = toSnakeCase(fieldInfo.name);
      fieldInfo.isFinal = field.isFinal;

      var type = _DataType.dtUnknown;
      var typeName = field.type.getDisplayString();
      if (field.type.isDartCoreInt) {
        type = _DataType.dtInteger;
      } else if (field.type.isDartCoreDouble) {
        type = _DataType.dtDouble;
      } else if (field.type.isDartCoreString) {
        type = _DataType.dtString;
      } else if (field.type.isDartCoreBool) {
        type = _DataType.dtBool;
      } else if (field.type.element?.library?.displayName == 'dart.core' &&
          typeName == 'DateTime') {
        type = _DataType.dtDateTime;
      } else if (field.type.element is EnumElement) {
        type = _DataType.dtEnum;
        fieldInfo.className = typeName;
      } else if (_annotatedWith(field.type.element, 'Table')) {
        if (field.type.nullabilitySuffix != .question) {
          final msg =
              '${element.name}: field ${field.name} must be nullable type';
          throw InvalidGenerationSourceError(msg);
        }
        if (typeName.endsWith('?')) {
          typeName = typeName.substring(0, typeName.length - 1);
        }
        if (!tableNameList.contains(typeName)) {
          final msg = '$typeName is not included in $appDbName';
          throw InvalidGenerationSourceError(msg);
        }
        type = _DataType.dtReference;
        fieldInfo.className = typeName;
        fieldInfo.columnName += '_id';
      } else {
        var linkName = '';
        if (_annotatedWith(field, 'BackLink')) {
          linkName = 'BackLink';
          type = _DataType.dtBackLink;
        } else if (_annotatedWith(field, 'ManyToMany')) {
          linkName = 'ManyToMany';
          type = _DataType.dtManyReference;
        } else {
          final msg =
              "${element.name}: field ${field.name} is unsupported type";
          throw InvalidGenerationSourceError(msg);
        }
        fieldInfo.annotationObject = annotationObject;
        if (!field.type.isDartCoreList) {
          final msg =
              '${element.name}: field ${field.name} is $linkName and it must be List';
          throw InvalidGenerationSourceError(msg);
        }
        if (field.type is! ParameterizedType) {
          final msg =
              '${element.name}: field ${field.name} is $linkName and it must be generic List';
          throw InvalidGenerationSourceError(msg);
        }
        final dartType = field.type as ParameterizedType;
        if (dartType.typeArguments.isEmpty) {
          final msg =
              '${element.name}: field ${field.name} is $linkName but cannot get List type';
          throw InvalidGenerationSourceError(msg);
        }
        if (!_annotatedWith(dartType.typeArguments[0].element, 'Table')) {
          final msg =
              '${element.name}: field ${field.name} is $linkName but it is not List of table class';
          throw InvalidGenerationSourceError(msg);
        }

        typeName = dartType.typeArguments[0].getDisplayString();
        if (!tableNameList.contains(typeName)) {
          final msg = '$typeName is not included in $appDbName';
          throw InvalidGenerationSourceError(msg);
        }
        fieldInfo.className = typeName;

        final library = await buildStep.inputLibrary;
        if (fieldInfo.annotationObject is _ManyToManyInternal) {
          // many to many field validation
          final manyToMany = fieldInfo.annotationObject as _ManyToManyInternal;

          if (tableNameList.contains(manyToMany.middle) == false) {
            final msg =
                '${element.name}: annotation error. '
                'class ${manyToMany.middle} is not included in $appDbName';
            throw InvalidGenerationSourceError(msg);
          }
          final middleElement = library.getClass(manyToMany.middle);
          if (middleElement == null) {
            final msg =
                '${element.name}: annotation error. '
                'class ${manyToMany.middle} not found';
            throw InvalidGenerationSourceError(msg);
          }

          final middleFieldMap = await _analyzeFields(middleElement, buildStep);
          final selfField = middleFieldMap[manyToMany.self];
          if (selfField == null) {
            final msg =
                '${element.name}: ${fieldInfo.name} annotation error. '
                'field ${manyToMany.self} not found in class ${manyToMany.middle}';
            throw InvalidGenerationSourceError(msg);
          }
          if (selfField.className != element.name) {
            final msg =
                '${element.name}: ${fieldInfo.name} annotation error. '
                'field ${manyToMany.self} type mismatch in class ${manyToMany.middle}';
            throw InvalidGenerationSourceError(msg);
          }
          final targetField = middleFieldMap[manyToMany.target];
          if (targetField == null) {
            final msg =
                '${element.name}: ${fieldInfo.name} annotation error. '
                'field ${manyToMany.target} not found in class ${manyToMany.middle}';
            throw InvalidGenerationSourceError(msg);
          }
          if (targetField.className != typeName) {
            final msg =
                '${element.name}: ${fieldInfo.name} annotation error. '
                'field ${manyToMany.target} type mismatch in class ${manyToMany.middle}';
            throw InvalidGenerationSourceError(msg);
          }
          final fieldField = middleFieldMap[manyToMany.field];
          if (fieldField == null) {
            final msg =
                '${element.name}: ${fieldInfo.name} annotation error. '
                'field ${manyToMany.field} not found in class ${manyToMany.middle}';
            throw InvalidGenerationSourceError(msg);
          }
          if (fieldField.type != _DataType.dtString) {
            final msg =
                '${element.name}: ${fieldInfo.name} annotation error. '
                'field ${manyToMany.field} must be String in class ${manyToMany.middle}';
            throw InvalidGenerationSourceError(msg);
          }
          final linkElement = library.getClass(fieldInfo.className);
          if (linkElement == null) {
            final msg =
                '${element.name}: annotation error. '
                'class ${fieldInfo.className} not found';
            throw InvalidGenerationSourceError(msg);
          }
          if (avoidRecursive == false) {
            final linkFieldMap = await _analyzeFields(
              linkElement,
              buildStep,
              avoidRecursive: true,
            );
            for (final linkField in linkFieldMap.values) {
              // if analyzeFields is called with avoidRecursive=true,
              // cannot recognize whether dtBackLinkMany or dtBackLink
              if (linkField.type == _DataType.dtBackLinkMany ||
                  linkField.type == _DataType.dtBackLink) {
                final backLink = linkField.annotationObject as BackLink;
                if (backLink.to == fieldInfo.name) {
                  fieldInfo.dropList.add(linkField.columnName);
                }
              }
            }
          }
        } else {
          // back link validation
          final backLink = fieldInfo.annotationObject as BackLink;

          final toElement = library.getClass(fieldInfo.className);
          if (toElement == null) {
            final msg =
                '${element.name}: annotation error. '
                'class ${fieldInfo.className} not found';
            throw InvalidGenerationSourceError(msg);
          }

          if (avoidRecursive == false) {
            final toFieldMap = await _analyzeFields(
              toElement,
              buildStep,
              avoidRecursive: true,
            );
            final toField = toFieldMap[backLink.to];
            if (toField == null) {
              final msg =
                  '${element.name}: ${fieldInfo.name} annotation error. '
                  'field ${backLink.to} not found in class ${backLink.to}';
              throw InvalidGenerationSourceError(msg);
            }
            if (toField.className != element.name) {
              final msg =
                  '${element.name}: ${fieldInfo.name} annotation error. '
                  'field ${backLink.to} type mismatch in class ${backLink.to}';
              throw InvalidGenerationSourceError(msg);
            }
            if (toField.type == _DataType.dtManyReference) {
              type = _DataType.dtBackLinkMany;
              fieldInfo.annotationObject2 = toField.annotationObject;
            }
          }
        }
      }

      if (_annotatedWith(field, 'Index')) {
        if (type == _DataType.dtBackLink ||
            type == _DataType.dtBackLinkMany ||
            type == _DataType.dtManyReference) {
          final msg = '${element.name}: field ${field.name} cannot be indexed.';
          throw InvalidGenerationSourceError(msg);
        }
        fieldInfo.isIndexed = true;
        fieldInfo.annotationObject = annotationObject;
      }
      fieldInfo.type = type;

      fieldMap[name] = fieldInfo;
    }
    return fieldMap;
  }

  Future<void> _analyzeConstructor(ClassElement element) async {
    _requiredPositional.clear();
    _optionalPositional.clear();

    final constructor = element.unnamedConstructor;
    if (constructor == null || constructor.isPrivate) {
      final msg =
          'class ${element.displayName} must have an unnamed constructor';
      throw InvalidGenerationSourceError(msg);
    }

    final paramList = constructor.formalParameters;
    final positionalParams = paramList
        .where((param) => param.isPositional)
        .toList();
    for (final param in positionalParams) {
      if (!_fieldMap.containsKey(param.name) && param.isRequired) {
        throw InvalidGenerationSourceError(
          '${element.displayName}: No matching field for constructor parameter ${param.name}',
        );
      }
      if (param.isRequired) {
        _fieldMap[param.name]!.constructType = .required;
        _requiredPositional.add(param.displayName);
      } else {
        _fieldMap[param.name]!.constructType = .optional;
        _optionalPositional.add(param.displayName);
      }
    }

    final namedParams = paramList.where((param) => param.isNamed).toList();
    for (final param in namedParams) {
      if (!_fieldMap.containsKey(param.name) && param.isRequired) {
        throw InvalidGenerationSourceError(
          '${element.displayName}: No matching field for constructor parameter ${param.name}',
        );
      }
      if (!_fieldMap.containsKey(param.name)) {
        // optional constructor parameter is not field. ignore.
        continue;
      }

      if (param.isRequired) {
        _fieldMap[param.name]!.constructType = .required;
      } else {
        _fieldMap[param.name]!.constructType = .optional;
      }
    }

    final optionalParams = paramList.where((param) => param.isOptional);

    for (final param in optionalParams) {
      if (!_fieldMap.containsKey(param.displayName)) {
        continue;
      }

      final field = _fieldMap[param.displayName]!;
      if (field.type == .dtReference) {
        // reference field is nullable
        continue;
      }

      if (!param.hasDefaultValue || param.defaultValueCode == null) {
        throw InvalidGenerationSourceError(
          '${element.displayName}: constructor parameter ${param.name} '
          'is optional but not have default value.',
        );
      }
      final defaultValue = param.defaultValueCode!;
      _fieldMap[param.displayName]!.defaultValue = defaultValue;
    }

    for (final fieldInfo in _fieldMap.values) {
      if (fieldInfo.constructType == .required &&
          fieldInfo.type == _DataType.dtReference) {
        final msg =
            '${element.displayName}: ${fieldInfo.name}'
            ' must be optional parameter of constructor.';
        throw InvalidGenerationSourceError(msg);
      }
    }
  }

  Future<void> _analyzeStaticFields(
    ClassElement element,
    int schemaVersion,
    BuildStep buildStep,
  ) async {
    for (final field in element.fields) {
      if (!field.isStatic) {
        continue;
      }
      if (!field.displayName.endsWith('ColumnList')) {
        continue;
      }

      final astNode = await buildStep.resolver.astNodeFor(field.firstFragment);
      if (astNode == null) {
        continue;
      }
      //print(astNode.childEntities.length);
      final visitor = _StringListVisitor();
      astNode.visitChildren(visitor);

      if (visitor.isList) {
        _columnMap[field.displayName] = visitor.values;
      }
    }
  }

  /// get schemaVersion from KegDb annotation
  Future<void> _getSchemaVersion(String className, BuildStep buildStep) async {
    // find KegDb annotation
    final library = await buildStep.inputLibrary;
    final libraryReader = LibraryReader(library);
    final checker = TypeChecker.typeNamed(KegDatabase);
    final annotatedElements = libraryReader.annotatedWith(checker);

    schemaVersion = 0;
    for (final annotatedElement in annotatedElements) {
      final appDbElement = annotatedElement.element;
      if (appDbElement is! ClassElement) {
        // could be error but ignores this time
        continue;
      }
      final dartObject = annotatedElement.annotation.objectValue;
      final tableNameListTmp = dartObject
          .getField('tables')
          ?.toListValue()
          ?.map((e) => e.toTypeValue()?.getDisplayString())
          .toList();
      if (tableNameListTmp == null) {
        continue;
      }

      tableNameList = tableNameListTmp;
      if (!tableNameList.contains(className)) {
        continue;
      }
      final tmpVersion = dartObject.getField('schemaVersion')?.toIntValue();
      if (tmpVersion == null) {
        continue;
      }
      // if (version != 0 &&  version != tmpVersion) {
      if (schemaVersion != 0) {
        //final msg = 'class $className is included in multiple database and different schema version';
        final msg =
            'class $className is included in multiple database($appDbName and ${appDbElement.displayName})';
        throw InvalidGenerationSourceError(msg);
      }
      appDbName = appDbElement.displayName;
      schemaVersion = tmpVersion;
    }

    return;
  }

  Object? annotationObject;
  bool _annotatedWith(
    Element? field,
    String name, {
    String package = 'package:keg_annotation',
  }) {
    bool found = false;

    if (field == null) {
      return false;
    }

    final annotations = field.metadata.annotations;
    if (field is FieldElement) {
      // for field, also check getter and setter
      if (field.getter != null) {
        annotations.addAll(field.getter!.metadata.annotations);
      }
      if (field.setter != null) {
        annotations.addAll(field.setter!.metadata.annotations);
      }
    }
    for (final annotation in annotations) {
      final annoElem = annotation.element;
      if (annoElem == null) {
        continue;
      }
      final library = annoElem.library;
      if (library == null) {
        continue;
      }
      final dartObject = annotation.computeConstantValue();
      if (dartObject == null) {
        continue;
      }
      if (dartObject.type == null) {
        continue;
      }

      final typeName = dartObject.type!.getDisplayString();

      //      if (annoElem.displayName.toLowerCase() == name.toLowerCase() &&
      //          library.identifier.startsWith('package:keg_annotation')) {
      if (typeName == name &&
          library.identifier.startsWith(package)) {
        found = true;
        annotationObject = null;
        //        if (annoElem.displayName == 'BackLink' ||
        //            annoElem.displayName == 'ManyToMany') {
        if (typeName == 'BackLink' || typeName == 'ManyToMany') {
          //final dartObject = annotation.computeConstantValue();
          final order = dartObject.getField('order')?.toStringValue();
          final desc = dartObject.getField('descendant')?.toBoolValue();
          if (typeName == 'BackLink') {
            final to = dartObject.getField('to')?.toStringValue();
            if (to != null && order != null && desc != null) {
              annotationObject = BackLink(
                to: to,
                order: order,
                descendant: desc,
              );
            }
          } else if (typeName == 'ManyToMany') {
            final self = dartObject.getField('self')?.toStringValue();
            final target = dartObject.getField('target')?.toStringValue();
            final middle = dartObject.getField('middle')?.toTypeValue();
            final field = dartObject.getField('field')?.toStringValue();
            if (self != null &&
                target != null &&
                middle != null &&
                field != null &&
                order != null &&
                desc != null) {
              annotationObject = _ManyToManyInternal(
                middle: middle.getDisplayString(),
                self: self,
                target: target,
                field: field,
                order: order,
                descendant: desc,
              );
            }
          }
        } else if (typeName == 'Index') {
          final unique = dartObject.getField('unique')?.toBoolValue();
          final desc = dartObject.getField('descendant')?.toBoolValue();
          if (unique != null && desc != null) {
            annotationObject = Index(unique: unique, descendant: desc);
          }
        }
        break;
      }
    }

    return found;
  }

  /// Converts a CamelCase string to snake_case.
  String toSnakeCase(String input) {
    final regex = RegExp(r'(?<=[a-z])[A-Z]');
    return input
        .replaceAllMapped(regex, (Match m) => '_${m.group(0)}')
        .toLowerCase();
  }

  /// Convert class name to variable name
  String toLowerCamelCase(String input) {
    if (input.isEmpty) return input;
    return input[0].toLowerCase() + input.substring(1);
  }

  /// Convert variable name to first character to upper case
  String toUpperCamelCase(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }
}

enum _DataType {
  dtUnknown(dartType: ''),
  dtInteger(dartType: 'int'),
  dtDouble(dartType: 'double'),
  dtString(dartType: 'String'),
  dtBool(dartType: 'bool'),
  dtDateTime(dartType: 'DateTime'),
  dtEnum(dartType: ''),
  dtReference(dartType: ''),
  dtBackLink(dartType: ''),
  dtManyReference(dartType: ''),
  dtBackLinkMany(dartType: '');

  const _DataType({required this.dartType});

  final String dartType;
}

enum ConstructType {
  required, // required parameter of constructor
  optional, // optional parameter of constructor
  notIncluded, // not included in constructor
}

class _FieldInfo {
  String name = '';
  String columnName = '';
  _DataType type = .dtUnknown;
  String className = ''; // for enum and ref
  String defaultValue = '';
  bool isFinal = false;
  ConstructType constructType = .notIncluded;
  bool isIndexed = false;

  List<String> dropList =
      []; // to avoid circular reference in many to many relation

  Object? annotationObject;
  Object? annotationObject2;
}

/// copy of ManyToMany annotation except midle field
class _ManyToManyInternal {
  final String middle;
  final String self;
  final String target;
  final String field;
  final String order;
  final bool descendant;

  const _ManyToManyInternal({
    required this.middle,
    required this.self,
    required this.target,
    this.field = 'field',
    this.order = "id",
    this.descendant = false,
  });
}

class _StringListVisitor extends GeneralizingAstVisitor {
  bool isList = false;
  List<String> values = [];

  @override
  visitListLiteral(ListLiteral node) {
    isList = true;
    return super.visitListLiteral(node);
  }

  @override
  visitSimpleStringLiteral(SimpleStringLiteral node) {
    // print('string literal: ${node.literal} ${node.value}');
    if (isList) {
      values.add(node.value);
    }
    return super.visitSimpleStringLiteral(node);
  }
}
