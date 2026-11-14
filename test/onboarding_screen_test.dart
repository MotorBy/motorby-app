import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/ui/auth/sigin_screen.dart';
import 'package:mobile_auto_drive/ui/onboarding/onboarding_screen.dart';
import 'package:mobile_auto_drive/utils/env_config.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    EvnConfig.init(envType: 'Development');
  });

  setUp(() async {
    if (!serviceLocator.isRegistered<UserService>()) await locatorSetup();
    SharedPreferences.setMockInitialValues({});
    PersistenceService.secureStorage = null;
    await PersistenceService.getInstance();
  });

  // Wide enough for the sign-in screen some tests land on, which overflows on
  // narrower layouts.
  Future<void> pumpOnboarding(WidgetTester tester,
      {Size size = const Size(440, 900)}) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(MaterialApp(
      home: Builder(builder: (context) {
        final size = MediaQuery.of(context).size;
        SizeConfig.init(context,
            width: size.width, height: size.height, allowFontScaling: true);
        return const OnboardingScreen();
      }),
    ));
    await tester.pump();
  }

  // The chips bob forever, so settle with a bounded pump instead of
  // pumpAndSettle.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  /// Signing in builds screens that read storage outside the test clock.
  Future<void> waitForSignIn(WidgetTester tester) async {
    for (var i = 0; i < 5 && find.byType(SignInScreen).evaluate().isEmpty; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await settle(tester);
    }
  }

  test('there are three slides', () {
    expect(onboardingSlides, hasLength(3));
  });

  testWidgets('opens on the first slide with Next and Skip', (tester) async {
    await pumpOnboarding(tester);

    expect(find.text(onboardingSlides[0].title), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets('swiping moves to the next slide', (tester) async {
    await pumpOnboarding(tester);

    await tester.fling(find.byType(PageView), const Offset(-400, 0), 1000);
    await settle(tester);

    expect(find.text(onboardingSlides[1].title), findsOneWidget);
  });

  testWidgets('Next walks through to Get started on the last slide',
      (tester) async {
    await pumpOnboarding(tester);

    await tester.tap(find.text('Next'));
    await settle(tester);
    expect(find.text(onboardingSlides[1].title), findsOneWidget);

    await tester.tap(find.text('Next'));
    await settle(tester);
    expect(find.text(onboardingSlides[2].title), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
    expect(find.text('Next'), findsNothing);
  });

  testWidgets('Get started remembers onboarding and goes to sign in',
      (tester) async {
    await pumpOnboarding(tester);
    await tester.tap(find.text('Next'));
    await settle(tester);
    await tester.tap(find.text('Next'));
    await settle(tester);

    await tester.tap(find.text('Get started'));
    await waitForSignIn(tester);

    expect(find.byType(SignInScreen), findsOneWidget);
    expect(serviceLocator<PersistenceService>().getOnboarding, isTrue);
  });

  testWidgets('Skip goes straight to sign in', (tester) async {
    await pumpOnboarding(tester);

    await tester.tap(find.text('Skip'));
    await waitForSignIn(tester);

    expect(find.byType(SignInScreen), findsOneWidget);
    expect(serviceLocator<PersistenceService>().getOnboarding, isTrue);
  });

  testWidgets('every slide fits on a small phone', (tester) async {
    // Overflow errors fail the test on their own.
    await pumpOnboarding(tester, size: const Size(360, 640));

    for (var i = 0; i < onboardingSlides.length; i++) {
      expect(find.text(onboardingSlides[i].title), findsOneWidget);
      if (i < onboardingSlides.length - 1) {
        await tester.tap(find.text('Next'));
        await settle(tester);
      }
    }
  });
}
