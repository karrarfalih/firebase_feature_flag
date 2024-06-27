# Changelog

All notable changes to this project will be documented in this file.
## [1.0.14] - 2024-06-27

- **Feature**: Add `debug` flag to the `FeatureFlag` class to determine either print debug messages or not.

## [1.0.12] - 2024-04-25

- **Feature**: Add `isLive` flag to the `FeatureFlag` class to determine either keep the listening to the firebase database or get the value once each run.

## [1.0.9] - 2024-03-30

- **Bugfix**: Fix Map/List values.

## [1.0.8] - 2024-01-27

- **Bugfix**: Initialize Hive before store data.
  
## [1.0.5] - 2024-01-27

- Update `README.md` file

## [1.0.4] - 2024-01-27

- Add `listen` method to the `FeatureFlag` for value change listening.
- Make the `subject`, `key`, and `listener` private as there are no need for them. 

## [1.0.3] - 2024-01-27

- Remove `onLoading` widget in the `FeatureFlagBuilder` as the features are always have an initial value.

## [1.0.2] - 2024-01-26

- Dispose the Real Time Database stream subscription after disposing all the features.
- Update dependencies constraint
- Update `README.md` file

## [1.0.1] - 2024-01-25
- **Feature:** Introduced dynamic path support in `FeatureFlag` for custom feature flag paths.
  - Users can now specify custom paths when initializing a `FeatureFlag` instance.
  - The default path is set to 'features' if a custom path is not provided.
  
- **Enhancement:** One Remote Listerner for All Features.
  - each `FeatureFlag` instance are now listen to one stream subscription from the firebase realtime database and that stream will be disposed after all the features are being disposed (better performance).
  - 
- **Enhancement:** Refactored and improved instance management.
  - `FeatureFlag` instances are now managed in a way that ensure a single instance for each feature key.

- **Enhancement:** Improved log messages for better clarity.
  - Log messages have been enhanced to provide clearer information about feature flag settings.

- **Enhancement:** Add `useCache` property to `FeatureFlag` to determine either use or not to use the cache.
  
- **Enhancement:** Add `dispose` method to `FeatureFlag` to close stream subscription after the feature is disposed by the widget or manually.

- **Enhancement:** Add `dispose` property to `FeatureFlagBuilder` to determine either dispose or keep the feature after the widget is being disposed (false by default).

- **Enhancement:** Introduced a new class called `FeatureFlagData` to encapsulate feature flag data and its source information (remote or local).

- **Enhancement:** Improved logging for platform-specific settings in the `_add` method.

- **Bug Fix:** Fixed path handling issues and made it more flexible.

[Unreleased]: https://github.com/your/repository/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/your/repository/releases/tag/v2.0.0


## [1.0.0] - 2024-01-25
- Initial release of `firebase_feature_flag`.
- Added `FeatureFlag` class for managing feature flags.
- Introduced `FeatureFlagBuilder` for convenient UI updates based on feature flags.
- Provided example in the `example` directory.