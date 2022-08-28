import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../test_util.dart';
import 'preferences_storage_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences sharedPreferences;
  late SharedPreferenceStorage sut;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    sut = SharedPreferenceStorage(SynchronousFuture(sharedPreferences));

    when(sharedPreferences.setString(any, any))
        .thenAnswer((_) => Future.value(true));
    when(sharedPreferences.setDouble(any, any))
        .thenAnswer((_) => Future.value(true));
    when(sharedPreferences.setBool(any, any))
        .thenAnswer((_) => Future.value(true));
    when(sharedPreferences.setStringList(any, any))
        .thenAnswer((_) => Future.value(true));
    when(sharedPreferences.setInt(any, any))
        .thenAnswer((_) => Future.value(true));
    when(sharedPreferences.getString(any)).thenReturn(null);
    when(sharedPreferences.getDouble(any)).thenReturn(null);
    when(sharedPreferences.getBool(any)).thenReturn(null);
    when(sharedPreferences.getStringList(any)).thenReturn(null);
    when(sharedPreferences.getInt(any)).thenReturn(null);
    when(sharedPreferences.remove(any)).thenAnswer((_) => Future.value(true));
    when(sharedPreferences.containsKey(any)).thenReturn(false);
  });

  group('String', () {
    test('SharedPrefsStorage should write string', () {
      sut.saveString(key: 'Key', value: 'Value');
      verify(sharedPreferences.setString('Key', 'Value')).calledOnce();
      verifyNoMoreInteractions(sharedPreferences);
    });
    test('SharedPrefsStorage should write string with setValue', () {
      sut.setValue(key: 'Key', value: 'Value');
      verify(sharedPreferences.setString('Key', 'Value')).calledOnce();
      verifyNoMoreInteractions(sharedPreferences);
    });
    test('SharedPrefsStorage should read string', () {
      sut.getString('Key');
      verify(sharedPreferences.getString('Key')).calledOnce();
      verifyNoMoreInteractions(sharedPreferences);
    });
    test('SharedPrefsStorage should read string with getValue', () {
      sut.getValue(key: 'Key');
      verify(sharedPreferences.getString('Key')).calledOnce();
      verifyNoMoreInteractions(sharedPreferences);
    });
  });

  group('bool', () {
    test('SharedPrefsStorage should write bool', () {
      sut.saveBoolean(key: 'Key', value: true);
      verify(sharedPreferences.setBool('Key', true)).calledOnce();
      verifyNoMoreInteractions(sharedPreferences);
    });
    test('SharedPrefsStorage should write bool false', () {
      sut.saveBoolean(key: 'Key', value: false);
      verify(sharedPreferences.setBool('Key', false)).calledOnce();
      verifyNoMoreInteractions(sharedPreferences);
    });

    test('SharedPrefsStorage should read bool', () async {
      when(sharedPreferences.getBool('Key')).thenAnswer((_) => true);
      final result = await sut.getBoolean('Key');
      expect(result, true);
      verify(sharedPreferences.getBool('Key')).calledOnce();
      verifyNoMoreInteractions(sharedPreferences);
    });
  });

  group('double', () {
    test('SharedPrefsStorage should write double', () {
      sut.saveDouble(key: 'Key', value: 1.2145);
      verify(sharedPreferences.setDouble('Key', 1.2145)).calledOnce();
      verifyNoMoreInteractions(sharedPreferences);
    });

    test('SharedPrefsStorage should read double', () async {
      when(sharedPreferences.getDouble('Key')).thenAnswer((_) => 1.23435);
      final result = await sut.getDouble('Key');
      expect(result, 1.23435);
      verify(sharedPreferences.getDouble('Key')).calledOnce();
      verifyNoMoreInteractions(sharedPreferences);
    });
  });

  group('int', () {
    test('SharedPrefsStorage should write int', () {
      sut.saveInt(key: 'Key', value: 123425);
      verify(sharedPreferences.setInt('Key', 123425)).calledOnce();
      verifyNoMoreInteractions(sharedPreferences);
    });

    test('SharedPrefsStorage should read double', () async {
      when(sharedPreferences.getInt('Key')).thenAnswer((_) => 21345);
      final result = await sut.getInt('Key');
      expect(result, 21345);
      verify(sharedPreferences.getInt('Key')).calledOnce();
      verifyNoMoreInteractions(sharedPreferences);
    });
  });

  test('SharedPrefsStorage should delete', () {
    sut.deleteKey('KEY');
    verify(sharedPreferences.remove('KEY')).calledOnce();
    verifyNoMoreInteractions(sharedPreferences);
  });

  test('SharedPrefsStorage should removeValue', () {
    sut.removeValue(key: 'KEY');
    verify(sharedPreferences.remove('KEY')).calledOnce();
    verifyNoMoreInteractions(sharedPreferences);
  });

  test('SharedPrefsStorage containsKey', () {
    sut.containsKey('KEY');
    verify(sharedPreferences.containsKey('KEY')).calledOnce();
    verifyNoMoreInteractions(sharedPreferences);
  });

  test('SharedPrefsStorage hasValue', () {
    sut.hasValue(key: 'KEY');
    verify(sharedPreferences.containsKey('KEY')).calledOnce();
    verifyNoMoreInteractions(sharedPreferences);
  });
}
