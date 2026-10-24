// Widget tests for the sign-up form.
//
// The form was cut down to five fields and the country is now derived from the
// phone number's dial code rather than picked separately. These tests pin that
// down: the removed fields must stay gone, and the dial code must follow what
// the user types.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_auto_drive/ui/auth/signup_screen.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';

void main() {
  // SignupScreen's view model resolves its services through the locator, and
  // those services resolve others in turn, so register the real graph. Every
  // registration is lazy and nothing in these tests makes a network call.
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await locatorSetup();
  });

  tearDownAll(() => serviceLocator.reset());

  // The shared spacing and text widgets read from SizeConfig, which main.dart
  // seeds from MediaQuery. Do the same here or every XMargin/YMargin throws.
  Future<void> pumpSignup(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            final size = MediaQuery.of(context).size;
            SizeConfig.init(context,
                width: size.width, height: size.height, allowFontScaling: true);
            return const SignupScreen();
          },
        ),
      ),
    );
    await tester.pump();
  }

  group('sign-up form', () {
    testWidgets('asks for five fields and nothing more', (tester) async {
      await pumpSignup(tester);

      expect(find.text('First name'), findsOneWidget);
      expect(find.text('Last name'), findsOneWidget);
      expect(find.text('Phone number'), findsOneWidget);
      expect(find.text('Email address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      expect(find.byType(TextFormField), findsNWidgets(5));
    });

    testWidgets('no longer asks for country, state or a referral code',
        (tester) async {
      await pumpSignup(tester);

      expect(find.text('Country'), findsNothing);
      expect(find.text('State'), findsNothing);
      expect(find.text('Referral code'), findsNothing);
    });

    testWidgets('no longer offers the business sign-up block', (tester) async {
      await pumpSignup(tester);

      expect(find.text('Register as'), findsNothing);
      expect(find.text('Business name'), findsNothing);
      expect(find.text('Business contact'), findsNothing);
      expect(find.text('Business email'), findsNothing);
      expect(find.text('Business type'), findsNothing);
    });
  });

  group('phone number field', () {
    testWidgets('defaults to the Nigerian dial code', (tester) async {
      await pumpSignup(tester);

      expect(find.text('+234'), findsOneWidget);
    });

    testWidgets('switches country when an international number is pasted',
        (tester) async {
      await pumpSignup(tester);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Phone number'), '+233501234567');
      await tester.pump();

      // Picker follows the pasted code...
      expect(find.text('+233'), findsOneWidget);
      expect(find.text('+234'), findsNothing);
      // ...and the code is stripped out of the field itself, not duplicated.
      expect(find.text('501234567'), findsOneWidget);
    });

    testWidgets('leaves a local number and its dial code alone',
        (tester) async {
      await pumpSignup(tester);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Phone number'), '08031234567');
      await tester.pump();

      expect(find.text('+234'), findsOneWidget);
      expect(find.text('08031234567'), findsOneWidget);
    });

    testWidgets('rejects a number that is too short for the chosen country',
        (tester) async {
      await pumpSignup(tester);

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Phone number'), '803123');
      await tester.tap(find.text('Sign up'));
      await tester.pump();

      expect(find.text('A Nigeria number has 10 digits'), findsOneWidget);
    });
  });
}
