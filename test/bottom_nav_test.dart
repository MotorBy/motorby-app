import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_auto_drive/ui/new_ui/home_nav/home_nav.dart';

void main() {
  testWidgets('shows exactly four tabs and reports the tapped index', (tester) async {
    int? tapped;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        bottomNavigationBar: BottomNavbar(currentIndex: 0, onTap: (i) => tapped = i),
      ),
    ));

    expect(dashboardTabs, hasLength(4));
    for (final label in ['Home', 'Reminders', 'Map', 'More']) {
      expect(find.text(label), findsOneWidget);
    }

    await tester.tap(find.text('Map'));
    expect(tapped, 2);
    await tester.tap(find.text('More'));
    expect(tapped, 3);
  });
}
