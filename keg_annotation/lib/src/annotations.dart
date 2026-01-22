import 'package:meta/meta_meta.dart';

/// Annotation for database class
@Target({TargetKind.classType})
class KegDatabase {
  /// List of Table classes
  final List<Type> tables;

  /// Version of schema.
  /// starts with 1, if upgrade table specs, increment the number
  final int schemaVersion;

  const KegDatabase({required this.tables, this.schemaVersion = 1});
}

/// Annotation for table class
@Target({TargetKind.classType})
class Table {
  // final String tableName;

  // const Table({this.tableName = ''});
  const Table();
}

/// Annotation for ignore field of table class.
/// If field is annotated,  field is not included in table schema.
@Target({TargetKind.field})
class Ignore {
  const Ignore();
}

/// Annotation for back link field of table class.
/// Example:
///   @table
///   class Category {
///     @BackLink(to: 'category')
///     List&lt;Item&gt; itemList 
///   }
///   @table
///   class Item {
///     Category? category;
///   }
@Target({TargetKind.field})
class BackLink{
  /// Field name of linked class
  final String to;
  /// Field name used to order list. 
  final String order;
  /// If true, descendant order, else ascendant
  final bool descendant;

  const BackLink({required this.to, this.order = "id", this.descendant = false});
}

