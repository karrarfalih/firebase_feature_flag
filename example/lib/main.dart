import 'package:firebase_feature_flag/firebase_feature_flag.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feature Flag Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  // Initialize FeatureFlag with a boolean type
  final FeatureFlag<bool> myFeatureFlag = FeatureFlag<bool>(
    path: 'feature_flags/show_custom_widget',
    initialValue: true,
    defaultValue: false,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Flag Builder Example'),
      ),
      body: Center(
        child: FeatureFlagBuilder<bool>(
          // Pass the FeatureFlag instance
          feature: myFeatureFlag,
          // Provide a builder function with the context and feature flag value
          builder: (context, isEnabled) {
            return isEnabled
                ? const Text('Custom Widget is Enabled!')
                : const Text('Custom Widget is Disabled.');
          },
          // Loading widget to display while the feature flag is loading
          onLoading: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}


