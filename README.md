# firebase_feature_flag

A Flutter package for managing feature flags using Firebase Realtime Database.

# Table of Contents

- [firebase\_feature\_flag](#firebase_feature_flag)
- [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Installation](#installation)
  - [Usage](#usage)
    - [1. Import the package](#1-import-the-package)
    - [2. Initialize a FeatureFlag instance](#2-initialize-a-featureflag-instance)
    - [3. Use FeatureFlagBuilder to conditionally display UI](#3-use-featureflagbuilder-to-conditionally-display-ui)
  - [Example](#example)
  - [Contributing](#contributing)

## Overview

`firebase_feature_flag` provides a convenient way to integrate feature flags into your Flutter app, allowing you to toggle features on and off remotely without requiring a new release. It utilizes Firebase Realtime Database to store and synchronize feature flag configurations.

## Installation

Add `firebase_feature_flag` to your `pubspec.yaml` file:

```yaml
dependencies:
  firebase_feature_flag: ^1.0.0
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
  path: 'feature_flags/my_feature',
  initialValue: true,
  defaultValue: false,
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
  onLoading: CircularProgressIndicator(),
),
```

## Example
Check the provided example in the example directory for a sample implementation.

## Contributing
Feel free to open issues and pull requests. Contributions are welcome!
