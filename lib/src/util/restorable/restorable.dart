import 'package:flutter/foundation.dart';
import 'package:icapps_architecture/src/util/restorable/bundle.dart';

/// Base class for restorable change view models
abstract class Restorable implements ChangeNotifier {
  /// Called when the system is restoring or creating a new instance. If the
  /// passed bundle is null, it is assumed to be a clean restoration without
  /// previous state
  void restoreState(Bundle? data);

  /// Called when the system needs to prepare data for later restoration. You
  /// should save all relevant required data to restore from later. Keep in mind
  /// that the system has only a limited amount of space reserved for this data:
  /// avoid storing large objects.
  void saveState(Bundle target);
}
