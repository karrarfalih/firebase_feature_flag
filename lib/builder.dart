part of 'firebase_feature_flag.dart';

// A custom widget that builds its UI based on the value of a FeatureFlag.
class FeatureFlagBuilder<T> extends StatefulWidget {
  // Function that takes a BuildContext and a generic value, and returns a Widget.
  final Widget Function(BuildContext context, T value) builder;

  // The FeatureFlag to observe.
  final FeatureFlag<T> feature;

  // Whether to dispose the feature flag when the widget is disposed.
  final bool dispose;

  // Constructor for FeatureFlagBuilder.
  const FeatureFlagBuilder({
    Key? key,
    required this.builder,
    required this.feature,
    this.dispose = false,
  }) : super(key: key);

  @override
  State<FeatureFlagBuilder<T>> createState() => _FeatureFlagBuilderState<T>();
}

class _FeatureFlagBuilderState<T> extends State<FeatureFlagBuilder<T>> {
  @override
  void dispose() {
    if (widget.dispose) widget.feature.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: widget.feature._subject,
      initialData: widget.feature._subject.valueOrNull,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return widget.builder(context, snapshot.data as T);
        }
        return SizedBox();
      },
    );
  }
}
