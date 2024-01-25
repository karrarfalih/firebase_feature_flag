part of 'firebase_feature_flag.dart';

// A custom widget that builds its UI based on the value of a FeatureFlag.
class FeatureFlagBuilder<T> extends StatelessWidget {
  // Function that takes a BuildContext and a generic value, and returns a Widget.
  final Widget Function(BuildContext context, T value) builder;

  // The FeatureFlag to observe.
  final FeatureFlag<T> feature;

  // Widget to display while the feature flag is loading.
  final Widget onLoading;

  // Constructor for FeatureFlagBuilder.
  const FeatureFlagBuilder({
    Key? key,
    required this.builder,
    required this.feature,
    required this.onLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      // Listen to the feature flag's stream.
      stream: feature.subject,
      // Provide the initial data from the subject, or null if not available.
      initialData: feature.subject.valueOrNull,
      builder: (context, snapshot) {
        // Check if the snapshot has data and the data is not null.
        if (snapshot.hasData && snapshot.data != null) {
          // Call the builder function with the context and the feature flag value.
          return builder(context, snapshot.data as T);
        }
        // Return the onLoading widget if data is still loading or not available.
        return onLoading;
      },
    );
  }
}
