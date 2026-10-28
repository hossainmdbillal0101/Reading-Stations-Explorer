import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reading_stations_explorer/src/store.dart';
import 'package:reading_stations_explorer/src/models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ExplorerStore store;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = ExplorerStore();
    await store.initialize();
  });
  test('reader cannot mutate catalogue or escalate through a saved profile',
      () async {
    store.enterDemo();
    expect(await store.saveStation(const Station('new', 'New', 'New location')),
        false);
    expect(store.stations.length, 3);
    expect(await store.saveProfile('admin'), true);
    expect(store.admin, false);
  });
  test('favourites persist across application instances and toggle off',
      () async {
    store.enterDemo();
    expect(await store.toggleFavourite('book-1'), true);
    final restored = ExplorerStore();
    await restored.initialize();
    expect(restored.favourites, contains('book-1'));
    expect(await restored.toggleFavourite('book-1'), true);
    expect(restored.favourites, isEmpty);
  });
  test(
      'admin edits persist, occupied stations are protected, reset restores seeds',
      () async {
    store.enterDemo(asAdmin: true);
    expect(await store.deleteStation('station-1'), false);
    expect(
        await store.saveStation(
            const Station('new', 'New station', 'Sample location')),
        true);
    expect(
        await store.saveBook(const ReadingBook(
            id: 'new-book',
            title: 'New book',
            author: 'Author',
            category: 'Science',
            stationId: 'new',
            description: 'Sample')),
        true);
    expect(await store.deleteStation('new'), false);
    expect(await store.deleteBook('new-book'), true);
    expect(await store.deleteStation('new'), true);
    expect(await store.resetDemo(), true);
    expect(store.books.length, 6);
    expect(store.stations.length, 3);
  });
  test(
      'requests can be submitted by readers and resolved only by administrators',
      () async {
    store.enterDemo();
    expect(
        await store.submitRequest('Missing title', 'Author', 'missing'), true);
    final request = store.requests.single;
    expect(await store.resolveRequest(request, 'resolved'), false);
    store.enterDemo(asAdmin: true);
    expect(await store.resolveRequest(request, 'resolved'), true);
    expect(store.requests.single.status, 'resolved');
    final restored = ExplorerStore();
    await restored.initialize();
    expect(restored.requests.single.status, 'resolved');
  });
}
