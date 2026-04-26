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
@Target({TargetKind.field, TargetKind.getter, TargetKind.setter})
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

/// Annotation for many to many relation field of table class.
/// Example:
/// @table
/// class Order {
///   int id;
//    String user;
///
///   @ManyToMany(middle: OrderToItem, self: 'order', target: 'item',
///     order: 'name', descendant: true)
///   List&lt;Item&gt; itemList = [];
///
///   Order(this.user, {this.id = 0});
///
///   Map&lt;String, Object?&gt; toSqlMap() => _$OrderHelper.toSqlMap(this);
///   factory Order.fromSqlMap(Map&lt;String, Object?&gt; map) =>
///       _$OrderHelper.fromSqlMap(map);
/// }
///
/// @table
/// class Item {
///   int id;
///   String name;
///
///   @BackLink(to: 'itemList')
///   List&lt;Order&gt; orderList = [];
///
///   Item(this.name, {this.id = 0});
/// 
///   Map&lt;String, Object?&gt; toSqlMap() => _$ItemHelper.toSqlMap(this);
///   factory Item.fromSqlMap(Map&lt;String, Object?&gt; map) =>
///       _$ItemHelper.fromSqlMap(map);
/// }
///
// @table
/// class OrderToItem {
///   int id;
///   Order? order;
///   Item? item;
///   String field;
///
//   OrderToItem({required this.order, required this.item, required this.field, this.id = 0});
///
///   Map&lt;String, Object?&gt; toSqlMap() => _$OrderToItemHelper.toSqlMap(this);
///   factory OrderToItem.fromSqlMap(Map&lt;String, Object?&gt; map) =>
///       _$OrderToItemHelper.fromSqlMap(map);
/// }
///
@Target({TargetKind.field})
class ManyToMany {
  /// class of middle table
  final Type middle;
  /// field name used to hold id of self class
  final String self;
  /// field name used to hold field name in self class which holds the many to many relation
  /// this field is important when self class has multiple many to many relations with target class
  final String field; 
  /// field name used to hold id of target class
  final String target;
  /// Field name used to order list. 
  final String order;
  /// If true, descendant order, else ascendant
  final bool descendant;

  const ManyToMany({
    required this.middle,
    required this.self,
    required this.target,
    this.field = 'field',
    this.order = "id",
    this.descendant = false,});
}

/// Annotation for index field of table class.
@Target({TargetKind.field})
class Index {
  /// Whether the index is unique or not. Default is false.
  final bool unique;
  /// If true, descendant order, else ascendant
  final bool descendant;

  const Index({this.unique = false, this.descendant = false});
}

