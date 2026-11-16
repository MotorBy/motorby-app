import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_auto_drive/ui/new_ui/budget/budget_widgets.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/models/checklist_data_model.dart';
import 'package:mobile_auto_drive/models/reminder_model.dart';
import 'package:mobile_auto_drive/models/user_model.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/home_viewmodel.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/home_widgets.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/new_home_revamp.dart';
import 'package:mobile_auto_drive/utils/env_config.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/session.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    EvnConfig.init(envType: 'Development');
    if (!serviceLocator.isRegistered<UserService>()) await locatorSetup();
    SharedPreferences.setMockInitialValues({});
    await PersistenceService.getInstance();
  });

  Budget budgetFor(CarId? car, {List<Item>? checklist}) => Budget(
        sId: 'budget-1',
        carId: car,
        mileage: 0,
        checklistData: ChecklistData(items: checklist ?? []),
        currentSpending: 0,
        fueling: [],
        servicing: [],
        repairing: [],
        breakdowns: [],
        mileageData: [],
      );

  void seed(List<Budget> budgets) {
    serviceLocator<BudgetingService>().budgetingModel =
        BudgetingModel(statusCode: 200, budget: budgets);
  }

  UserModel userNamed({String? first, String? full}) => UserModel(
        statusCode: 200,
        payload: Payload(user: User(firstname: first, fullname: full, country: 'Nigeria')),
      );

  group('onBudgetViewUpdated', () {
    test('copes with a budget whose car is gone', () {
      seed([budgetFor(null)]);
      final model = HomeViewModel();

      expect(() => model.onBudgetViewUpdated(0), returnsNormally);
      expect(model.hasAddedCar, isTrue);
      expect(model.currentCar, isNull);
      // The spending limit is missing too, so it falls back to zero.
      expect(model.currentSetBudget, 0);
    });

    test('copes with a car that has no make', () {
      // No id either, so the checklist fetch is skipped rather than hitting
      // the network.
      seed([budgetFor(CarId(carModel: 'Corolla'))]);
      final model = HomeViewModel();

      expect(() => model.onBudgetViewUpdated(0), returnsNormally);
      expect(model.currentCar?.carModel, 'Corolla');
    });

    test('drops back to the no-cars state once the last car is gone', () {
      seed([budgetFor(null)]);
      final model = HomeViewModel()..onBudgetViewUpdated(0);
      expect(model.hasAddedCar, isTrue);

      seed([]);
      model.onBudgetViewUpdated(0);

      expect(model.hasAddedCar, isFalse);
      expect(model.currentCar, isNull);
      expect(model.currentBudget, isNull);
    });

    test('keeps a stale index inside the cars that exist', () {
      seed([budgetFor(CarId(carModel: 'Only one'))]);
      final model = HomeViewModel()..onBudgetViewUpdated(3);

      expect(model.currentBudgetViewIndex, 0);
      expect(model.currentCar?.carModel, 'Only one');
    });
  });

  group('derived values', () {
    test('greets by first name, falling back to the full name', () {
      final model = HomeViewModel();
      expect(model.firstName, '');
      expect(model.initial, '');

      model.userModel = userNamed(full: 'ada  nwosu');
      expect(model.firstName, 'ada');
      expect(model.initial, 'A');

      model.userModel = userNamed(first: 'Chidi', full: 'Ada Nwosu');
      expect(model.firstName, 'Chidi');
    });

    test('greeting follows the time of day', () {
      final model = HomeViewModel();
      expect(model.greeting(DateTime(2026, 1, 1, 8)), 'Good morning');
      expect(model.greeting(DateTime(2026, 1, 1, 13)), 'Good afternoon');
      expect(model.greeting(DateTime(2026, 1, 1, 20)), 'Good evening');
    });

    test('car title skips the parts the API left out', () {
      seed([budgetFor(CarId(carMake: 'Toyota', carYear: '2019'))]);
      final model = HomeViewModel()..onBudgetViewUpdated(0);
      expect(model.currentCarTitle, 'Toyota 2019');

      seed([budgetFor(CarId())]);
      model.onBudgetViewUpdated(0);
      expect(model.currentCarTitle, isNull);
    });

    test('checklist progress counts ticked items and survives a missing list', () {
      seed([
        budgetFor(CarId(), checklist: [
          Item(item: 'Brakes', isChecked: true),
          Item(item: 'Lights', isChecked: false),
          Item(item: 'Horn'),
        ]),
      ]);
      final model = HomeViewModel()..onBudgetViewUpdated(0);
      expect(model.checklistProgress, (checked: 1, total: 3));

      model.currentBudget = Budget();
      expect(model.checklistProgress, (checked: 0, total: 0));
    });

    test('previews at most five reminders', () {
      final model = HomeViewModel();
      expect(model.recentReminders, isEmpty);

      model.reminderListModel = ReminderListModel(
        statusCode: 200,
        message: '',
        data: List.generate(8, (i) => ReminderPayload(id: 'r$i')),
      );
      expect(model.recentReminders.map((r) => r.id), ['r0', 'r1', 'r2', 'r3', 'r4']);
    });
  });

  group('parseRecentSpend', () {
    final today = DateTime(2026, 11, 14);

    test('reads a well-formed record', () {
      final spend = parseRecentSpend({
        'dataType': 'Fueling',
        'data': {'price': 5000, 'date': '10-11-2026'},
      }, now: today);

      expect(spend?.price, 5000);
      expect(spend?.budgetType, 'Fueling');
      expect(spend?.isFutureBudget, isFalse);
    });

    test('flags spending planned for a later day', () {
      final spend = parseRecentSpend({
        'dataType': 'Servicing',
        'data': {'price': 20000, 'date': '1-12-2026'},
      }, now: today);

      expect(spend?.isFutureBudget, isTrue);
    });

    test('returns nothing for a missing or reshaped record', () {
      expect(parseRecentSpend(null), isNull);
      expect(parseRecentSpend({'dataType': 'Fueling'}), isNull);
      expect(parseRecentSpend({'data': 'not a map'}), isNull);
      expect(parseRecentSpend({'data': {'date': '1-1-2026'}}), isNull);
      // price changed from a number to a string
      expect(parseRecentSpend({'data': {'price': '5000'}}), isNull);
    });

    test('treats an unreadable date as not in the future', () {
      expect(isFutureDate('2026/12/01', now: today), isFalse);
      expect(isFutureDate(null, now: today), isFalse);
      expect(isFutureDate('', now: today), isFalse);
    });
  });

  group('isSessionExpiredError', () {
    test('recognises the API messages for a dead token', () {
      expect(isSessionExpiredError(Exception('jwt expired')), isTrue);
      expect(isSessionExpiredError(Exception('Failed/Invalid Token')), isTrue);
      expect(isSessionExpiredError('Unauthorized'), isTrue);
    });

    test('leaves other failures alone', () {
      expect(isSessionExpiredError(Exception('Network is unreachable')), isFalse);
      expect(isSessionExpiredError(null), isFalse);
    });
  });

  group('init', () {
    // In tests every HTTP call fails, which is exactly the offline case.
    testWidgets('a first load that fails shows the error, not a spinner', (tester) async {
      final model = HomeViewModel();

      await tester.runAsync(() => model.init());

      expect(model.status, HomeStatus.failed);
      expect(model.showLoadError, isTrue);
      expect(model.isFirstLoad, isFalse);
    });

    testWidgets('a failed refresh keeps what is already on screen', (tester) async {
      final model = HomeViewModel()..userModel = userNamed(first: 'Ada');

      await tester.runAsync(() => model.init());

      expect(model.status, HomeStatus.ready);
      expect(model.showLoadError, isFalse);
      expect(model.firstName, 'Ada');
    });

    testWidgets('a refresh during a load joins it', (tester) async {
      final model = HomeViewModel();

      await tester.runAsync(() async {
        final first = model.init();
        final second = model.init();
        expect(identical(first, second), isTrue);
        await first;
      });
    });
  });

  group('home screen', () {
    Future<void> pumpHome(WidgetTester tester, HomeViewModel model) async {
      await tester.binding.setSurfaceSize(const Size(400, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          final size = MediaQuery.of(context).size;
          SizeConfig.init(context, width: size.width, height: size.height, allowFontScaling: true);
          return NewHomeRevampScreen(viewModel: model);
        }),
      ));
      // Let the (failing) refresh settle outside the fake clock.
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      await tester.pump();
    }

    testWidgets('shows the error view with a retry when nothing loaded', (tester) async {
      await pumpHome(tester, HomeViewModel());

      expect(find.byType(HomeErrorView), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets('greets the user and keeps every section', (tester) async {
      seed([budgetFor(CarId(carMake: 'Toyota', carModel: 'Corolla', images: []))]);
      final model = HomeViewModel()
        ..userModel = userNamed(first: 'Ada')
        ..onBudgetViewUpdated(0);

      await pumpHome(tester, model);

      expect(find.text('Hi, Ada'), findsOneWidget);
      expect(find.byType(WeatherCard), findsOneWidget);
      expect(find.text('Your garage'), findsOneWidget);
      expect(find.text('View details'), findsOneWidget);
      expect(find.text('Toyota Corolla'), findsOneWidget);
      expect(find.text('Add car photos'), findsOneWidget);
      expect(find.text('Mileage'), findsOneWidget);
      expect(find.text('Checklist'), findsOneWidget);
      expect(find.text('Spending', skipOffstage: false), findsOneWidget);

      await tester.scrollUntilVisible(find.byType(RecentSpendCard), 300,
          scrollable: find.byType(Scrollable).first);
      expect(find.byType(BudgetSummaryCard), findsOneWidget);
      expect(find.text('See details'), findsOneWidget);
      expect(find.byType(RecentSpendCard), findsOneWidget);
      // Reminders moved off home.
      expect(find.text('Reminders'), findsNothing);
    });

    testWidgets('offers to add a car when there are none', (tester) async {
      seed([]);
      final model = HomeViewModel()
        ..userModel = userNamed(first: 'Ada')
        ..onBudgetViewUpdated(0);

      await pumpHome(tester, model);

      expect(find.text('Add your first car'), findsOneWidget);
      expect(find.text('View details'), findsNothing);
    });
  });
}
