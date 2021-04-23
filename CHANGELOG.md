# Changelog
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
