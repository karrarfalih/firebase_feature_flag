# firebase_feature_flag

A Flutter package for managing feature flags using Firebase Realtime Database.

# Table of Contents

- [firebase\_feature\_flag](#firebase_feature_flag)
- [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Key Features](#key-features)
    - [Realtime Synchronous](#realtime-synchronous)
    - [Cache](#cache)
    - [Performance](#performance)
    - [Efficient Instance Management](#efficient-instance-management)
    - [Flexible Configuration Options](#flexible-configuration-options)
    - [Widget Lifecycle Control](#widget-lifecycle-control)
  - [Installation](#installation)
  - [Usage](#usage)
    - [1. Initialize a FeatureFlag instance](#1-initialize-a-featureflag-instance)
    - [2. Use FeatureFlagBuilder to conditionally display UI](#2-use-featureflagbuilder-to-conditionally-display-ui)
    - [3. Get the current value from anywhere](#3-get-the-current-value-from-anywhere)
    - [4. Configure the Real Time Database](#4-configure-the-real-time-database)
    - [5. Disable log](#5-disable-log)
  - [Example](#example)
  - [Contributing](#contributing)

## Overview

`firebase_feature_flag` provides a convenient way to integrate feature flags into your Flutter app, allowing you to toggle features on and off remotely without requiring a new release. It utilizes Firebase Realtime Database to store and synchronize feature flag configurations in realtime.

## Key Features

### Realtime Synchronous

- **Realtime Synchronous:** Enjoy real-time synchronization of feature flag changes across your Flutter app.
  - Changes in the Firebase Realtime Database are reflected synchronously, providing immediate updates to feature flags.

### Cache

- **Cache:** Enhance performance and reduce latency by utilizing the cache for storing feature flag configurations.
  - Cached configurations provide quick access to feature flags, especially in scenarios with limited or no internet connectivity.

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


## Installation

Add `firebase_feature_flag` to your `pubspec.yaml` file:

```yaml
dependencies:
  firebase_feature_flag: ^1.0.15
```

Run flutter pub get to install the package.

## Usage

### 1. Initialize a FeatureFlag instance
```dart
import 'package:firebase_feature_flag/firebase_feature_flag.dart';

final FeatureFlag<bool> myFeatureFlag = FeatureFlag<bool>(
  key: 'my_feature',
  initialValue: true,
);
```

### 2. Use FeatureFlagBuilder to conditionally display UI
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

### 3. Get the current value from anywhere
```dart

// Get the feature value
final bool isMyfeatureEnabled = myFeatureFlag.value;
if(isMyfeatureEnabled){
  // Do somthing
}else{
  // Do something
}

// Or listen to the feature value
// The stream subscription will automatically canceled after disposing the feature.
myFeatureFlag.listen((value){
  print(value);
});
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

- "bool_feature" has a boolean value.
- "bool_feature_platform_specific" has a platform-specific boolean value.
- "int_feature" has an int value.
- "string_feature" has a string value.

### 5. Disable log
The log is only enabled in the debug mode but you can disbale it by setting the `FeatureFlag.showLogs` to false.
```dart
FeatureFlag.showLogs = false;
```

## Example
Check the provided example in the example directory for a sample implementation.

## Contributing
Feel free to open issues and pull requests. Contributions are welcome!
