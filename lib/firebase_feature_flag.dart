library firebase_feature_flag;

import 'dart:developer';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/widgets.dart';

part 'builder.dart';
part 'log.dart';

class FeatureFlag<T> {
  // Static flag to control whether logs should be shown
  static bool showLogs = true;

  // Tag for identifying the feature flag (optional)
  final String? tag;

  // Path to the feature flag in the Firebase Realtime Database
  final String path;

  // Initial value for the feature flag, which is used before any updates are
  // received
  T? initialValue;

  // Default value for the feature flag, used when no configurations are found
  // or there's an error
  T? defaultValue;

  FeatureFlag({
    this.tag,
    required this.path,
    this.initialValue,
    this.defaultValue,
  }) : subject = initialValue != null || defaultValue != null
            ? BehaviorSubject<T>.seeded(defaultValue ?? initialValue!)
            : BehaviorSubject<T>() {
    // Initialize the feature flag
    init();
  }

  // BehaviorSubject for the feature flag values
  final BehaviorSubject<T> subject;

  // Getter for the current value of the feature flag
  T get value => subject.value;

  // Reference to the Firebase Realtime Database path
  DatabaseReference get _ref => FirebaseDatabase.instance.ref(path);

  // Hive box for local storage
  Box get box => Hive.box(path);

  // Initialization of the feature flag
  Future<void> init() async {
    // Open the Hive box for local storage
    await Hive.openBox(path);

    // Load feature flag value from local storage
    _loadFromCache();

    // Set feature flag to default value
    _setToDefault();

    // Listen for changes in the Firebase Realtime Database
    _ref.onValue.listen((event) {
      try {
        if (!event.snapshot.exists || event.snapshot.value == null) {
          // No configs found, set feature flag to default
          _Log.d('No configs found for ${tag ?? path}');
          _setToDefault();
          return;
        }
        // Parse the received data and update the feature flag
        final map = Map.from(event.snapshot.value! as Map);
        _add(map);
        _Log.d('Setting ${tag ?? path} to $map');
        // Save the updated value to local storage
        _saveToCache(map);
      } catch (e) {
        // Handle errors while getting app configs
        _Log.d('Error getting app configs: $e', isError: true);
        _setToDefault();
      }
    });
  }

  // Save feature flag value to local storage
  void _saveToCache(Map e) {
    box.put(path, e);
  }

  // Load feature flag value from local storage
  void _loadFromCache() {
    final data = box.get(path);
    if (data == null) {
      return;
    }
    _Log.d('Setting ${tag ?? path} from cache to $data');
    _add(data as Map);
  }

  // Update the feature flag value based on received data
  void _add(Map map) {
    dynamic val = map[path];
    if (val is Map && val.containsKey('android') && val.containsKey('ios')) {
      // Handle platform-specific configurations
      final platform = Platform.isAndroid ? 'android' : 'ios';
      val = val[platform];
    }
    if (val.runtimeType != T) {
      // Handle mismatched types, set feature flag to default
      _Log.d(
        'Can not update feature: value of ${tag ?? path} can not be ${val.runtimeType}. The required value is $T',
        isError: true,
      );
      _setToDefault();
      return;
    }
    if (val == subject.valueOrNull) {
      return;
    }
    // Update the feature flag value
    subject.add(val as T);
  }

  // Set feature flag to default value
  void _setToDefault() {
    if (defaultValue != null) {
      _Log.d('Setting ${tag ?? path} to default value: $defaultValue');
      subject.add(defaultValue as T);
    }
  }
}
