import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile_auto_drive/services/user_service.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/map_view_model.dart';
import 'package:mobile_auto_drive/ui/new_ui/map/nearby/nearby_chips.dart';
import 'package:mobile_auto_drive/utils/env_config.dart';
import 'package:mobile_auto_drive/utils/locator_setup.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    EvnConfig.init(envType: 'Development');
    if (!serviceLocator.isRegistered<UserService>()) await locatorSetup();
  });

  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('chips open their category and the close chip hides them', (tester) async {
    NearbyCategory? picked;
    var closed = 0;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: NearbyChipsBar(onSelected: (c) => picked = c, onClose: () => closed++),
      ),
    ));

    expect(find.text('Gas stations'), findsOneWidget);
    expect(find.text('Repair shops'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);

    await tester.tap(find.text('Repair shops'));
    expect(picked!.type, 'car_repair');

    final close = find.byIcon(Icons.close_rounded);
    await tester.ensureVisible(close);
    await tester.pumpAndSettle();
    await tester.tap(close);
    expect(closed, 1);
  });

  test('remembers when the nearby chips are hidden', () async {
    final model = MapViewModel();
    await model.loadNearbyVisibility();
    expect(model.showNearby, isTrue);

    await model.setNearbyVisible(false);

    final reopened = MapViewModel();
    await reopened.loadNearbyVisibility();
    expect(reopened.showNearby, isFalse);
  });
}
