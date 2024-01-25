part of 'firebase_feature_flag.dart';

class _Log {
  static void d(String message, {bool isError = false}) {
    if (isError || (FeatureFlag.showLogs && !kReleaseMode)) {
      log(
        message,
        name: 'FeatureFlag',
      );
    }
  }
}
