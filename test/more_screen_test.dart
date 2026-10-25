import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_auto_drive/models/user_model.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/more/more_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/edit_profile.dart';
import 'package:mobile_auto_drive/utils/env_config.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/button.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    EvnConfig.init(envType: 'Development');
    if (!serviceLocator.isRegistered<UserService>()) await locatorSetup();
    SharedPreferences.setMockInitialValues({});
    await PersistenceService.getInstance();
  });

  /// Puts a signed-in user from [country] in place. The More page reads its
  /// whole country behaviour off this one field.
  void signInFrom(String country, {String? state, String? phone}) {
    serviceLocator<UserService>().userModel = UserModel(
      statusCode: 200,
      payload: Payload(
        user: User(
          userId: 'u1',
          firstname: 'Ada',
          lastname: 'Nwosu',
          email: 'ada@test.dev',
          country: country,
          state: state,
          phonenumber: phone,
        ),
      ),
    );
  }

  Future<void> pumpMore(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            final size = MediaQuery.of(context).size;
            SizeConfig.init(context,
                width: size.width, height: size.height, allowFontScaling: true);
            return const MoreScreen();
          },
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  group('country strip', () {
    testWidgets('names the market and the currency it bills in',
        (tester) async {
      signInFrom('Nigeria', state: 'Lagos');
      await pumpMore(tester);

      expect(find.text('Lagos, Nigeria'), findsWidgets);
      expect(find.text('NGN'), findsOneWidget);
    });

    testWidgets('falls back to the country alone when no state is set',
        (tester) async {
      signInFrom('Kenya');
      await pumpMore(tester);

      expect(find.text('Kenya'), findsWidgets);
      expect(find.text('KES'), findsOneWidget);
    });

    testWidgets('an Austrian account is billed in euro', (tester) async {
      signInFrom('Austria', state: 'Vienna');
      await pumpMore(tester);

      expect(find.text('Vienna, Austria'), findsWidgets);
      expect(find.text('EUR'), findsOneWidget);
      expect(find.text('NGN'), findsNothing);
    });
  });

  group('country-gated features', () {
    testWidgets('Nigeria is offered car insurance', (tester) async {
      signInFrom('Nigeria');
      await pumpMore(tester);

      expect(find.text('Car Insurance'), findsOneWidget);
    });

    testWidgets('markets without providers are not shown insurance',
        (tester) async {
      for (final country in ['Austria', 'Ghana', 'Kenya', 'United States']) {
        signInFrom(country);
        await pumpMore(tester);

        expect(find.text('Car Insurance'), findsNothing, reason: country);
      }
    });
  });

  group('profile access', () {
    testWidgets('offers a profile row showing where the user is',
        (tester) async {
      signInFrom('Ghana', state: 'Accra');
      await pumpMore(tester);

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Accra, Ghana'), findsWidgets);
    });

    testWidgets('the billing row states the currency, not a generic blurb',
        (tester) async {
      signInFrom('Ghana');
      await pumpMore(tester);

      expect(find.text('Payment & Subscription'), findsOneWidget);
      expect(find.text('Billed in GHS'), findsOneWidget);
    });
  });

  group('editing your profile', () {
    Future<void> pumpEditProfile(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final size = MediaQuery.of(context).size;
              SizeConfig.init(context,
                  width: size.width, height: size.height, allowFontScaling: true);
              return const EditProfileScreen();
            },
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('there is no country field to edit', (tester) async {
      signInFrom('Nigeria', state: 'Lagos', phone: '+2348031234567');
      await pumpEditProfile(tester);

      // Country is derived from the dial code now, never picked.
      expect(find.text('Country'), findsNothing);
      expect(find.text('Nigeria  (NGN)'), findsNothing);
    });

    testWidgets('the stored number is split into dial code and local number',
        (tester) async {
      signInFrom('Ghana', state: 'Accra', phone: '+233241234567');
      await pumpEditProfile(tester);

      expect(find.text('+233'), findsOneWidget);
      expect(find.text('241234567'), findsWidgets);
      // The full E.164 string is never shown raw.
      expect(find.text('+233241234567'), findsNothing);
    });

    testWidgets('the hint says which country and currency the number implies',
        (tester) async {
      signInFrom('Ghana', state: 'Accra', phone: '+233241234567');
      await pumpEditProfile(tester);

      expect(
        find.textContaining('Ghana \u00b7 billed in GHS'),
        findsOneWidget,
      );
    });

    testWidgets('changing the dial code moves the country and the currency',
        (tester) async {
      signInFrom('Nigeria', state: 'Lagos', phone: '+2348031234567');
      await pumpEditProfile(tester);

      expect(find.textContaining('Nigeria \u00b7 billed in NGN'), findsOneWidget);

      await tester.tap(find.text('+234'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Austria (+43)').last);
      await tester.pumpAndSettle();

      expect(find.textContaining('Austria \u00b7 billed in EUR'), findsOneWidget);
      expect(find.textContaining('Nigeria'), findsNothing);
    });

    testWidgets('only the launch countries are offered as dial codes',
        (tester) async {
      signInFrom('Nigeria', phone: '+2348031234567');
      await pumpEditProfile(tester);

      await tester.tap(find.text('+234'));
      await tester.pumpAndSettle();

      expect(find.text('Austria (+43)'), findsOneWidget);
      expect(find.text('Kenya (+254)'), findsOneWidget);
      expect(find.textContaining('Canada'), findsNothing);
    });

    testWidgets('address can be typed or picked on the map', (tester) async {
      signInFrom('Nigeria', state: 'Lagos', phone: '+2348031234567');
      await pumpEditProfile(tester);

      expect(find.text('Current address'), findsOneWidget);
      expect(find.text('State'), findsOneWidget);
      // The pin is the affordance that says the map is an option.
      expect(find.byIcon(Icons.pin_drop_outlined), findsOneWidget);
      expect(
        find.text('Type it, or tap the pin to choose on the map'),
        findsOneWidget,
      );
    });

    testWidgets('Update stays off until something actually changes',
        (tester) async {
      signInFrom('Nigeria', state: 'Lagos', phone: '+2348031234567');
      await pumpEditProfile(tester);

      final button = tester.widget<XButton>(find.byType(XButton));
      expect(button.onPressed, isNull, reason: 'nothing edited yet');

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Current address'), '12 Awolowo Rd');
      await tester.pump();

      final after = tester.widget<XButton>(find.byType(XButton));
      expect(after.onPressed, isNotNull, reason: 'address was edited');
    });

    testWidgets('tapping Update while it is off does nothing', (tester) async {
      signInFrom('Nigeria', state: 'Lagos', phone: '+2348031234567');
      await pumpEditProfile(tester);

      // A null onPressed used to be invoked anyway and threw.
      await tester.tap(find.text('Update profile'));
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('middle name starts empty rather than echoing the first name',
        (tester) async {
      signInFrom('Nigeria', phone: '+2348031234567');
      await pumpEditProfile(tester);

      // 'Ada' is the first name; it must not be prefilled into middle name.
      expect(find.text('Ada'), findsOneWidget);
    });
  });
}
