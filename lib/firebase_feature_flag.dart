library firebase_feature_flag;

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/widgets.dart';

part 'builder.dart';
part 'log.dart';
part 'listener.dart';

class FeatureFlag<T> {
  // Static flag to control whether logs should be shown
  static bool showLogs = true;

  static final Map<String, FeatureFlag> _instances = {};

  final String _key;

  // Path to the feature flag in the Firebase Realtime Database
  final String _path;

  // Whether to use the cached value or not
  final bool _useCache;

  FeatureFlag._({
    required String key,
    String? path,
    required T initialValue,
    required bool useCache,
  })  : _subject = BehaviorSubject<T>.seeded(initialValue!),
        _key = key,
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
  final BehaviorSubject<T> _subject;

  // Getter for the current value of the feature flag
  T get value => _subject.value;

  _FirebaseFeatureFlagListener get _listener =>
      _FirebaseFeatureFlagListener(_path, _subject);

  // Initialization of the feature flag
  void _init() {
    _listener.subject.listen((event) {
      try {
        if (!event.isRemote && !_useCache) {
          return;
        }
        final value = event.value[_key];
        _add(value);
        _Log.d('Setting $_key to $value');
      } catch (e) {
        _Log.d('Error setting faeture $_key: $e', isError: true);
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
      _Log.d('Platform-specific settings found for $_key: $platform');
    }
    if (val.runtimeType != T) {
      _Log.d(
        'Can not update feature: value of $_key can not be ${val.runtimeType}. The required value is $T. Did you miss the real time database configs? click on the link below to learn how to add configs to Firebase Realtime Database. https://pub.dev/packages/firebase_feature_flag#4-configure-the-real-time-database',
        isError: true,
      );
      return;
    }
    if (val == _subject.valueOrNull) {
      return;
    }
    _Log.d('Setting $_key to $val');
    _subject.add(val as T);
  }

  final List<StreamSubscription> _subscriptions = [];

  StreamSubscription<T> listen(void Function(T event) onData) {
    final subscription = _subject.listen(onData);
    _subscriptions.add(subscription);
    return subscription;
  }

  // Dispose the feature flag
  void dispose() {
    _subject.close();
    _listener.dispose(_subject);
    _subscriptions.forEach((element) {
      element.cancel();
    });
  }
}
