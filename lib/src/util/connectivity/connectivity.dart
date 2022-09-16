import 'package:connectivity_plus/connectivity_plus.dart';

/// Helper to determine if a device has connectivity
class ConnectivityHelper {
  final Connectivity Function()? _connectivityProvider;

  /// Constructor, optionally takes a [connectivityProvider] to override
  /// the default [Connectivity] instance
  ConnectivityHelper({Connectivity Function()? connectivityProvider})
      : _connectivityProvider = connectivityProvider;

  /// Returns true if the device is connected to an IP network
  Future<bool> hasConnection() async {
    return await getConnectivityResult() != ConnectivityResult.none;
  }

  /// Returns a stream that monitors the connectivity state of the device
  Stream<bool> monitorConnection() {
    return (_connectivityProvider?.call() ?? Connectivity())
        .onConnectivityChanged
        .map((event) => event != ConnectivityResult.none);
  }

  /// Returns the method used to connect e.g: Bluetooth, WiFi, Ethernet, Mobile or None
  Future<ConnectivityResult> getConnectivityResult() async {
    return await (_connectivityProvider?.call() ?? Connectivity())
        .checkConnectivity();
  }
}
