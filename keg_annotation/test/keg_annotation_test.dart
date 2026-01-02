import 'package:keg_annotation/keg_annotation.dart';
import 'package:test/test.dart';

void main() {
  group('annotation tests', () {
    test('initialize class with @Table annotation', () {
      final c = Class1();
      expect(c, isA<Class1>());
    });
    test('initialize class with @ignore annotation', () {
      final c = Class2();
      expect(c, isA<Class2>());
    });
    test('initialize class with @Database annotation', () {
      final c = Class3();
      expect(c, isA<Class3>());
    });
  });
}

@Table()
class Class1 {
}

@Table(tableName: 'custom_name')
class Class2 {
  @ignore
  String name = 'example';
}

@KegDatabase(tables: [Class1, Class2])
class Class3 {
}