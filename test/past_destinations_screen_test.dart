import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_auto_drive/models/saved_locations_response.dart';
import 'package:mobile_auto_drive/models/saved_place_model.dart';
import 'package:mobile_auto_drive/services/persistence_service.dart';
import 'package:mobile_auto_drive/services/places_services.dart';
import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/addresses/past_destinations_screen.dart';
import 'package:mobile_auto_drive/utils/env_config.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';
import 'package:mobile_auto_drive/utils/size_config.dart';

SavedPlacePayload place({
  required String id,
  required String savedAs,
  required String address,
  String? description,
  String? name,
}) =>
    SavedPlacePayload(
      id: id,
      name: name ?? 'Saved address for $savedAs',
      address: address,
      savedLocationAs: savedAs,
      savedLocationDescription: description,
      location: Location(lat: 6.45, lng: 3.39),
      createdAt: DateTime(2026, 10, 1),
    );

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    EvnConfig.init(envType: 'Development');
    if (!serviceLocator.isRegistered<UserService>()) await locatorSetup();
    SharedPreferences.setMockInitialValues({});
    await PersistenceService.getInstance();
  });

  void seedSaved(List<SavedPlacePayload> places) {
    serviceLocator<PlacesService>().savedLocationsResponse =
        SavedLocationsResponse(statusCode: 200, message: 'ok', payload: places);
  }

  Widget host(Widget child) => MaterialApp(
        home: Builder(
          builder: (context) {
            final size = MediaQuery.of(context).size;
            SizeConfig.init(context,
                width: size.width, height: size.height, allowFontScaling: true);
            return child;
          },
        ),
      );

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(host(const PastDestinationsScreen()));
    await tester.pumpAndSettle();
  }

  testWidgets('lists saved home and work addresses with an edit action each',
      (tester) async {
    seedSaved([
      place(id: 'h1', savedAs: 'home', address: '12 Admiralty Way', description: 'Flat'),
      place(id: 'w1', savedAs: 'work', address: '5 Broad Street'),
    ]);
    await pumpScreen(tester);

    expect(find.text('12 Admiralty Way'), findsOneWidget);
    expect(find.text('5 Broad Street'), findsOneWidget);
    expect(find.byTooltip('Edit Home address'), findsOneWidget);
    expect(find.byTooltip('Edit Work address'), findsOneWidget);
  });

  testWidgets('editing opens the form prefilled with the saved address',
      (tester) async {
    seedSaved([
      place(id: 'h1', savedAs: 'home', address: '12 Admiralty Way', description: 'Flat'),
    ]);
    await pumpScreen(tester);

    await tester.tap(find.byTooltip('Edit Home address'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Home Address'), findsOneWidget);
    expect(find.text('12 Admiralty Way'), findsNWidgets(2));
    expect(find.widgetWithText(TextField, 'Flat'), findsOneWidget);
  });

  testWidgets('tapping the address card also opens the edit form', (tester) async {
    seedSaved([place(id: 'w1', savedAs: 'work', address: '5 Broad Street')]);
    await pumpScreen(tester);

    await tester.tap(find.text('5 Broad Street'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Work Address'), findsOneWidget);
  });

  testWidgets('shows only addresses that are actually saved', (tester) async {
    seedSaved([
      place(id: 'p1', savedAs: 'place', address: '1 Market Road', name: 'Market'),
    ]);
    await pumpScreen(tester);

    expect(find.text('No saved addresses yet'), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsNothing);
    expect(find.text('Market'), findsOneWidget);
  });
}
