import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_auto_drive/models/LatLngAddressModel.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/models/checklist_data_model.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/checklist_screen/checklist_tile_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/home/info_details_action/info_details_view.dart';
import 'package:mobile_auto_drive/ui/new_ui/mileage/mileage_details_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/mileage/mileage_summary.dart';
import 'package:mobile_auto_drive/utils/enums.dart';
import 'package:mobile_auto_drive/utils/env_config.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';
import 'package:mobile_auto_drive/widgets/show_bottomsheet.dart';

MileageDatum log(String reading, {String? gauge, String? address, DateTime? at}) => MileageDatum(
      odometerReading: reading,
      currentFuelGauge: gauge,
      destinationAddress: address,
      destinationLocation: address == null ? null : Location(lat: 6.45, lng: 3.39),
      inputDate: at,
    );

Budget budget({
  String id = 'budget-1',
  String make = 'Toyota',
  List<MileageDatum> logs = const [],
  List<Fueling> fueling = const [],
}) =>
    Budget(
      sId: id,
      carId: CarId(sId: 'car-$id', carMake: make, carModel: 'Corolla', images: [], carDocuments: []),
      mileage: 0,
      checklistData: ChecklistData(items: []),
      currentSpending: 0,
      fueling: [...fueling],
      servicing: [],
      repairing: [],
      breakdowns: [],
      mileageData: [...logs],
    );

final threeLogs = [
  log('12000', gauge: 'full', address: '12 Admiralty Way, Lekki', at: DateTime(2026, 10, 1, 9)),
  log('12,150', gauge: 'mid', at: DateTime(2026, 10, 5, 18)),
  log('12400', gauge: 'empty', address: '5 Broad Street, Lagos', at: DateTime(2026, 10, 20, 8, 30)),
];

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

  // A typical phone screen, so sheets lay out as they do on a device.
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
            return child;
          },
        ),
      );

  group('MileageSummary', () {
    test('derives readings, distances and the latest entry from the logs', () {
      final summary = MileageSummary.fromBudget(budget(logs: threeLogs));

      expect(summary.entries.map((e) => e.reading), [12400, 12150, 12000]);
      expect(summary.entries.map((e) => e.distanceSincePrevious), [250, 150, null]);
      expect(summary.currentReading, 12400);
      expect(summary.distanceTracked, 400);
      expect(summary.lastTripDistance, 250);
      expect(summary.latest!.datum.currentFuelGauge, 'empty');
    });

    test('skips unreadable readings when measuring distance', () {
      final summary = MileageSummary.fromBudget(budget(logs: [log('1000'), log('n/a'), log('1300')]));

      expect(summary.entries.map((e) => e.distanceSincePrevious), [300, null, null]);
      expect(summary.distanceTracked, 300);
    });

    test('works out fuel efficiency from litres bought over the distance tracked', () {
      final summary = MileageSummary.fromBudget(budget(
        logs: [log('1000'), log('1400')],
        fueling: [Fueling(price: 20000, pricePerLiter: 1000), Fueling(price: 20000, pricePerLiter: 1000)],
      ));

      expect(summary.fuelEfficiency, 10);
    });

    test('is empty for a car with no logs', () {
      final summary = MileageSummary.fromBudget(budget());

      expect(summary.isEmpty, isTrue);
      expect(summary.currentReading, isNull);
      expect(summary.distanceTracked, 0);
      expect(summary.fuelEfficiency, isNull);
    });
  });

  group('MileageDetailsScreen', () {
    testWidgets('shows the overview and every log, newest first', (tester) async {
      seed([budget(logs: threeLogs)]);
      await tester.pumpWidget(host(const MileageDetailsScreen(budgetIndex: 0)));
      await tester.pumpAndSettle();

      expect(find.text('Toyota Corolla'), findsOneWidget);
      expect(find.text('Current odometer'), findsOneWidget);
      expect(find.text('12,400 km'), findsNWidgets(2));
      expect(find.text('400 km'), findsOneWidget);
      expect(find.text('3 entries'), findsOneWidget);
      expect(find.text('+250 km'), findsOneWidget);
      expect(find.text('Fuel gauge: Empty'), findsOneWidget);
      expect(find.text('5 Broad Street, Lagos'), findsOneWidget);

      final newest = tester.getTopLeft(find.text('Fuel gauge: Empty')).dy;
      final older = tester.getTopLeft(find.text('Fuel gauge: Mid')).dy;
      expect(newest, lessThan(older));
    });

    testWidgets('shows the selected car, not always the first', (tester) async {
      seed([budget(logs: threeLogs), budget(id: 'budget-2', make: 'Honda', logs: [log('80000')])]);
      await tester.pumpWidget(host(const MileageDetailsScreen(budgetIndex: 1)));
      await tester.pumpAndSettle();

      expect(find.text('Honda Corolla'), findsOneWidget);
      expect(find.text('80,000 km'), findsNWidgets(2));
      expect(find.text('1 entry'), findsOneWidget);
    });

    testWidgets('explains how to start when nothing is logged', (tester) async {
      seed([budget()]);
      await tester.pumpWidget(host(const MileageDetailsScreen(budgetIndex: 0)));
      await tester.pumpAndSettle();

      expect(find.textContaining('No mileage logged yet'), findsOneWidget);
      expect(find.text('0 entries'), findsOneWidget);
    });

    testWidgets('update opens the mileage sheet, whose details link just closes it', (tester) async {
      usePhoneScreen(tester);
      seed([budget(logs: threeLogs)]);
      await tester.pumpWidget(host(const MileageDetailsScreen(budgetIndex: 0)));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Update mileage'));
      await tester.pumpAndSettle();
      expect(find.text('Last reading: 12,400 km'), findsOneWidget);

      await tester.tap(find.text('View details'));
      await tester.pumpAndSettle();
      expect(find.text('Last reading: 12,400 km'), findsNothing);
      expect(find.byType(MileageDetailsScreen), findsOneWidget);
    });
  });

  group('mileage input sheet', () {
    Future<void> openSheet(WidgetTester tester, {int index = 0}) async {
      usePhoneScreen(tester);
      await tester.pumpWidget(host(Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => modalBottomSheetMenu(
              context: context,
              child: InfoDetailsView(infoType: InfoType.mileage, currentIndex: index, onBudgetAction: () {}),
            ),
            child: const Text('open'),
          ),
        ),
      )));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('shows the last reading for the chosen car', (tester) async {
      seed([budget(logs: threeLogs), budget(id: 'budget-2', logs: [log('80000')])]);
      await openSheet(tester, index: 1);

      expect(find.text('Last reading: 80,000 km'), findsOneWidget);
    });

    testWidgets('View details closes the sheet and opens the full details', (tester) async {
      seed([budget(logs: threeLogs)]);
      await openSheet(tester);

      await tester.tap(find.text('View details'));
      await tester.pumpAndSettle();

      expect(find.byType(MileageDetailsScreen), findsOneWidget);
      expect(find.text('Current odometer'), findsOneWidget);
      expect(find.text('Last reading: 12,400 km'), findsNothing);
    });

    testWidgets('tapping the last reading card also opens the details', (tester) async {
      seed([budget(logs: threeLogs)]);
      await openSheet(tester);

      await tester.tap(find.text('Last reading: 12,400 km'));
      await tester.pumpAndSettle();

      expect(find.byType(MileageDetailsScreen), findsOneWidget);
    });

    testWidgets('asks for a reading before updating', (tester) async {
      seed([budget(logs: threeLogs)]);
      await openSheet(tester);

      await tester.tap(find.text('Update'));
      await tester.pump();

      expect(find.text('Enter your odometer reading'), findsOneWidget);
    });

    testWidgets('rejects a reading lower than the last one, and clears the error on edit', (tester) async {
      seed([budget(logs: threeLogs)]);
      await openSheet(tester);

      await tester.enterText(find.byType(TextFormField).last, '12000');
      await tester.tap(find.text('Update'));
      await tester.pump();
      expect(find.text("Reading can't be lower than your last one (12,400 km)"), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).last, '12500');
      await tester.pump();
      expect(find.textContaining("can't be lower"), findsNothing);
    });
  });

  group('MileageTileView', () {
    testWidgets('formats the reading and opens details on tap', (tester) async {
      var opened = 0;
      await tester.pumpWidget(host(Scaffold(
        body: MileageTileView(totalMileage: '12400', onMileageUpdate: () => opened++),
      )));

      expect(find.text('12,400 km'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);

      await tester.tap(find.byType(MileageTileView));
      expect(opened, 1);
    });

    testWidgets('does not double the unit for a non-numeric value', (tester) async {
      await tester.pumpWidget(host(const Scaffold(body: MileageTileView(totalMileage: 'N/A'))));

      expect(find.text('N/A km'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
    });
  });
}
