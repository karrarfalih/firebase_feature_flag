part of 'firebase_feature_flag.dart';

class _FirebaseFeatureFlagListener {
  final String path;

  final bool isLive;

  final bool debug;

  StreamSubscription? _subscription;

  _FirebaseFeatureFlagListener._(this.path, this.isLive, this.debug) {
    _init();
  }

  static final Map<String, _FirebaseFeatureFlagListener> _instances = {};

  final Set<BehaviorSubject> _subjects = {};

  factory _FirebaseFeatureFlagListener(
      String path, BehaviorSubject subject, bool isLive, bool debug) {
    if (!_instances.containsKey(path)) {
      _instances[path] = _FirebaseFeatureFlagListener._(path, isLive, debug);
    }
    return _instances[path]!.._subjects.add(subject);
  }

  final subject = BehaviorSubject<FeatureFlagData>();

  _init() async {
    await _loadFromCache();
    if (!isLive) {
      _fetchData();
      return;
    }
    _startListening();
  }

  Future<void> refresh() async {
    await _fetchData();
  }

  _fetchData() async {
    try {
      await FirebaseDatabase.instance.ref(path).get().then((snapshot) {
        try {
          if (!snapshot.exists || snapshot.value == null) {
            // No configs found, set feature flag to default
            _Log.d(
              'No configs found for $path. All features will be set to default value. Did you forget to add the configs to Firebase Realtime Database? click on the link below to learn how to add configs to Firebase Realtime Database. https://pub.dev/packages/firebase_feature_flag#4-configure-the-real-time-database',
              isError: true,
            );
            return;
          }
          // Parse the received data and update the feature flag
          final map = Map<String, dynamic>.from(snapshot.value! as Map);
          if (debug) _Log.d('Settings for path $path received.');
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

  _startListening() {
    try {
      _subscription ??=
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
          if (debug) _Log.d('Settings for path $path received.');
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

  // Save feature flag value to local storage
  Future<void> _saveToCache(Map e) async {
    await Hive.openBox('features');
    try {
      Hive.box('features').put(path, e);
    } catch (e) {
      _Log.d('Error saving feature flag to cache: $e', isError: true);
    }
  }

  // Load feature flag value from local storage
  Future<void> _loadFromCache() async {
    await Hive.initFlutter();
    await Hive.openBox(path);
    try {
      final data = Hive.box('features').get(path);
      if (data == null) {
        return;
      }
      if (debug) _Log.d('Setting for path $path loaded from cache.');
      subject.add(FeatureFlagData(Map<String, dynamic>.from(data), false));
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
      _subscription?.cancel();
    }
  }
}

class FeatureFlagData {
  final Map<String, dynamic> value;
  final bool isRemote;

  FeatureFlagData(this.value, this.isRemote);
}
