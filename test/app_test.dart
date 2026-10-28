import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reading_stations_explorer/src/app.dart';
import 'package:reading_stations_explorer/src/store.dart';

void main() {
  testWidgets(
      'reader enters demo, filters books, and sees an empty search state',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final store = ExplorerStore();
    await store.initialize();
    await tester.pumpWidget(ExplorerApp(store: store));
    await tester.tap(find.text('Explore as a reader'));
    await tester.pumpAndSettle();
    expect(find.text('Reading Stations'), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Sherlock');
    await tester.pumpAndSettle();
    expect(find.text('The Adventures of Sherlock Holmes'), findsOneWidget);
    expect(find.text('Pride and Prejudice'), findsNothing);
    await tester.enterText(find.byType(TextField).first, 'not a real title');
    await tester.pumpAndSettle();
    expect(find.text('No materials here yet'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop admin navigation renders and mobile welcome fits',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store = ExplorerStore();
    await store.initialize();
    store.enterDemo(asAdmin: true);
    await tester.pumpWidget(ExplorerApp(store: store));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Manage'));
    await tester.pumpAndSettle();
    expect(find.text('Care for the collection.'), findsOneWidget);
    expect(find.text('Add material'), findsOneWidget);
    expect(tester.takeException(), isNull);
    store.signOut();
    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();
    expect(find.text('Explore as a reader'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
