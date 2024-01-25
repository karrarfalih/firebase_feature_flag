# firebase_feature_flag

A Flutter package for managing feature flags using Firebase Realtime Database.

# Table of Contents

- [firebase\_feature\_flag](#firebase_feature_flag)
- [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Key Features](#key-features)
    - [Dynamic Path Customization](#dynamic-path-customization)
    - [Performance](#performance)
    - [Efficient Instance Management](#efficient-instance-management)
    - [Flexible Configuration Options](#flexible-configuration-options)
    - [Widget Lifecycle Control](#widget-lifecycle-control)
    - [Data Encapsulation](#data-encapsulation)
  - [Installation](#installation)
  - [Usage](#usage)
    - [1. Import the package](#1-import-the-package)
    - [2. Initialize a FeatureFlag instance](#2-initialize-a-featureflag-instance)
    - [3. Use FeatureFlagBuilder to conditionally display UI](#3-use-featureflagbuilder-to-conditionally-display-ui)
    - [4. Configure the Real Time Database](#4-configure-the-real-time-database)
    - [5. Disable log](#5-disable-log)
  - [Example](#example)
  - [Contributing](#contributing)

## Overview

`firebase_feature_flag` provides a convenient way to integrate feature flags into your Flutter app, allowing you to toggle features on and off remotely without requiring a new release. It utilizes Firebase Realtime Database to store and synchronize feature flag configurations.

## Key Features

### Dynamic Path Customization

- **Dynamic Path Support:** Customize feature flag paths dynamically with the introduction of dynamic path support in `FeatureFlag`.
  - Specify custom paths when initializing a `FeatureFlag` instance.
  - Default path is set to 'features' if a custom path is not provided.

### Performance

- **Enhanced Performance:** Experience optimized performance with a unified remote listener for all features.
  - All `FeatureFlag` instances efficiently listen to a single stream subscription from the Firebase Realtime Database.
  - Stream subscriptions are automatically disposed of after all features are released, ensuring optimal performance.

### Efficient Instance Management

- **Instance Management:** Improved instance management ensures a streamlined experience.
  - `FeatureFlag` instances are thoughtfully managed to guarantee a single instance for each feature key.

### Flexible Configuration Options

- **Configuration Flexibility:** Tailor feature flag behavior with new configuration options.
  - Utilize the `useCache` property in `FeatureFlag` to decide whether to use the cache.
  - Leverage the `dispose` method in `FeatureFlag` for efficient stream subscription closure.

### Widget Lifecycle Control

- **Widget Management:** Gain control over widget lifecycles with added properties in `FeatureFlagBuilder`.
  - Use the `dispose` property to determine whether to dispose or keep the feature after the widget is disposed (default is false).

### Data Encapsulation

- **Data Encapsulation:** Improved encapsulation with the introduction of `FeatureFlagData` class.
  - Encapsulate feature flag data and its source information (remote or local).

## Installation

Add `firebase_feature_flag` to your `pubspec.yaml` file:

```yaml
dependencies:
  firebase_feature_flag: ^1.0.3
```

Run flutter pub get to install the package.

## Usage

### 1. Import the package
```dart
import 'package:firebase_feature_flag/firebase_feature_flag.dart';
```

### 2. Initialize a FeatureFlag instance
```dart
final FeatureFlag<bool> myFeatureFlag = FeatureFlag<bool>(
  key: 'my_feature',
  initialValue: true,
);
```

### 3. Use FeatureFlagBuilder to conditionally display UI
```dart
FeatureFlagBuilder<bool>(
  feature: myFeatureFlag,
  builder: (context, isEnabled) {
    return isEnabled
        ? CustomWidget(message: 'Custom Widget is Enabled!')
        : Text('Custom Widget is Disabled.');
  },
),
```

### 4. Configure the Real Time Database
Below is an example of how you can structure your Firebase Realtime Database to incorporate feature flags. 
```json
{
  // `feature` is the default path, you can change it when define the FeatureFlag
  "features": {
    "bool_feature": false,
    "bool_feature_platform_specific": {
      "android": true,
      "ios": false
    },
    "int_feature": 34,
    "string_feature": "active",
    // Add more feature flags as needed
  }
}
```
In this example:

"bool_feature" has a boolean value.
"bool_feature_platform_specific" has a platform-specific boolean value.
"int_feature" has an int value.
"string_feature" has a string value.

### 5. Disable log
The log is only enabled in the debug mode but you can disbale it by setting the `FeatureFlag.showLogs` to false.
```dart
FeatureFlag.showLogs = false;
```

## Example
Check the provided example in the example directory for a sample implementation.

## Contributing
Feel free to open issues and pull requests. Contributions are welcome!
