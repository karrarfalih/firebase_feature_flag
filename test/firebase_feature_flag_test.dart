import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

import 'package:firebase_feature_flag/firebase_feature_flag.dart';

// Mock FeatureFlag to simulate its behavior
class MockFeatureFlag<T> extends Mock implements FeatureFlag<T> {}

void main() {
  testWidgets('FeatureFlagBuilder displays correct UI based on flag value',
      (WidgetTester tester) async {
    // Create a mock FeatureFlag with boolean type
    final MockFeatureFlag<bool> mockFeatureFlag = MockFeatureFlag<bool>();
    
    // Mock the behavior of the FeatureFlag
    when(mockFeatureFlag.subject).thenAnswer((_) => BehaviorSubject<bool>());

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: FeatureFlagBuilder<bool>(
          // Pass the mock FeatureFlag instance
          feature: mockFeatureFlag,
          // Provide a builder function with the context and feature flag value
          builder: (context, isEnabled) {
            return isEnabled
                ? Text('Enabled')
                : Text('Disabled');
          },
          // Loading widget to display while the feature flag is loading
          onLoading: CircularProgressIndicator(),
        ),
      ),
    );

    // Initially, the loading indicator should be displayed
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Enabled'), findsNothing);
    expect(find.text('Disabled'), findsNothing);

    // Simulate the feature flag emitting a value
    mockFeatureFlag.subject.add(true);
    
    // Rebuild the widget.
    await tester.pump();

    // After the flag is loaded, the correct UI based on the flag value should be displayed
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Enabled'), findsOneWidget);
    expect(find.text('Disabled'), findsNothing);

    // Simulate the feature flag emitting a different value
    mockFeatureFlag.subject.add(false);

    // Rebuild the widget.
    await tester.pump();

    // Now, the correct UI based on the updated flag value should be displayed
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Enabled'), findsNothing);
    expect(find.text('Disabled'), findsOneWidget);
  });
}
