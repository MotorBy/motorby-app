import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/models/plan_model.dart';
import 'package:mobile_auto_drive/models/user_model.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/payment_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/profile/profile_screen.dart';
import 'package:mobile_auto_drive/utils/env_config.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/session.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    EvnConfig.init(envType: 'Development');
    // Profile shows the app version, read from a plugin that isn't there in tests.
    PackageInfo.setMockInitialValues(
      appName: 'Motorby',
      packageName: 'com.motorby.app',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  // Logging out resets every service, so each test signs a user in afresh.
  setUp(() async {
    if (!serviceLocator.isRegistered<UserService>()) await locatorSetup();
    SharedPreferences.setMockInitialValues({'id': 'u1', 'tk': 'token', 'onboarding': true});
    PersistenceService.secureStorage = null;
    await PersistenceService.getInstance();

    serviceLocator<AppPaymentService>().planModel = PlanModel(statusCode: 200);
    serviceLocator<BudgetingService>().budgetingModel = BudgetingModel(statusCode: 200, budget: []);
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
          planDetails: PlanDetails(userPlan: 'free'),
        ),
      ),
    );
  });

  Widget host(Widget home) => MaterialApp(
        home: Builder(
          builder: (context) {
            final size = MediaQuery.of(context).size;
            SizeConfig.init(context, width: size.width, height: size.height, allowFontScaling: true);
            return home;
          },
        ),
      );

  /// Stands in for the signed-in dashboard, with profile opened on top of it.
  Future<void> openProfileFromDashboard(WidgetTester tester) async {
    await tester.pumpWidget(host(Builder(
      builder: (context) => Scaffold(
        body: TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewProfileScreen()),
          ),
          child: const Text('dashboard'),
        ),
      ),
    )));
    await tester.tap(find.text('dashboard'));
    await tester.pumpAndSettle();
  }

  Future<void> confirmLogOut(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Log out'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Log out'));
    await tester.pumpAndSettle();
    // The sheet's confirm button, drawn above the profile row of the same name.
    await tester.tap(find.text('Log out').last);
    await tester.pumpAndSettle();
    expect(find.text('Log out?'), findsNothing);
    // Signing out talks to plugins and storage outside the test clock.
    for (var i = 0; i < 5 && find.byType(SignInScreen).evaluate().isEmpty; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pumpAndSettle();
    }
  }

  group('logging out from profile', () {
    testWidgets('lands on sign in with the signed-in screens cleared away', (tester) async {
      await openProfileFromDashboard(tester);

      await confirmLogOut(tester);

      expect(find.byType(SignInScreen), findsOneWidget);
      expect(find.byType(NewProfileScreen), findsNothing);
      expect(find.text('dashboard'), findsNothing);

      final navigator = tester.state<NavigatorState>(find.byType(Navigator).first);
      expect(navigator.canPop(), isFalse);
    });

    testWidgets('signs the user out and leaves fresh services for the next sign in', (tester) async {
      final oldBudgets = serviceLocator<BudgetingService>();
      await openProfileFromDashboard(tester);

      await confirmLogOut(tester);

      expect(serviceLocator<PersistenceService>().getUserID, isEmpty);
      expect(serviceLocator<BudgetingService>(), isNot(same(oldBudgets)));
      expect(serviceLocator<BudgetingService>().budgetingModel, isNull);
      expect(serviceLocator<UserService>().userModel, isNull);
    });
  });

  group('endSession', () {
    test('clears the session but remembers onboarding was seen', () async {
      await endSession();

      final persistence = serviceLocator<PersistenceService>();
      expect(persistence.getUserID, isEmpty);
      expect(PersistenceService.secureStorage!.getString('tk'), isNull);
      expect(persistence.getOnboarding, isTrue);
    });
  });

  group('showSignIn', () {
    testWidgets('replaces a deep stack, so back does not return to the app', (tester) async {
      await openProfileFromDashboard(tester);

      showSignIn(tester.state<NavigatorState>(find.byType(Navigator).first));
      await tester.pumpAndSettle();

      expect(find.byType(SignInScreen), findsOneWidget);
      expect(find.byType(NewProfileScreen), findsNothing);
      expect(tester.state<NavigatorState>(find.byType(Navigator).first).canPop(), isFalse);
    });
  });
}
