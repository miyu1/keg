import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'package:keg_annotation/keg_annotation.dart';

enum DataType {
  dtUnknown(dartType: ''),
  dtInteger(dartType: 'int'),
  dtDouble(dartType: 'double'),
  dtString(dartType: 'String'),
  dtBool(dartType: 'bool'),
  dtDateTime(dartType: 'DateTime'),
  dtEnum(dartType: '');

  const DataType({required this.dartType});

  final String dartType;
}

enum ConstructType {
  required,     // required parameter of constructor
  optional,     // optional parameter of constructor
  notIncluded;  // not included in constructor 
}

class _FieldInfo {
  String name = '';
  String columnName = '';
  DataType type = .dtUnknown;
  String className = ''; // for enum class
  String defaultValue = '';
  //bool isRequired = false;
  ConstructType constructType = .notIncluded;
}

class TableGenerator extends GeneratorForAnnotation<Table> {

  final Map<String, _FieldInfo> _fieldMap = {};
  final List<String> _requiredPositional = [];
  final List<String> _optionalPositional = [];

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

    final className = element.displayName;
    final tableName = toSnakeCase(className);

    int schemaVersion = await _getSchemaVersion(className, buildStep);
    if (schemaVersion == 0) {
      log.warning('class $className is not included in any database.');
      return '// $className is not included in any database.';
    }

    await _analyzeFields(element);

    // helper fields
    if (!_fieldMap.containsKey('id')) {
      final msg = 'class $className must have an "id" field as primary key';
      throw InvalidGenerationSourceError(msg);
    }
    final idInfo = _fieldMap['id']!;
    if (idInfo.type != DataType.dtInteger) {
      final msg = 'field "id" in class $className must be of type int';
      throw InvalidGenerationSourceError(msg);
    }

    var columnRecord = '('; // record
    var columnList = '['; // list
    var columnTypes = '{'; // map

    for (final field in _fieldMap.values) {
      if (field.type == DataType.dtUnknown) {
        final msg =
            'field ${field.name} in class ${element.name} has undetermined type';
        throw InvalidGenerationSourceError(msg);
      }
      columnRecord += "${field.name}:'${field.columnName}', ";
      columnList += "'${field.columnName}', ";

      var dbTypeStr = switch (field.type) {
        DataType.dtInteger => 'INTEGER',
        DataType.dtDouble => 'REAL',
        DataType.dtString => 'TEXT',
        DataType.dtBool => 'INTEGER',
        DataType.dtDateTime => 'INTEGER',
        DataType.dtEnum => 'TEXT',
        _ => '',
      };
      if (dbTypeStr.isEmpty) {
        final msg =
            'field ${field.name} in class ${element.name} has unsupported type';
        throw InvalidGenerationSourceError(msg);
      }

      if (field.name == 'id') {
        dbTypeStr += ' PRIMARY KEY AUTOINCREMENT';
      } else {
        dbTypeStr += ' NOT NULL';
        dbTypeStr += switch (field.type) {
          DataType.dtInteger => ' DEFAULT 0',
          DataType.dtDouble => ' DEFAULT 0.0',
          DataType.dtString => ' DEFAULT ""',
          DataType.dtBool => ' DEFAULT 0',
          DataType.dtDateTime => ' DEFAULT 0',
          DataType.dtEnum => ' DEFAULT "\${${field.className}.values[0].name}"',
          _ => '',
        };

      }
      columnTypes += "'${field.columnName}':'$dbTypeStr', ";
    }
    columnRecord += ')';
    columnList += ']';
    columnTypes += '}';

    final lines = <String>[
      'class _\$${className}Helper {',
      '  final String tableName = \'$tableName\';',
      '  final column = $columnRecord;',
      '  final columnTypes = $columnTypes;',
      '  static final v${schemaVersion}ColumnList = $columnList;',
      '  final columnListByVersion = {1: v1ColumnList};',
      '', ];

    lines.addAll(_generateTableCreators(className));
    lines.addAll(_generateMapConverters(className));
    lines.addAll(_generateDataHandlers(className));

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
      ''
    ];

    return lines;
  }

  List<String> _generateMapConverters(
    String className,
  ) {
    var lines = <String>[];

    // Generate the toSqlMap method
    lines += [
      'static Map<String, Object?> toSqlMap($className item) {',
      '  final values = <String, Object?>{};',
    ];

    for (final field in _fieldMap.values) {
      var valueStr = 'item.${field.name}';
      if (field.type == DataType.dtBool) {
        valueStr = 'item.${field.name} ? 1 : 0';
      } else if (field.type == DataType.dtDateTime) {
        valueStr = 'item.${field.name}.toUtc().microsecondsSinceEpoch';
      } else if (field.type == DataType.dtEnum) {
        valueStr = 'item.${field.name}.name';
      }

      if (field.name == 'id') {
        lines.add('  if (item.id != 0) {');
        lines.add('    values["${field.columnName}"] = $valueStr;');
        lines.add('  }');
      } else {
        lines.add('    values["${field.columnName}"] = $valueStr;');
      }
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
    for (final field in _fieldMap.values.where((field) => field.constructType == .required)) {
      lines.add('if (!keys.contains("${field.columnName}")) {');
      lines.add('  throw ArgumentError("Missing required key ${field.columnName} in map");');
      lines.add('}');
    }
    lines.add('');

    for(final field in _fieldMap.values) {
      if(field.constructType == .required) {
        lines.add('final ${field.name} =');      
      } else if(field.constructType == .optional) {
        lines.add('var ${field.name} = ${field.defaultValue};');
        lines.add("if (keys.contains('${field.columnName}')) {");
        lines.add('${field.name} =');
      } else if(field.constructType == .notIncluded) {
        lines.add("if (keys.contains('${field.columnName}')) {");
        lines.add("params['${field.name}'] = ");
      }
      if (field.type == .dtUnknown) {
        throw InvalidGenerationSourceError('type of ${field.name} in $className is not valid');
      } else if (field.type == .dtBool) {
        lines.add("(map['${field.columnName}'] as int) == 0 ? false : true;");
      } else if (field.type == .dtDateTime) {
        lines.add("DateTime.fromMicrosecondsSinceEpoch(map['${field.columnName}'] as int).toLocal();");
      } else if (field.type == .dtEnum) {
        lines.add("${field.className}.values.byName(map['${field.columnName}'] as String);");
      } else {
        lines.add("map['${field.columnName}'] as ${field.type.dartType};");
      }
      lines.add('keys.remove("${field.columnName}");');

      if(field.constructType != .required) {
        lines.add('}');
      }
      lines.add('');
    }

    lines.add('if (keys.isNotEmpty) {');
    lines.add(' throw ArgumentError(\'Unkown map keys. \$keys\');');
    lines.add('}');
    lines.add('');

    lines.add('final item = $className(');
    for(final param in _requiredPositional) {
      lines.add('$param,');
    }
    for(final param in _optionalPositional) {
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

    for (final field in _fieldMap.values.where((field) => field.constructType == .notIncluded)) {
      lines.add("if (params.containsKey('${field.name}')) {");
      var type = field.type.dartType;
      if (field.type == .dtEnum) {
        type = field.className;
      }
      lines.add("item.${field.name} = params['${field.name}'] as $type;");
      lines.add('}');
    }

    lines.add('return item;');
    lines.add('}'); // end of function

    return lines;
  }

  List<String> _generateDataHandlers(
    String className,
  ) {
    var lines = <String>[
      'Future<int> register($className item , {DatabaseExecutor? db, Batch? batch}) async {',
      '  final map = item.toSqlMap();',
      "  var command = 'REPLACE INTO';",
      '  if (item.id == 0) {',
      "    command = 'INSERT INTO';",
      '  }',
      "final sql = '\$command \$tableName (\${map.keys.join(',')}) VALUES (\${List.filled(map.length, '?').join(', ')})';",
      "print('register sql: \$sql');",
      "print('args: \${map.values.toList()}');",
      'var id = 0;',
      'if (db != null) {',
      '  id = await db.rawInsert(sql, map.values.toList());',
      '  item.id = id;',
      '} else if (batch != null) {',
      '  batch.rawInsert(sql, map.values.toList());',
      '}',
      'return id;',
      '}',
      '',
      'Future<List<$className>> query({String? where, List<Object?>? whereArgs, ',
      '  String? orderBy, int? limit, int? offset,',
      '  DatabaseExecutor? db, Batch? batch}) async {',
      'if (db != null) {',
      "  final result = await db.query(tableName, where: where, whereArgs: whereArgs, ",
      '     orderBy: orderBy, limit: limit, offset: offset);',
      '  return result.map((entry) => $className.fromSqlMap(entry)).toList();'
      '}',
      '  return [];'  
      '}',
      '',
      'Future<int> delete($className item , {DatabaseExecutor? db, Batch? batch}) async {',
      ' if (db != null) {',
      "    final id = await db.delete(tableName, where: '\${column.id} = ?', whereArgs: [item.id]);",
      '    return id;'
      ' }',
      ' return -1;'
      '}',

    ];
    return lines;
  }

  Future<void> _analyzeFields(
    ClassElement element,
  ) async {
    _fieldMap.clear();
    _requiredPositional.clear();

    for (final field in element.fields) {
      if (field.isPrivate) {
        continue;
      }
      if (field.isStatic) {
        //fieldInfo.isStatic = true;
        continue;
      }

      final name = field.displayName;

      final fieldInfo = _FieldInfo();
      fieldInfo.name = field.displayName;
      fieldInfo.columnName = toSnakeCase(fieldInfo.name);

      var type = DataType.dtUnknown;
      final typeName = field.type.getDisplayString();
      if (field.type.isDartCoreInt) {
        type = DataType.dtInteger;
      } else if (field.type.isDartCoreDouble) {
        type = DataType.dtDouble;
      } else if (field.type.isDartCoreString) {
        type = DataType.dtString;
      } else if (field.type.isDartCoreBool) {
        type = DataType.dtBool;
      } else if (field.type.element?.library?.displayName == 'dart.core' && typeName == 'DateTime') {
        type = DataType.dtDateTime;
      } else if (field.type.element is EnumElement) {
        type = DataType.dtEnum;
        fieldInfo.className = typeName;
      } else {
        final msg =
            'field ${field.name} in class ${element.name} is unsupported type';
        throw InvalidGenerationSourceError(msg);
      }
      fieldInfo.type = type;

      _fieldMap[name] = fieldInfo;
    }

    final constructor = element.unnamedConstructor;
    if (constructor == null || constructor.isPrivate) {
      final msg = 'class ${element.displayName} must have an unnamed constructor';
      throw InvalidGenerationSourceError(msg);
    }

    final paramList = constructor.formalParameters;
    final positionalParams = paramList
        .where((param) => param.isPositional)
        .toList();
    for (final param in positionalParams) {
      if(!_fieldMap.containsKey(param.name)) {
        throw InvalidGenerationSourceError( 
          'No matching field for constructor parameter ${param.name} in class ${element.displayName}');
      }
      if (param.isRequired) {
        _fieldMap[param.name]!.constructType = .required;
        _requiredPositional.add(param.displayName);
      } else {
        _fieldMap[param.name]!.constructType = .optional;
        _optionalPositional.add(param.displayName);
      }
    }


    final namedParams = paramList
        .where((param) => param.isNamed)
        .toList();
    for (final param in namedParams) {
      if(!_fieldMap.containsKey(param.displayName) && param.isRequired) {
        throw InvalidGenerationSourceError( 
          'No matching field for constructor parameter ${param.name} in class ${element.displayName}');
      }
      if (param.isRequired) {
        _fieldMap[param.name]!.constructType = .required;
      } else {
        _fieldMap[param.name]!.constructType = .optional;
      }
    }

    final optionalParams = paramList.where((param) => param.isOptional);

    for(final param in optionalParams) {
      if(!_fieldMap.containsKey(param.displayName)) {
        continue;
      }
      if (!param.hasDefaultValue || param.defaultValueCode == null) {
        throw InvalidGenerationSourceError( 
          'constructor parameter ${param.name} of class ${element.displayName} '
          'is optional but not have default value.');
      }
      final defaultValue = param.defaultValueCode!;
      _fieldMap[param.displayName]!.defaultValue = defaultValue;
    }
  }

  /// get schemaVersion from KegDb annotation
  Future<int> _getSchemaVersion(String className, BuildStep buildStep) async {
    // find KegDb annotation
    final library = await buildStep.inputLibrary;
    final libraryReader = LibraryReader(library);
    final checker = TypeChecker.typeNamed(KegDatabase);
    final annotatedElements = libraryReader.annotatedWith(checker);

    int version = 0;
    for(final annotatedElement in annotatedElements){
      final appDbElement = annotatedElement.element;
      if (appDbElement is! ClassElement) {
        // could be error but ignores this time 
        continue;
      }
      final dartObject = annotatedElement.annotation.objectValue;
      final tableNameList = dartObject.getField('tables')?.toListValue()
        ?.map((e) => e.toTypeValue()?.getDisplayString(),);
      if (tableNameList == null) {
        continue;
      }
      if (!tableNameList.contains(className)) {
        continue;
      }
      final tmpVersion = dartObject.getField('schemaVersion')?.toIntValue();
      if (tmpVersion == null) {
        continue;
      }
      if (version != 0 && version != tmpVersion) {
        final msg = 'class $className is included in multiple database and different schema version';
        throw InvalidGenerationSourceError(msg);
      }
      version = tmpVersion;
    }

    return version;
  }

  /// Converts a CamelCase string to snake_case.
  String toSnakeCase(String input) {
    final regex = RegExp(r'(?<=[a-z])[A-Z]');
    return input
        .replaceAllMapped(regex, (Match m) => '_${m.group(0)}')
        .toLowerCase();
  }
}
