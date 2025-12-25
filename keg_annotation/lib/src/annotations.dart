import 'package:meta/meta_meta.dart';

@Target({TargetKind.classType})
class Database {
  final List<Type> tables;
  final int schemaVersion;

  const Database({required this.tables, this.schemaVersion = 1});
}

@Target({TargetKind.classType})
class Table {
  final String tableName;

  const Table({this.tableName = ''});
}

@Target({TargetKind.field})
class Ignore {
  const Ignore();
}

