# Changelog

## [0.7.0] - 2022-05-12
- Flutter 3.0 & Dart 2.17 are now supported
### Updated
- Dependencies

## [0.6.4] - 2022-02-22
### Fixed

- iOS Touchfeedback when 2 TouchFeedbackIOS widgets are on top of eachother

## [0.6.3] - 2022-01-26
### Added

- Custom shadow for TouchFeedback

## [0.6.2] - 2022-01-14
### Added

- Docs in the README.md

## [0.6.1] - 2021-12-14
### Added

- Ensure console log output is split into 800 long chunks to prevent lost data. (Fixes #63)

### Fixed

- Place message from error logger before stack trace information. (Fixes #69)

## [0.6.0] - 2021-12-02
### Added

- `ComputePool`: A pool of background isolates to dispatch work to. Falls back to microtasks on web

## [0.5.1] - 2021-11-16
### Added

- Is null or empty extension on `String?`

## [0.5.0] - 2021-11-12
### Added

- Adds more options to the TouchFeedback widget to control the material layer
- Adds a helper framework to save and restore state using the standard restoration framework
- Update libraries
- Required dart 2.14

## [0.4.3] - 2021-09-29

### Added

- Add .value constructor for BaseProviderWidget

## [0.4.2] - 2021-09-02

### Fixed

- Expose the SimpleKeyValueStorage interface

## [0.4.1] - 2021-09-02

### Added

- SimpleKeyValueStorage storage added as a generic interface for storing/retrieving strings
- SharedPreferenceStorage updated to implement SimpleKeyValueStorage

## [0.4.0] - 2021-09-02

### Fixed

- Upgrade to latest version of libraries

## [0.3.6] - 2021-07-07

### Fixed

- Allow different return types for `sortBy2`

## [0.3.5] - 2021-05-27

### Fixed

- null child when onClick is null (Android)

## [0.3.4] - 2021-05-27

### Fixed

- Exclude Inkwel from widget three if onClick is null
- Exclude gesture detector from semantics three if onClick is null

## [0.3.3] - 2021-05-25

### Fixed

- Throw from a simple interceptor

## [0.3.2] - 2021-05-19

### Fixed

- Made `BaseProviderWidget` and `BaseThemeProviderWidget` non-abstract to take advantage of dart 2.13's typedef

## [0.3.1] - 2021-04-23

### Fixed

- Fixed issue with release not containing all code

## [0.3.0] - 2021-04-23

### BREAKING

- `logger` is now an extension property on `Object` and will include `[$ClassName] ` as prefix to log messages
- `staticLogger` static getter has replaced `logger` to use in top level functions where we do not have an object to extend from

## [0.2.3] - 2021-04-20

### Added

- replaceWhere
- forEachIndexed

## [0.2.2] - 2021-04-20

### Added

- Disable logger colors on all except android devices

## [0.2.1] - 2021-04-12

### Added

- Extension function on null
- Shared preferences

## [0.2.0] - 2021-04-08

### Added

- Localized error added to get a localization key.
- Connectivity stream to check if the user is connected to wifi or mobile services.  [#35](https://github.com/icapps/flutter-icapps-architecture/issues/35)

### Breaking

- Network error implements now Localized error [#33](https://github.com/icapps/flutter-icapps-architecture/issues/33)

## [0.1.2] - 2021-04-06

### Updated

- Updated dependencies to support desktop too
- Added logging methods to log request and responses
- Added Iterable<Iterable<T>>.flatten extension

## [0.1.1] - 2021-04-02

### Updated

- Updated dependencies to remove test dependency from non-test code

## [0.1.0] - 2021-04-02

### Added

- Initial release
