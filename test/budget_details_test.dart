import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/models/checklist_data_model.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/budget/budget_details_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/budget/budget_snapshot.dart';
import 'package:mobile_auto_drive/ui/new_ui/budget/budget_widgets.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/info_details_action/info_details_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/report/budget_tiles_view.dart';
import 'package:mobile_auto_drive/utils/currency.dart';
import 'package:mobile_auto_drive/utils/enums.dart';
import 'package:mobile_auto_drive/utils/env_config.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';

Budget budget({
  String id = 'budget-1',
  String make = 'Toyota',
  int? limit,
  int spent = 0,
  List<Fueling> fueling = const [],
  List<Servicing> servicing = const [],
  List<Repairing> repairing = const [],
}) =>
    Budget(
      sId: id,
      carId: CarId(sId: 'car-$id', carMake: make, carModel: 'Corolla', images: [], carDocuments: []),
      mileage: 0,
      checklistData: ChecklistData(items: []),
      currentSpending: spent,
      fueling: [...fueling],
      servicing: [...servicing],
      repairing: [...repairing],
      breakdowns: [],
      mileageData: [],
    )..budget = limit;

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    EvnConfig.init(envType: 'Development');
    if (!serviceLocator.isRegistered<UserService>()) await locatorSetup();
    SharedPreferences.setMockInitialValues({});
    await PersistenceService.getInstance();
  });

  void seed(List<Budget> budgets) {
    serviceLocator<BudgetingService>().budgetingModel = BudgetingModel(statusCode: 200, budget: budgets);
  }

  void usePhoneScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  Widget host(Widget child) => MaterialApp(
        home: Builder(
          builder: (context) {
            final size = MediaQuery.of(context).size;
            SizeConfig.init(context, width: size.width, height: size.height, allowFontScaling: true);
            return Scaffold(body: child);
          },
        ),
      );

  group('BudgetSnapshot', () {
    test('sums each category and measures spending against the budget', () {
      final snapshot = BudgetSnapshot.fromBudget(budget(
        limit: 100000,
        spent: 60000,
        fueling: [Fueling(price: 20000), Fueling(price: 10000)],
        servicing: [Servicing(price: 25000)],
        repairing: [Repairing(price: 5000)],
      ));

      expect(snapshot.fuel, 30000);
      expect(snapshot.fuelCount, 2);
      expect(snapshot.servicing, 25000);
      expect(snapshot.repairs, 5000);
      expect(snapshot.categorised, 60000);
      expect(snapshot.remaining, 40000);
      expect(snapshot.percentUsed, 60);
      expect(snapshot.progress, 0.6);
      expect(snapshot.status, BudgetStatus.onTrack);
    });

    test('flags spending near and over the limit', () {
      expect(BudgetSnapshot.fromBudget(budget(limit: 100, spent: 80)).status, BudgetStatus.nearLimit);

      final over = BudgetSnapshot.fromBudget(budget(limit: 100, spent: 150));
      expect(over.status, BudgetStatus.over);
      expect(over.remaining, -50);
      expect(over.progress, 1.0);
      expect(over.percentUsed, 150);
    });

    test('treats a missing budget, car or lists as zero', () {
      expect(BudgetSnapshot.fromBudget(budget()).status, BudgetStatus.notSet);
      expect(BudgetSnapshot.fromBudget(null).spent, 0);
      expect(BudgetSnapshot.fromBudget(Budget()).categorised, 0);
    });
  });

  group('BudgetSummaryCard', () {
    testWidgets('shows spent, budget, usage and a friendly status, and opens on tap', (tester) async {
      var taps = 0;
      await tester.pumpWidget(host(BudgetSummaryCard(
        snapshot: BudgetSnapshot.fromBudget(budget(limit: 100000, spent: 40000)),
        onTap: () => taps++,
      )));
      await tester.pumpAndSettle();

      expect(find.text('Spent so far'), findsOneWidget);
      expect(find.text('40% used'), findsOneWidget);
      expect(find.textContaining("You're on track"), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);

      await tester.tap(find.text('Spent so far'));
      expect(taps, 1);
    });

    testWidgets('nudges the user to add a car when there is none', (tester) async {
      await tester.pumpWidget(host(const BudgetSummaryCard(snapshot: BudgetSnapshot(), hasCar: false)));

      expect(find.text('No budget yet'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });
  });

  group('BudgetDetailsScreen', () {
    testWidgets('shows the picked car, its totals and the category breakdown', (tester) async {
      usePhoneScreen(tester);
      seed([
        budget(id: 'a', make: 'Honda', limit: 50000, spent: 10000),
        budget(
          id: 'b',
          limit: 100000,
          spent: 120000,
          fueling: [Fueling(price: 90000)],
          servicing: [Servicing(price: 30000)],
        ),
      ]);
      await tester.pumpWidget(host(const BudgetDetailsScreen(budgetIndex: 1)));
      await tester.pumpAndSettle();

      expect(find.text('Toyota Corolla'), findsOneWidget);
      expect(find.text('Over by'), findsOneWidget);
      expect(find.text('120%'), findsOneWidget);
      expect(find.textContaining('over budget'), findsOneWidget);
      expect(find.text('Fuel'), findsOneWidget);
      expect(find.text('75%'), findsOneWidget);
      expect(find.text('25%'), findsOneWidget);
      expect(find.text('No entries yet'), findsOneWidget);
    });

    testWidgets('explains an empty breakdown and offers to set a budget', (tester) async {
      usePhoneScreen(tester);
      seed([budget()]);
      await tester.pumpWidget(host(const BudgetDetailsScreen(budgetIndex: 0)));
      await tester.pumpAndSettle();

      expect(find.text('Nothing logged yet'), findsOneWidget);
      expect(find.text('Set a budget'), findsOneWidget);
    });

    testWidgets('update opens the budget sheet for the picked car', (tester) async {
      usePhoneScreen(tester);
      seed([
        budget(id: 'a', limit: 50000)..carName = 'First car',
        budget(id: 'b', limit: 80000)..carName = 'Second car',
      ]);
      await tester.pumpWidget(host(const BudgetDetailsScreen(budgetIndex: 1)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Update budget'));
      await tester.pumpAndSettle();

      expect(find.byType(InfoDetailsView), findsOneWidget);
      expect(find.text('Second car'), findsOneWidget);
      expect(find.text('First car'), findsNothing);
    });

    testWidgets('log spending lists the picked car\'s spending and opens the right sheet', (tester) async {
      // Tall enough for the repair sheet with the wide test font.
      tester.view.physicalSize = const Size(1170, 3000);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      seed([
        budget(id: 'a', make: 'Honda', limit: 50000, fueling: [Fueling(price: 1111)]),
        budget(
          id: 'b',
          limit: 100000,
          spent: 40000,
          fueling: [Fueling(price: 30000)],
          repairing: [Repairing(price: 10000)],
        ),
      ]);
      await tester.pumpWidget(host(const BudgetDetailsScreen(budgetIndex: 1)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Log spending'));
      await tester.pumpAndSettle();

      final sheet = find.byType(BudgetTilesView);
      expect(sheet, findsOneWidget);
      Finder inSheet(String text) => find.descendant(of: sheet, matching: find.text(text));
      expect(inSheet('Fuel'), findsOneWidget);
      expect(inSheet('Servicing'), findsOneWidget);
      expect(inSheet('Repairs'), findsOneWidget);
      expect(inSheet('Budget left'), findsOneWidget);
      expect(inSheet(money(30000)), findsOneWidget);
      expect(inSheet(money(10000)), findsOneWidget);
      expect(inSheet(money(1111)), findsNothing);

      await tester.tap(inSheet('Repairs'));
      await tester.pumpAndSettle();
      final info = tester.widget<InfoDetailsView>(find.byType(InfoDetailsView));
      expect(info.infoType, InfoType.repairing);
      expect(info.currentIndex, 1);
    });
  });
}
