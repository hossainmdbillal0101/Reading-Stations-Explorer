import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reading_stations_explorer/src/store.dart';
import 'package:reading_stations_explorer/src/models.dart';
import 'helpers/fake_firebase.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late ExplorerStore store;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    store = ExplorerStore();
    await store.initialize();
  });
  test('public demo cannot administer the catalogue or resolve requests', () async {
    store.enterDemo();
    expect(store.admin, false);
    expect(await store.saveStation(const Station('new', 'New', 'New location')), false);
    expect(await store.deleteBook('book-1'), false);
    expect(await store.deleteStation('station-1'), false);
    expect(await store.saveProfile('admin'), true);
    expect(store.admin, false);
    await store.submitRequest('Missing title', 'Author', 'missing');
    expect(await store.resolveRequest(store.requests.single, 'resolved'), false);
    expect(store.books.length, 6);
    expect(store.stations.length, 3);
  });
  test('favourites persist across application instances and toggle off', () async {
    store.enterDemo();
    expect(await store.toggleFavourite('book-1'), true);
    final restored = ExplorerStore();
    await restored.initialize();
    expect(restored.favourites, contains('book-1'));
    expect(await restored.toggleFavourite('book-1'), true);
    expect(restored.favourites, isEmpty);
  });
  test('only an authenticated live administrator can maintain the catalogue', () async {
    final api = FakeFirebase(adminRole: true, userId: 'owner-1');
    store = ExplorerStore(api: api);
    expect(store.admin, false);
    expect(await store.authenticate('owner@example.invalid', 'fake-test-password', 'Owner'), true);
    expect(store.admin, true);
    expect(await store.deleteStation('station-1'), false);
    expect(await store.saveStation(const Station('new', 'New station', 'Sample location')), true);
    expect(await store.saveBook(const ReadingBook(id: 'new-book', title: 'New book', author: 'Author', category: 'Science', stationId: 'new', description: 'Sample')), true);
    expect(await store.deleteStation('new'), false);
    expect(await store.deleteBook('new-book'), true);
    expect(await store.deleteStation('new'), true);
    store.signOut();
    expect(store.admin, false);
    expect(await store.saveStation(const Station('other', 'Other', 'Location')), false);
  });
  test('live readers cannot become administrators through profile data', () async {
    final api = FakeFirebase();
    api.data.collections['users']!['reader-1'] = {'name': 'Administrator', 'email': 'reader@example.invalid', 'favourites': <String>[], 'admin': true};
    store = ExplorerStore(api: api);
    await store.authenticate('reader@example.invalid', 'fake-test-password', 'Reader');
    expect(store.admin, false);
    expect(await store.saveStation(const Station('new', 'New', 'Location')), false);
  });
  test('owned live requests are resolved only after administrator authentication', () async {
    final data = FakeData();
    final reader = ExplorerStore(api: FakeFirebase(data: data));
    await reader.authenticate('reader@example.invalid', 'fake-test-password', 'Reader');
    expect(await reader.submitRequest('Missing title', 'Author', 'missing'), true);
    final request = reader.requests.single;
    expect(await reader.resolveRequest(request, 'resolved'), false);
    final owner = ExplorerStore(api: FakeFirebase(adminRole: true, userId: 'owner-1', data: data));
    await owner.authenticate('owner@example.invalid', 'fake-test-password', 'Owner');
    expect(await owner.resolveRequest(request, 'resolved'), true);
    await reader.refresh();
    expect(reader.requests.single.status, 'resolved');
  });
  test('reader demo reset clears local favourites and requests', () async {
    store.enterDemo();
    await store.toggleFavourite('book-1');
    await store.submitRequest('Sample title', 'Sample author', 'suggestion');
    expect(await store.resetDemo(), true);
    expect(store.favourites, isEmpty);
    expect(store.requests, isEmpty);
    expect(store.books.length, 6);
  });
}
