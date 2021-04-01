import 'dart:io';

bool get runInTest => Platform.environment.containsKey('FLUTTER_TEST');
