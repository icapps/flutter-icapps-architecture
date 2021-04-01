import 'package:connectivity/connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:icapps_architecture/icapps_architecture.dart';
import 'package:mockito/mockito.dart';
import 'connectivity_test.mocks.dart';

@GenerateMocks([Connectivity])
void main() {
  late MockConnectivity connectivity;

  setUp(() {
    connectivity = MockConnectivity();
  });

  group('Connectivity tests', () {
    test('Test connectivity mobile', () async {
      when(connectivity.checkConnectivity())
          .thenAnswer((_) => Future.value(ConnectivityResult.mobile));
      expect(
          await ConnectivityHelper(connectivityProvider: () => connectivity)
              .hasConnection(),
          true);
    });
    test('Test connectivity wifi', () async {
      when(connectivity.checkConnectivity())
          .thenAnswer((_) => Future.value(ConnectivityResult.wifi));
      expect(
          await ConnectivityHelper(connectivityProvider: () => connectivity)
              .hasConnection(),
          true);
    });
    test('Test connectivity none', () async {
      when(connectivity.checkConnectivity())
          .thenAnswer((_) => Future.value(ConnectivityResult.none));
      expect(
          await ConnectivityHelper(connectivityProvider: () => connectivity)
              .hasConnection(),
          false);
    });
  });
}
