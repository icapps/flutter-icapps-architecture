import 'package:flutter/widgets.dart';

/// Widget that builds different UIs based on device characteristics
///
/// Speciality builder functions exist for building on tablets regardless of
/// orientation ([tabletBuilder]), tablet in landscape mode ([tabletLandscapeBuilder]),
/// landscape mode ([landscapeBuilder]) or regular ([builder]). Note that if a
/// specific builder is not provided, the system will fall back to the next
/// specified builder. Order: [tabletLandscapeBuilder] => [tabletBuilder] =>
/// [landscapeBuilder] => [builder]
class ResponsiveWidget extends StatelessWidget {
  final Function(BuildContext context, SizeInformation sizeInformation)?
      tabletBuilder;
  final Function(BuildContext context, SizeInformation sizeInformation)?
      landscapeBuilder;
  final Function(BuildContext context, SizeInformation sizeInformation)?
      tabletLandscapeBuilder;
  final Widget Function(BuildContext context, SizeInformation sizeInformation)?
      builder;

  const ResponsiveWidget({
    this.tabletBuilder,
    this.landscapeBuilder,
    this.tabletLandscapeBuilder,
    this.builder,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return LayoutBuilder(builder: (context, boxSizing) {
      final info = SizeInformation(
        orientation: mediaQuery.orientation,
        deviceType: getDeviceType(mediaQuery),
        screenSize: mediaQuery.size,
        localWidgetSize: Size(boxSizing.maxWidth, boxSizing.maxHeight),
      );
      final tabletLandscapeB = tabletLandscapeBuilder;
      final tabletB = tabletBuilder;
      final landscapeB = landscapeBuilder;
      final portraitBuilder = builder;
      if (info.orientation == Orientation.landscape &&
          info.deviceType == DeviceScreenType.Tablet &&
          tabletLandscapeB != null) {
        return tabletLandscapeB(context, info);
      } else if (info.deviceType == DeviceScreenType.Tablet &&
          tabletB != null) {
        return tabletB(context, info);
      } else if (info.orientation == Orientation.landscape &&
          landscapeB != null) {
        return landscapeB(context, info);
      } else if (portraitBuilder != null) {
        return portraitBuilder(context, info);
      }
      throw Exception('Failed to build Responsive Widget');
    });
  }

  /// Returns the device screen type based on the [mediaQuery].
  ///
  /// Devices are assumed to be tablets if their width (in portrait) or height
  /// (in landscape) is greater than a predefined number (600)
  static DeviceScreenType getDeviceType(MediaQueryData mediaQuery) {
    final orientation = mediaQuery.orientation;
    var deviceWidth = 0.0;
    if (orientation == Orientation.landscape) {
      deviceWidth = mediaQuery.size.height;
    } else {
      deviceWidth = mediaQuery.size.width;
    }
    if (deviceWidth > 600) {
      return DeviceScreenType.Tablet;
    }
    return DeviceScreenType.Mobile;
  }
}

/// The type of device screen
enum DeviceScreenType {
  /// A mobile form factor. This can also include TVs, desktop, web, ... if the
  /// size indicates phone form factor. See [ResponsiveWidget.getDeviceType]
  Mobile,

  /// A tablet form factor. This can also include TVs, desktop, web, ... if the
  /// size indicates tablet form factor. See [ResponsiveWidget.getDeviceType]
  Tablet,
}

/// Device/screen information holder
class SizeInformation {
  /// The orientation of the device
  final Orientation orientation;

  /// The device screen type
  final DeviceScreenType deviceType;

  /// The size of the screen
  final Size screenSize;

  /// The local max size of the widget that resolved this information
  final Size localWidgetSize;

  SizeInformation({
    required this.orientation,
    required this.deviceType,
    required this.screenSize,
    required this.localWidgetSize,
  });
}
