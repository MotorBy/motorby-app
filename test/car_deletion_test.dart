import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_auto_drive/models/budgeting_model.dart';
import 'package:mobile_auto_drive/models/checklist_data_model.dart';
import 'package:mobile_auto_drive/services/api_services.dart';
import 'package:mobile_auto_drive/services/budgeting_service.dart';
import 'package:mobile_auto_drive/services/firebase_service.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_details_screen.dart';
import 'package:mobile_auto_drive/ui/new_ui/cars/car_list_screen.dart';
import 'package:mobile_auto_drive/utils/env_config.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';

void main() {
  // APIService.root reads the environment through APIKey, which blows up
  // unless the config singleton has been seeded the way main.dart does it.
  setUpAll(() => EvnConfig.init(envType: 'Development'));

  group('isFirebaseStorageUrl', () {
    test('accepts the download URLs car uploads produce', () {
      expect(
        isFirebaseStorageUrl(
            'https://firebasestorage.googleapis.com/v0/b/motorby-2f353.appspot.com/o/cars%2Ftoyota%2Fu1%2Fa.jpg?alt=media'),
        isTrue,
      );
      expect(isFirebaseStorageUrl('gs://motorby-2f353.appspot.com/cars/a.jpg'),
          isTrue);
      expect(
        isFirebaseStorageUrl('https://motorby-2f353.firebasestorage.app/cars/a.jpg'),
        isTrue,
      );
    });

    test('refuses URLs refFromURL would throw on', () {
      expect(isFirebaseStorageUrl('https://example.com/some-car.jpg'), isFalse);
      expect(isFirebaseStorageUrl('not a url at all'), isFalse);
      expect(isFirebaseStorageUrl(''), isFalse);
      expect(isFirebaseStorageUrl(null), isFalse);
    });

    test('is not fooled by a lookalike host', () {
      expect(
        isFirebaseStorageUrl('https://firebasestorage.googleapis.com.evil.test/a.jpg'),
        isFalse,
      );
    });
  });

  group('carStorageUrls', () {
    CarId carWith({List<String>? images, List<CarDocument>? documents}) =>
        CarId(images: images, carDocuments: documents);

    test('collects the car photos', () {
      final car = carWith(images: ['https://a.test/1.jpg', 'https://a.test/2.jpg']);

      expect(carStorageUrls(car), ['https://a.test/1.jpg', 'https://a.test/2.jpg']);
    });

    test('collects document scans alongside the photos', () {
      final car = carWith(
        images: ['https://a.test/1.jpg'],
        documents: [
          CarDocument(documentImage: 'https://a.test/licence.jpg'),
          CarDocument(documentImage: 'https://a.test/insurance.jpg'),
        ],
      );

      expect(carStorageUrls(car), [
        'https://a.test/1.jpg',
        'https://a.test/licence.jpg',
        'https://a.test/insurance.jpg',
      ]);
    });

    test('never lists the same file twice', () {
      final car = carWith(
        images: ['https://a.test/1.jpg', 'https://a.test/1.jpg'],
        documents: [CarDocument(documentImage: 'https://a.test/1.jpg')],
      );

      expect(carStorageUrls(car), ['https://a.test/1.jpg']);
    });

    test('skips empty and missing entries', () {
      final car = carWith(
        images: ['', 'https://a.test/1.jpg'],
        documents: [CarDocument(documentImage: null), CarDocument()],
      );

      expect(carStorageUrls(car), ['https://a.test/1.jpg']);
    });

    test('a car with nothing uploaded has nothing to clean up', () {
      expect(carStorageUrls(CarId()), isEmpty);
      expect(carStorageUrls(carWith(images: [], documents: [])), isEmpty);
    });
  });

  group('delete endpoint', () {
    test('targets the same path the update endpoint uses', () {
      expect(
        APIService.deleteCar(carId: 'abc123'),
        APIService.updateCars(carId: 'abc123'),
      );
      expect(APIService.deleteCar(carId: 'abc123'), endsWith('car/abc123'));
    });
  });

  group('delete action on the car details screen', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      if (!serviceLocator.isRegistered<UserService>()) await locatorSetup();
      // The budget tiles read the last-spending cache off SharedPreferences.
      SharedPreferences.setMockInitialValues({});
      await PersistenceService.getInstance();
    });

    // The screen renders spending tiles straight off the loaded budget and
    // force-unwraps it, so give it an empty-but-present budget to read.
    void seedBudget(CarId car) {
      serviceLocator<BudgetingService>().budgetingModel = BudgetingModel(
        statusCode: 200,
        budget: [
          Budget(
            sId: 'budget-1',
            carId: car,
            mileage: 0,
            checklistData: ChecklistData(items: []),
            currentSpending: 0,
            fueling: [],
            servicing: [],
            repairing: [],
            breakdowns: [],
            mileageData: [],
          ),
        ],
      );
    }

    Future<void> pumpDetails(WidgetTester tester, CarId car) async {
      seedBudget(car);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final size = MediaQuery.of(context).size;
              SizeConfig.init(context,
                  width: size.width, height: size.height, allowFontScaling: true);
              return CarDetailsScreen(carData: car, currentBudgetIndex: 0);
            },
          ),
        ),
      );
      await tester.pump();
    }

    final car = CarId(
      sId: 'car-1',
      carMake: 'Toyota',
      carModel: 'Corolla',
      carYear: '2019',
      images: ['https://firebasestorage.googleapis.com/v0/b/x/o/a.jpg'],
      carDocuments: [
        CarDocument(
            documentImage: 'https://firebasestorage.googleapis.com/v0/b/x/o/b.jpg'),
      ],
    );

    Future<void> openActions(WidgetTester tester) async {
      await tester.tap(find.byTooltip('Car actions'));
      await tester.pumpAndSettle();
    }

    testWidgets('keeps edit and delete off the screen itself', (tester) async {
      await pumpDetails(tester, car);

      expect(find.text('Edit car'), findsNothing);
      expect(find.text('Delete car'), findsNothing);
      expect(find.text('edit car'), findsNothing);
      expect(find.text('delete car'), findsNothing);
    });

    testWidgets('offers edit and delete in the car actions sheet',
        (tester) async {
      await pumpDetails(tester, car);
      await openActions(tester);

      expect(find.byType(MoreCarAction), findsOneWidget);
      expect(find.text('Edit car'), findsOneWidget);
      expect(find.text('Delete car'), findsOneWidget);
    });

    testWidgets('asks before deleting and says what goes with the car',
        (tester) async {
      await pumpDetails(tester, car);
      await openActions(tester);

      await tester.tap(find.text('Delete car'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.textContaining('Its 2 uploaded files will be removed too'),
        findsOneWidget,
      );
      expect(find.textContaining('cannot be undone'), findsOneWidget);
    });

    testWidgets('cancelling leaves the car alone', (tester) async {
      await pumpDetails(tester, car);
      await openActions(tester);

      await tester.tap(find.text('Delete car'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.byType(CarDetailsScreen), findsOneWidget);
    });

    testWidgets('a car with no uploads gets the shorter warning',
        (tester) async {
      // fromJson always defaults these to empty lists, so mirror that here.
      await pumpDetails(
        tester,
        CarId(
          sId: 'car-2',
          carMake: 'Honda',
          carModel: 'Civic',
          images: [],
          carDocuments: [],
        ),
      );
      await openActions(tester);

      await tester.tap(find.text('Delete car'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Honda Civic? This cannot be undone.'),
          findsOneWidget);
    });
  });

  group('car list empty state', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      if (!serviceLocator.isRegistered<UserService>()) await locatorSetup();
      SharedPreferences.setMockInitialValues({});
      await PersistenceService.getInstance();
    });

    Future<void> pumpList(WidgetTester tester) async {
      serviceLocator<BudgetingService>().budgetingModel =
          BudgetingModel(statusCode: 200, budget: []);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final size = MediaQuery.of(context).size;
              SizeConfig.init(context,
                  width: size.width, height: size.height, allowFontScaling: true);
              return const CarsListScreen();
            },
          ),
        ),
      );
      await tester.pump();
    }

    testWidgets('greets the user and offers to add a car', (tester) async {
      await pumpList(tester);

      expect(find.byType(NoCarsView), findsOneWidget);
      expect(find.text('Your garage is empty'), findsOneWidget);
      expect(find.text('Add your first car'), findsOneWidget);
    });
  });

  group('no cars view', () {
    testWidgets('the add button hands off to the caller', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          final size = MediaQuery.of(context).size;
          SizeConfig.init(context,
              width: size.width, height: size.height, allowFontScaling: true);
          return Scaffold(
            body: NoCarsView(
              padding: EdgeInsets.zero,
              onAddCar: () => tapped++,
            ),
          );
        }),
      ));

      await tester.tap(find.text('Add your first car'));
      await tester.pump();

      expect(tapped, 1);
    });
  });

  group('car list thumbnail', () {
    testWidgets('shows only the first photo of a car with several',
        (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CarListThumbnail(images: [
            'https://a.test/1.jpg',
            'https://a.test/2.jpg',
            'https://a.test/3.jpg',
          ]),
        ),
      ));

      final images = tester.widgetList<Image>(find.byType(Image)).toList();
      expect(images, hasLength(1));
      expect((images.single.image as NetworkImage).url, 'https://a.test/1.jpg');
    });
  });
}
