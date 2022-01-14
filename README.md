# Flutter icapps architecture
Architecture components used in icapps flutter projects

[![Build Status](https://travis-ci.com/icapps/flutter-icapps-architecture.svg?branch=main)](https://travis-ci.com/icapps/flutter-icapps-architecture)
[![Coverage Status](https://coveralls.io/repos/github/icapps/flutter-icapps-architecture/badge.svg)](https://coveralls.io/github/icapps/flutter-icapps-architecture)
[![pub package](https://img.shields.io/pub/v/icapps-architecture.svg)](https://pub.dartlang.org/packages/icapps-architecture)

### Custom Error handling
#### Localized error
This error can be used to map a localization key/localization to an Exception. So when the exception is thrown you don't have to do an extra mapping to get the correct text.

#### Network Error
A NetworkError is used simplify the DioErrors. A NetworkError is also a LocalizedError so it is easy to get the correct localization/localizationKey

### Extensions
#### Context
- `isAndroidTheme`
- `isIOSTheme`
- `isTablet` (This will query the `MediaQueryData.isTablet`)
- `isLandscape` (This will query the `MediaQueryData.isLandscap`)

#### MediaQueryData
- `isTablet` (Will use the ResponsiveWidget.getDeviceType to check if your current screen is tablet)
- `isLandscap` (Check if your current orientation is landscape)