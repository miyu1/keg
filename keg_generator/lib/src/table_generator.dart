import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'package:keg_annotation/keg_annotation.dart';

class TableGenerator extends GeneratorForAnnotation<Table> {
  final Map<String, _FieldInfo> _fieldMap = {};
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

    // initialize values
    _fieldMap.clear();
    _requiredPositional.clear();
    _optionalPositional.clear();
    _columnMap.clear();
    appDbName = '';
    schemaVersion = 0;
    tableNameList = [];

    final className = element.displayName;
    final tableName = toSnakeCase(className);

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

    await _analyzeFields(element);

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
      if (field.type == .dtBackLink) {
        continue;
      }

      if (field.type == .dtUnknown) {
        final msg = '$className: field ${field.name} undetermined type';
        throw InvalidGenerationSourceError(msg);
      }
      columnRecord += "${field.name}:'${field.columnName}', ";
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
        dbTypeStr += ' REFERENCES $className(id)';
      } else {
        dbTypeStr += ' NOT NULL';
        dbTypeStr += switch (field.type) {
          .dtInteger => ' DEFAULT 0',
          .dtDouble => ' DEFAULT 0.0',
          .dtString => " DEFAULT ''",
          .dtBool => ' DEFAULT 0',
          .dtDateTime => ' DEFAULT 0',
          .dtEnum => " DEFAULT '\${${field.className}.values[0].name}'",
          _ => '',
        };
      }
      columnTypes += '\'${field.columnName}\':"$dbTypeStr", ';
    }
    var fullColumnList = columnList.substring(1);
    columnRecord += ')';
    columnList += ']';
    columnTypes += '}';

    fullColumnList = oldColumnList.map((e) => "'$e', ").join() + fullColumnList;
    fullColumnList = '[$fullColumnList]';

    final lines = <String>[
      'class _\$${className}Helper {',
      '  final String tableName = \'$tableName\';',
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
    lines.addAll(_generateDataHandlers(className, appDbName));

    lines.add('}'); // end of class

    return lines.join('\n');
  }

  List<String> _generateTableCreators(String className) {
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
      '      params.add(\'\$column \${columnTypes[column]}\');',
      '    }',
      '    final sql = \'CREATE TABLE IF NOT EXISTS \$tableName (\${params.join(\', \')})\';',
      '    print(\'Creating table: \$sql\');',
      '    if (db != null) {',
      '      await db.execute(sql);',
      '    } else if (batch != null) {',
      '      batch.execute(sql);',
      '    }',
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
      '      final sql = \'ALTER TABLE \$tableName ADD COLUMN \$column \${columnTypes[column]}\';',
      '      print(\'Altering table: \$sql\');',
      '      if (db != null) {',
      '        await db.execute(sql);',
      '      } else if (batch != null) {',
      '        batch.execute(sql);',
      '      }',
      '    }',
      '  }'
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
      if (field.type == .dtBackLink) {
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
          '  values["${field.columnName}"] = $valueStr;',
          '}',
        ]);
      } else if (field.type == .dtReference) {
        lines.addAll([
          'if (item.${field.name} != null) {'
              'final ${field.name}Id = $valueStr;',
          'if (${field.name}Id != 0) {',
          '  values["${field.columnName}"] = ${field.name}Id;',
          '} else {',
          "  throw StateError('$className.${field.name}.id is 0.');"
              '}',
          '}',
        ]);
      } else {
        lines.add('values["${field.columnName}"] = $valueStr;');
      }
      lines.add('');
    }
    lines.add('    return values;');
    lines.add('  }');

    // Generate the fromSqlMap method
    lines.add('static $className fromSqlMap(Map<String, Object?> map) {');
    lines.add('  final keys = map.keys.toSet();');
    if (_fieldMap.values.any((field) => field.constructType == .notIncluded)) {
      lines.add(' final params = <String, Object>{};');
    }

    // check required fields
    for (final field in _fieldMap.values.where(
      (field) => field.constructType == .required,
    )) {
      lines.add('if (!keys.contains("${field.columnName}")) {');
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
        } else if (field.type == .dtBackLink) {
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
      } else if (field.type == .dtBackLink) {
        lines.add("map['${field.columnName}'] as List<${field.className}>;");
      } else {
        lines.add("map['${field.columnName}'] as ${field.type.dartType};");
      }
      lines.add('keys.remove("${field.columnName}");');

      if (field.constructType != .required) {
        lines.add('}');
      }
      lines.add('');
    }

    lines.add('if (keys.isNotEmpty) {');
    lines.add(' throw ArgumentError(\'Unkown map keys. \$keys\');');
    lines.add('}');
    lines.add('');

    lines.add('final item = $className(');
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
      if (field.type == .dtBackLink) {
        type = 'List<${field.className}>';
      }
      lines.add("item.${field.name} = params['${field.name}'] as $type;");
      lines.add('}');
    }

    lines.add('return item;');
    lines.add('}'); // end of function

    return lines;
  }

  List<String> _generateDataHandlers(String className, String appDbName) {
    final batch = '_\$${appDbName}BatchWrapper?';

    // register
    var lines = <String>[
      'Future<int> register($className item , {_\$${appDbName}Executor? db, $batch batch}) async {',
      '  assert((db != null) ^ (batch != null));',
      '',
      '  final map = item.toSqlMap();',
      "  var command = 'REPLACE INTO';",
      '  if (item.id == 0) {',
      "    command = 'INSERT INTO';",
      '  }',
      "final sql = '\$command \$tableName (\${map.keys.join(',')}) VALUES (\${List.filled(map.length, '?').join(', ')})';",
      "// print('register sql: \$sql');",
      "// print('args: \${map.values.toList()}');",
      '',
      'if (db != null) {',
      '  final id = await db.rawInsert(sql, map.values.toList());',
      '  item.id = id;',
      '  return id;',
      '} else if (batch != null) {',
      '  batch.rawInsert(sql, map.values.toList(), (noResult, object) async {',
      '    if (item.id == 0) {',
      '      if (noResult != true && object is int) {',
      '        item.id = object;',
      '      }',
      // '      if (noResult == true || object is! int) {',
      // "        throw StateError('returned object \$object is not int.');",
      // '      }',
      // '      item.id = object;',
      '    }',
      '    return object;',
      '  });'
          '}',
      'return -1;',
      '}',
      '',
    ];

    // convert reference
    //final referenes = _fieldMap.values.where(
    //  (field) => field.type == .dtReference,
    //);
    lines.addAll([
      'Future<List<Map<String, Object?>>> convertReferences(',
      'List<Map<String, Object?>> mapList, _\$${appDbName}Executor db,',
      ' List<String> dropKeys) async {',
      '  var result = mapList;',
      '  result = result.toList(); // convert to modifiable list',
      '  final batch = db.batch();',
      '',
      'for (var i = 0; i < result.length; i++) {',
      ' var map = result[i];',
      '  map = Map.from(map); // convert to modifiable map',
      '  result[i] = map;',
      '',
      '  final id = map[column.id] as int;',
      "  print('$className(\$id) \$dropKeys');"
          'for (final key in dropKeys) {',
      '  map.remove(key);',
      '}',

      //'  cachedMap[id] = map;'
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
          //'  final cachedValue = appdb.$varName.cachedMap[${field.name}Id];'
          //'  if (cachedValue != null) {',
          //"  map['${field.columnName}'] = $className.fromSqlMap(cachedValue);",
          //'  } else {',
          '  batch.get$className(${field.name}Id, onCommit: (noResult, object) async {',
          "    map['${field.columnName}'] = object;",
          '    return object;',
          '});',
          //'}',
          //"  map['${field.columnName}'] = await db.get$className(${field.name}Id);",
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
          'dropKeys: [appdb.$varName.column.${backLink.to}],'
              'onCommit: (noResult, object) async {',
          'if(noResult == true || object is! List<${field.className}>) {',
          "  throw StateError('returned object \$object is not expected type.');",
          '}',
          //'for (final otherMap in object) {',
          //' otherMap[\${appdb.$varName.column.${backLink.to}] = this;',
          //'}'
          "map['${field.columnName}'] = object;",
          '  return object;',
          '}',
          ');',
          '',
        ]);
      }
    }
    lines.addAll([
      '}', // end for
      'await batch.commit();',
      '',
      //'for (final map in result) {',
      //'  final id = map[column.id] as int;',
      //'  cachedMap[id] = map;'
      //'}'
      '',
      'return result;',
      '}', // end function
      ''
    ]);

    // mapToObject
    lines.addAll([
      'List<$className> mapToObject(List<Map<String, Object?>> mapList) {',
      ' final result = mapList.map((map) => $className.fromSqlMap(map)).toList();'
    ]);
    final backLinkFields = _fieldMap.values.where(
      (field) => field.type == .dtBackLink,
    );
    if (backLinkFields.isNotEmpty) {
      lines.add('for (final object in result){');
      for (final field in _fieldMap.values) {
        if (field.type == .dtBackLink) {
          final backLink = field.annotationObject as BackLink;
          lines.addAll([
            'for (final item in object.${field.name}) {',
            'item.${backLink.to} = object;',
            '}',
          ]);
        }
      }
      lines.add('}'); // end for
    }
    lines.addAll([
      'return result;'
      '}', // end func
      ''
    ]);
    // make query statement
    /*
    lines.addAll([
      'String querySql(String? where, String? orderBy, int? limit, int? offset) {',
      'final allColumnList = <String>[];',
      'allColumnList.addAll(',
      "  columnList.map((e) => '\$tableName.\$e',)",
      ');'
    ]);
    for (final field in referenes) {
      var className = field.className;
      if (className.endsWith('?')) {
        className = className.substring(0, className.length - 1);
      }
      final variableName = toLowerCamelCase(className);
      lines.addAll([
        'allColumnList.addAll(',
        ' appdb.${variableName}Helper.columnList.map(',
        "  (e) => ' \${appdb.${variableName}Helper.tableName}.'",
        '  )', // end of map
        ');' // end of addAll
      ]);
    }

    lines.addAll([
      "return allColumnList.join(', ');",
      '}',
    ]);
    */

    // query
    lines.addAll([
      'Future<List<$className>> query({String? where, List<Object?>? whereArgs, ',
      '  String? orderBy, int? limit, int? offset,',
      '  List<String> dropKeys = const [], ',
      '  _\$${appDbName}Executor? db, $batch batch}) async {',
      '  assert((db != null) ^ (batch != null));',
      '',
      'if (db != null) {',
      "  var queryResult = await db.query(tableName, where: where, whereArgs: whereArgs, ",
      '     orderBy: orderBy, limit: limit, offset: offset);',
      '  queryResult = await convertReferences(queryResult, db, dropKeys);',
      '',
      '  final result = mapToObject(queryResult);',
      '  return result;',
      '} else if (batch != null) {',
      '  batch.query(tableName, where: where, whereArgs: whereArgs,',
      '  orderBy: orderBy, limit: limit, offset: offset,',
      '  onCommit: (noResult, object) async {',
      '    if(noResult == true || object is! List<Map<String, Object?>>) {',
      "      throw StateError('returned object \$object is not expected type.');",
      '    }',
      '    final queryResult = await convertReferences(object, batch.executor, dropKeys);',
      '    final result = mapToObject(queryResult);'
      '    return result;',
      '  },',
      ');',
      '}',
      '  return [];',
      '}',
      '',
    ]);

    // get
    lines.addAll([
      'Future<$className?> get(int id, {',
      'List<String> dropKeys = const [], _\$${appDbName}Executor? db, $batch batch}) async {',
      '  assert((db != null) ^ (batch != null));',
      '',
      '  if (db != null) {',
      '    final result = await query(',
      "       where: '\${column.id} = ?',",
      '       whereArgs: [id],',
      '       dropKeys: dropKeys,'
          '       db: db);',
      '',
      '    if (result.isEmpty) {',
      '      return null;',
      '    }',
      '',
      '    assert(result.length == 1);',
      '    return result[0];',
      '} else if (batch != null) {',
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
      'return null;',
      '}',
      '',
    ]);

    // delete
    lines.addAll([
      'Future<int> delete($className item , {_\$${appDbName}Executor? db, $batch batch}) async {',
      '  assert((db != null) ^ (batch != null));',
      '  assert(item.id != 0);',
      '',
      ' if (db != null) {',
      "    final id = await db.delete(tableName, where: '\${column.id} = ?', whereArgs: [item.id]);",
      '    return id;'
          ' } else if (batch != null) {',
      "    batch.delete(tableName, where: '\${column.id} = ?', whereArgs: [item.id]);"
          ' }',
      ' return -1;'
          '}',
    ]);
    return lines;
  }

  Future<void> _analyzeFields(ClassElement element) async {
    _fieldMap.clear();
    _requiredPositional.clear();

    for (final field in element.fields) {
      if (field.isPrivate) {
        continue;
      }
      if (field.isStatic) {
        continue;
      }

      if (_annotatedWith(field, 'ignore')) {
        continue;
      }

      final name = field.displayName;

      final fieldInfo = _FieldInfo();
      fieldInfo.name = field.displayName;
      fieldInfo.columnName = toSnakeCase(fieldInfo.name);

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
          final msg = '${element.name} is not included in $appDbName';
          throw InvalidGenerationSourceError(msg);
        }
        type = _DataType.dtReference;
        fieldInfo.className = typeName;
        fieldInfo.columnName += '_id';
      } else if (_annotatedWith(field, 'BackLink')) {
        fieldInfo.annotationObject = annotationObject;
        if (!field.type.isDartCoreList) {
          final msg =
              '${element.name}: field ${field.name} is BackLink and it must be List';
          throw InvalidGenerationSourceError(msg);
        }
        if (field.type is! ParameterizedType) {
          final msg =
              '${element.name}: field ${field.name} is BackLink and it must be generic List';
          throw InvalidGenerationSourceError(msg);
        }
        final dartType = field.type as ParameterizedType;
        if (dartType.typeArguments.isEmpty) {
          final msg =
              '${element.name}: field ${field.name} is BackLink but cannot get List type';
          throw InvalidGenerationSourceError(msg);
        }
        if (!_annotatedWith(dartType.typeArguments[0].element, 'Table')) {
          final msg =
              '${element.name}: field ${field.name} is BackLink but it is not List of table class';
          throw InvalidGenerationSourceError(msg);
        }

        typeName = dartType.typeArguments[0].getDisplayString();
        if (!tableNameList.contains(typeName)) {
          final msg = '$typeName is not included in $appDbName';
          throw InvalidGenerationSourceError(msg);
        }
        type = _DataType.dtBackLink;
        fieldInfo.className = typeName;
      } else {
        final msg = "${element.name}: field ${field.name} is unsupported type";
        throw InvalidGenerationSourceError(msg);
      }
      fieldInfo.type = type;

      _fieldMap[name] = fieldInfo;
    }

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

  /// Converts a CamelCase string to snake_case.
  String toSnakeCase(String input) {
    final regex = RegExp(r'(?<=[a-z])[A-Z]');
    return input
        .replaceAllMapped(regex, (Match m) => '_${m.group(0)}')
        .toLowerCase();
  }

  Object? annotationObject;
  bool _annotatedWith(Element? field, String name) {
    bool found = false;

    if (field == null) {
      return false;
    }

    for (final annotation in field.metadata.annotations) {
      final annoElem = annotation.element;
      if (annoElem == null) {
        continue;
      }
      final library = annoElem.library;
      if (library == null) {
        continue;
      }
      if (annoElem.displayName.toLowerCase() == name.toLowerCase() &&
          library.identifier.startsWith('package:keg_annotation')) {
        found = true;
        annotationObject = null;
        if (annoElem.displayName == 'BackLink') {
          final dartObject = annotation.computeConstantValue();
          final to = dartObject?.getField('to')?.toStringValue();
          final order = dartObject?.getField('order')?.toStringValue();
          final desc = dartObject?.getField('descendant')?.toBoolValue();
          if (to != null && order != null && desc != null) {
            annotationObject = BackLink(to: to, order: order, descendant: desc);
          }
        }
        break;
      }
    }

    return found;
  }

  /// Convert class name to variable name
  String toLowerCamelCase(String input) {
    if (input.isEmpty) return input;
    return input[0].toLowerCase() + input.substring(1);
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
  dtBackLink(dartType: '');

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
  //bool isRequired = false;
  ConstructType constructType = .notIncluded;
  Object? annotationObject;
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
