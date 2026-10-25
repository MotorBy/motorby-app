import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_auto_drive/models/plan_model.dart';
import 'package:mobile_auto_drive/models/user_model.dart';
import 'package:mobile_auto_drive/services/payment_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/profile_screen.dart';
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

    // init() fetches plans when none are cached, which would hit the network.
    serviceLocator<AppPaymentService>().planModel = PlanModel(statusCode: 200);

    serviceLocator<UserService>().userModel = UserModel(
      statusCode: 200,
      payload: Payload(
        user: User(
          userId: 'u1',
          fullname: 'Ada Nwosu',
          firstname: 'Ada',
          lastname: 'Nwosu',
          email: 'ada@test.dev',
          country: 'Nigeria',
          state: 'Lagos',
          phonenumber: '+2348031234567',
          userType: 'USER',
          // init() reads these without null checks, the way real API users
          // always carry them.
          planDetails: PlanDetails(userPlan: 'free'),
        ),
      ),
    );
  });

  Future<void> pumpProfile(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            final size = MediaQuery.of(context).size;
            SizeConfig.init(context,
                width: size.width, height: size.height, allowFontScaling: true);
            return const NewProfileScreen();
          },
        ),
      ),
    );
    // init() runs async; let it finish here so its notifyListeners does not
    // land after the test ends and fail the next one.
    await tester.pumpAndSettle();
  }

  /// The log out row sits below the fold on a short screen, so scroll it into
  /// view before tapping, the way a user would.
  Future<void> openLogOutSheet(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
  }

  group('profile options are all on the page', () {
    testWidgets('the overflow menu is gone', (tester) async {
      await pumpProfile(tester);

      expect(find.byType(PopupMenuButton<int>), findsNothing);
      expect(find.byIcon(Icons.more_vert), findsNothing);
    });

    testWidgets('every option that was hidden in it is now a visible row',
        (tester) async {
      await pumpProfile(tester);

      expect(find.text('Edit profile'), findsOneWidget);
      expect(find.text('Payment and subscription'), findsOneWidget);
      expect(find.text('My documents'), findsOneWidget);
      expect(find.text('About app'), findsOneWidget);
      expect(find.text('Log out'), findsOneWidget);
    });

    testWidgets('edit profile says what it covers', (tester) async {
      await pumpProfile(tester);

      expect(find.text('Name, phone number and address'), findsOneWidget);
    });
  });

  group('logging out', () {
    testWidgets('prompts in a sheet instead of signing out on the first tap',
        (tester) async {
      await pumpProfile(tester);

      await openLogOutSheet(tester);

      expect(find.text('Log out?'), findsOneWidget);
      expect(find.textContaining('need to sign in again'), findsOneWidget);
      // Both ways out are offered.
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('cancelling closes the sheet and changes nothing',
        (tester) async {
      await pumpProfile(tester);

      await openLogOutSheet(tester);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Log out?'), findsNothing);
      expect(find.byType(NewProfileScreen), findsOneWidget);
    });
  });

  group('account deletion', () {
    testWidgets('is offered from the log out sheet', (tester) async {
      await pumpProfile(tester);

      await openLogOutSheet(tester);

      expect(find.text('Leaving for good?'), findsOneWidget);
      expect(find.text('Request account deletion'), findsOneWidget);
    });

    testWidgets('asks a second time, and says what is lost', (tester) async {
      await pumpProfile(tester);

      await openLogOutSheet(tester);
      await tester.tap(find.text('Request account deletion'));
      await tester.pumpAndSettle();

      expect(find.text('Delete your account?'), findsOneWidget);
      expect(find.textContaining('cars, documents'), findsOneWidget);
      expect(find.textContaining('cannot be undone'), findsOneWidget);
    });

    testWidgets('backing out of the confirmation keeps the account',
        (tester) async {
      await pumpProfile(tester);

      await openLogOutSheet(tester);
      await tester.tap(find.text('Request account deletion'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Keep my account'));
      await tester.pumpAndSettle();

      expect(find.text('Delete your account?'), findsNothing);
      expect(find.byType(NewProfileScreen), findsOneWidget);
    });

    testWidgets('deleting needs two deliberate taps, not one', (tester) async {
      await pumpProfile(tester);

      // The row on the page is Log out, never Delete.
      expect(find.text('Request account deletion'), findsNothing);
      expect(find.text('Delete your account?'), findsNothing);

      await openLogOutSheet(tester);
      expect(find.text('Delete your account?'), findsNothing);

      await tester.tap(find.text('Request account deletion'));
      await tester.pumpAndSettle();
      expect(find.text('Delete your account?'), findsOneWidget);
    });
  });
}
