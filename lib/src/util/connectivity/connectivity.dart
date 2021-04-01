import 'package:connectivity/connectivity.dart';

/// Helper to determine if a device has connectivity
class ConnectivityHelper {
  final Connectivity Function()? _connectivityProvider;

  /// Constructor, optionally takes a [connectivityProvider] to override
  /// the default [Connectivity] instance
  ConnectivityHelper({Connectivity Function()? connectivityProvider})
      : _connectivityProvider = connectivityProvider;

  /// Returns true if the device is connected to an IP network
  Future<bool> hasConnection() async {
    return await (_connectivityProvider?.call() ?? Connectivity())
            .checkConnectivity() !=
        ConnectivityResult.none;
  }
}
