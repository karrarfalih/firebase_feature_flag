part of 'firebase_feature_flag.dart';

class _FirebaseFeatureFlagListener {
  final String path;

  _FirebaseFeatureFlagListener._(this.path) {
    _loadFromCache();
    try {
      FirebaseDatabase.instance.ref(path).onValue.listen((event) {
        try {
          if (!event.snapshot.exists || event.snapshot.value == null) {
            // No configs found, set feature flag to default
            _Log.d(
              'No configs found for $path. All features will be set to default value. Did you forget to add the configs to Firebase Realtime Database? click on the link below to learn how to add configs to Firebase Realtime Database. https://pub.dev/packages/firebase_feature_flag#4-configure-the-real-time-database',
              isError: true,
            );
            return;
          }
          // Parse the received data and update the feature flag
          final map = Map<String, dynamic>.from(event.snapshot.value! as Map);
          _Log.d('Settings for path $path received.');
          // Save the updated value to local storage
          subject.add(FeatureFlagData(map, true));
          _saveToCache(map);
        } catch (e) {
          // Handle errors while getting app configs
          _Log.d('Error getting app configs: $e', isError: true);
        }
      });
    } catch (e) {
      // Handle errors while getting app configs
      _Log.d('Error getting app configs: $e', isError: true);
    }
  }

  static final Map<String, _FirebaseFeatureFlagListener> _instances = {};

  final Set<BehaviorSubject> _subjects = {};

  factory _FirebaseFeatureFlagListener(String path, BehaviorSubject subject) {
    if (!_instances.containsKey(path)) {
      _instances[path] = _FirebaseFeatureFlagListener._(path);
    }
    return _instances[path]!.._subjects.add(subject);
  }

  final subject = BehaviorSubject<FeatureFlagData>();

  // Save feature flag value to local storage
  void _saveToCache(Map e) {
    try {
      Hive.box('features').put(path, e);
    } catch (e) {
      _Log.d('Error saving feature flag to cache: $e', isError: true);
    }
  }

  // Load feature flag value from local storage
  void _loadFromCache() {
    try {
      final data = Hive.box('features').get(path);
      if (data == null) {
        return;
      }
      _Log.d('Setting for path $path loaded from cache.');
      subject.add(FeatureFlagData(data, false));
    } catch (e) {
      _Log.d('Error loading feature flag from cache: $e', isError: true);
    }
  }

  // Dispose the feature listener
  dispose(BehaviorSubject subject) {
    _subjects.remove(subject);
    if (_subjects.isEmpty) {
      _instances.remove(path);
      subject.close();
    }
  }
}

class FeatureFlagData {
  final Map<String, dynamic> value;
  final bool isRemote;

  FeatureFlagData(this.value, this.isRemote);
}
