import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';

void main() {
  group('Bundle tests', () {
    test('Test create empty bundle', () {
      final bundle = Bundle();
      expect(bundle.asFlatStructure().isEmpty, true);
    });
    test('Test serialize simple bundle', () {
      final bundle = Bundle();
      bundle.putInt('int', 1);
      bundle.putDouble('double', 21.0);
      bundle.putBoolean('boolean', true);
      bundle.putString('string', 'test');
      bundle.putStringList('stringList', ['test1', 'test2']);

      final serialized = bundle.asFlatStructure();
      expect(serialized.isNotEmpty, true);

      expect(serialized['int'], 1);
      expect(serialized['double'], 21.0);
      expect(serialized['boolean'], true);
      expect(serialized['string'], 'test');
      expect(serialized['stringList'], ['test1', 'test2']);
    });
    test('Test serialize complex bundle', () {
      final bundle = Bundle();
      final innerBundle = Bundle();
      innerBundle.putInt('int', 1);
      innerBundle.putDouble('double', 21.0);
      innerBundle.putBoolean('boolean', true);
      innerBundle.putString('string', 'test');
      innerBundle.putStringList('stringList', ['test1', 'test2']);
      bundle.putBundle('bundle', innerBundle);

      final serialized = bundle.asFlatStructure();
      expect(serialized.isNotEmpty, true);

      expect(serialized['bundle'], <Object?, Object?>{
        'int': 1,
        'double': 21.0,
        'boolean': true,
        'string': 'test',
        'stringList': ['test1', 'test2'],
      });
    });
    test('Test put null removes', () {
      final bundle = Bundle();
      bundle.putInt('int', 1);
      bundle.putDouble('double', 21.0);
      bundle.putBoolean('boolean', true);
      bundle.putString('string', 'test');
      bundle.putStringList('stringList', ['test1', 'test2']);
      bundle.putBundle('bundle', Bundle());

      expect(bundle.asFlatStructure().isNotEmpty, true);

      bundle.putInt('int', null);
      bundle.putDouble('double', null);
      bundle.putBoolean('boolean', null);
      bundle.putString('string', null);
      bundle.putStringList('stringList', null);
      bundle.putBundle('bundle', null);

      expect(bundle.asFlatStructure().isEmpty, true);
    });
    test('Test removes', () {
      final bundle = Bundle();
      bundle.putInt('int', 1);
      bundle.putDouble('double', 21.0);
      bundle.putBoolean('boolean', true);
      bundle.putString('string', 'test');
      bundle.putStringList('stringList', ['test1', 'test2']);
      bundle.putBundle('bundle', Bundle());

      expect(bundle.asFlatStructure().isNotEmpty, true);

      bundle.remove('int');
      bundle.remove('double');
      bundle.remove('boolean');
      bundle.remove('string');
      bundle.remove('stringList');
      bundle.remove('bundle');

      expect(bundle.asFlatStructure().isEmpty, true);
    });
    test('Test get', () {
      final bundle = Bundle();
      bundle.putInt('int', 1);
      bundle.putDouble('double', 21.0);
      bundle.putBoolean('boolean', true);
      bundle.putString('string', 'test');
      bundle.putStringList('stringList', ['test1', 'test2']);
      bundle.putBundle('bundle', Bundle()..putInt('int', 2));

      expect(bundle.getInt('int'), 1);
      expect(bundle.getDouble('double'), 21.0);
      expect(bundle.getBoolean('boolean'), true);
      expect(bundle.getString('string'), 'test');
      expect(bundle.getStringList('stringList'), ['test1', 'test2']);
      expect(bundle.getBundle('bundle').getInt('int'), 2);

      expect(() => bundle.getBundle('not a bundle'),
          throwsA(isA<FormatException>()));
    });
    test('Test hasKey', () {
      final bundle = Bundle();
      bundle.putInt('int', 1);
      bundle.putDouble('double', 21.0);
      bundle.putBoolean('boolean', true);
      bundle.putString('string', 'test');
      bundle.putStringList('stringList', ['test1', 'test2']);
      bundle.putBundle('bundle', Bundle()..putInt('int', 2));

      expect(bundle.hasKey('int'), true);
      expect(bundle.hasKey('double'), true);
      expect(bundle.hasKey('boolean'), true);
      expect(bundle.hasKey('string'), true);
      expect(bundle.hasKey('stringList'), true);
      expect(bundle.hasKey('bundle'), true);
    });
    test('Test opt get', () {
      final bundle = Bundle();
      bundle.putInt('int', 1);
      bundle.putDouble('double', 21.0);
      bundle.putBoolean('boolean', true);
      bundle.putString('string', 'test');
      bundle.putStringList('stringList', ['test1', 'test2']);
      bundle.putBundle('bundle', Bundle()..putInt('int', 2));

      expect(bundle.optInt('int'), 1);
      expect(bundle.optDouble('double'), 21.0);
      expect(bundle.optBoolean('boolean'), true);
      expect(bundle.optString('string'), 'test');
      expect(bundle.optStringList('stringList'), ['test1', 'test2']);
      expect(bundle.optBundle('bundle')?.optInt('int'), 2);

      expect(bundle.optDouble('int'), null);
      expect(bundle.optInt('double'), null);
      expect(bundle.optStringList('boolean'), null);
      expect(bundle.optBoolean('string'), null);
      expect(bundle.optBundle('stringList'), null);
      expect(bundle.optBundle('bundle')?.optDouble('int'), null);
    });
    test('Test create from map simple', () {
      final bundle = Bundle.from(<Object?, Object?>{
        'int': 1,
        'double': 21.0,
        'boolean': true,
        'string': 'test',
        'stringList': ['test1', 'test2'],
      });

      expect(bundle.getInt('int'), 1);
      expect(bundle.getDouble('double'), 21.0);
      expect(bundle.getBoolean('boolean'), true);
      expect(bundle.getString('string'), 'test');
      expect(bundle.getStringList('stringList'), ['test1', 'test2']);
    });
    test('Test create from map complex', () {
      final bundle = Bundle.from(<Object?, Object?>{
        'int': 1,
        'double': 21.0,
        'boolean': true,
        'string': 'test',
        'stringList': ['test1', 'test2'],
        'bundle': <Object?, Object?>{'inner': false},
      });

      expect(bundle.getInt('int'), 1);
      expect(bundle.getDouble('double'), 21.0);
      expect(bundle.getBoolean('boolean'), true);
      expect(bundle.getString('string'), 'test');
      expect(bundle.getStringList('stringList'), ['test1', 'test2']);
      expect(bundle.getBundle('bundle').getBoolean('inner'), false);
      expect(bundle.optBundle('bundle')?.getBoolean('inner'), false);
    });
  });
}
