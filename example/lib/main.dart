import 'package:firebase_feature_flag/firebase_feature_flag.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Feature Flag Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Flag Builder Example'),
      ),
      body: Center(
        child: FeatureFlagBuilder<bool>(
          feature: FeatureFlag<bool>(
            key: 'my_feature_flag',
            initialValue: true,
            useCache: true,
          ),
          builder: (context, isEnabled) {
            return isEnabled
                ? const Text('Custom Widget is Enabled!')
                : const Text('Custom Widget is Disabled.');
          },
          onLoading: const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
