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
  void signInFrom(String country, {String? state}) {
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

  group('editing country, state and address', () {
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

    testWidgets('the form offers all three location fields', (tester) async {
      signInFrom('Nigeria', state: 'Lagos');
      await pumpEditProfile(tester);

      expect(find.text('Country'), findsOneWidget);
      expect(find.text('State'), findsOneWidget);
      expect(find.text('Current address'), findsOneWidget);
    });

    testWidgets('country shows the currency it will bill in', (tester) async {
      signInFrom('Ghana', state: 'Accra');
      await pumpEditProfile(tester);

      expect(find.text('Ghana  (GHS)'), findsOneWidget);
    });

    testWidgets('picking a country switches the billing currency with it',
        (tester) async {
      signInFrom('Nigeria', state: 'Lagos');
      await pumpEditProfile(tester);

      expect(find.text('Nigeria  (NGN)'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Austria').last);
      await tester.pumpAndSettle();

      expect(find.text('Austria  (EUR)'), findsOneWidget);
      expect(find.text('Nigeria  (NGN)'), findsNothing);
    });

    testWidgets('only the launch countries are offered', (tester) async {
      signInFrom('Nigeria');
      await pumpEditProfile(tester);

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Austria'), findsOneWidget);
      expect(find.text('Kenya'), findsOneWidget);
      // Not one of the five markets.
      expect(find.text('Canada'), findsNothing);
    });
  });
}
