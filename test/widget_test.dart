// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intro_screen/intro_screen.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final widget = IntroScreen(
      appLogo: Row(
        children: [
          const Text("Splash"),
          Image.asset(
            "assets/images/intro-1.jpg",
            width: 20,
            height: 20,
          )
        ],
      ),
      pageData: [
        IntroPageData(
          title: "World's First",
          description: "The world's first real estate app",
          image: Image.asset(
            "assets/images/intro-1.jpg",
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,
          ),
        ),
        IntroPageData(
          title: "Google Map support",
          description: "Full support to iraq map",
          image: Image.asset(
            "assets/images/intro-2.jpg",
            fit: BoxFit.cover,
            alignment: Alignment.centerRight,
          ),
        ),
      ],
    );

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: widget,
        ),
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text("World's First"), findsOneWidget);
    expect(find.text("Google Map support"), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byKey(Key("World's First")));
    await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
