library firebase_feature_flag;

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/widgets.dart';

part 'builder.dart';
part 'log.dart';
part 'listener.dart';

class FeatureFlag<T> {
  // Static flag to control whether logs should be shown
  static bool showLogs = true;

  static final Map<String, FeatureFlag> _instances = {};

  final String key;

  // Path to the feature flag in the Firebase Realtime Database
  final String _path;

  // Whether to use the cached value or not
  final bool _useCache;


  FeatureFlag._({
    required String key,
    String? path,
    required T initialValue,
    required bool useCache,
  })  : subject = BehaviorSubject<T>.seeded(initialValue!),
        key = key,
        _path = path ?? 'features',
        _useCache = useCache;

  // Get the instance of the feature flag
  factory FeatureFlag({
    required String key,
    String? path,
    required T initialValue,
    bool useCache = true,
  }) {
    if (!_instances.containsKey(key)) {
      _instances[key] = FeatureFlag<T>._(
        key: key,
        path: path,
        initialValue: initialValue,
        useCache: useCache,
      ).._init();
    }
    return _instances[key] as FeatureFlag<T>;
  }

  // BehaviorSubject for the feature flag values
  final BehaviorSubject<T> subject;

  // Getter for the current value of the feature flag
  T get value => subject.value;
  _FirebaseFeatureFlagListener get listener =>
      _FirebaseFeatureFlagListener(_path, subject);

  // Initialization of the feature flag
  Future<void> _init() async {
    await Hive.openBox(_path);
    listener.subject.listen((event) {
      try {
        if(!event.isRemote && !_useCache) {
          return;
        }
        final value = event.value[key];
        _add(value);
        _Log.d('Setting $key to $value');
      } catch (e) {
        _Log.d('Error setting faeture $key: $e', isError: true);
      }
    });
  }

  // Update the feature flag value based on received data
  void _add(Map map) {
    dynamic val = map[_path];
    if (val is Map && val.containsKey('android') && val.containsKey('ios')) {
      // Handle platform-specific configurations
      final platform = Platform.isAndroid ? 'android' : 'ios';
      val = val[platform];
      _Log.d('Platform-specific settings found for $key: $platform');
    }
    if (val.runtimeType != T) {
      _Log.d(
        'Can not update feature: value of $key can not be ${val.runtimeType}. The required value is $T. Did you miss the real time database configs? click on the link below to learn how to add configs to Firebase Realtime Database. https://pub.dev/packages/firebase_feature_flag#4-configure-the-real-time-database',
        isError: true,
      );
      return;
    }
    if (val == subject.valueOrNull) {
      return;
    }
    _Log.d('Setting $key to $val');
    subject.add(val as T);
  }

  // Dispose the feature flag
  void dispose() {
    subject.close();
    listener.dispose(subject);
  }
}
