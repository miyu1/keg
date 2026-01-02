import 'package:meta/meta_meta.dart';

@Target({TargetKind.classType})
class KegDatabase {
  final List<Type> tables;
  final int schemaVersion;

  const KegDatabase({required this.tables, this.schemaVersion = 1});
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

