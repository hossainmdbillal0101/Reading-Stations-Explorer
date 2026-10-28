import 'package:http/testing.dart';
import 'package:reading_stations_explorer/src/firebase_api.dart';
import 'package:reading_stations_explorer/src/models.dart';

class FakeData {
  final collections = <String, Map<String, Map<String, dynamic>>>{
    'books': {for (final book in demoBooks) book.id: book.toJson()},
    'stations': {for (final station in demoStations) station.id: station.toJson()},
    'requests': {},
    'users': {},
  };
}

/// Injected backend fixture; production demo users never receive admin claims.
class FakeFirebase extends FirebaseApi {
  final bool adminRole;
  final String userId;
  final FakeData data;
  FakeFirebase({this.adminRole = false, this.userId = 'reader-1', FakeData? data})
      : data = data ?? FakeData(),
        super(client: MockClient((_) async => throw StateError('Unexpected network call')));
  @override
  bool get configured => true;
  @override
  Future<void> authenticate(String email, String password, {bool register = false}) async {
    uid = userId;
    this.email = email;
    admin = adminRole;
  }
  @override
  Future<Map<String, dynamic>?> profile() async => data.collections['users']![uid];
  @override
  Future<List<Map<String, dynamic>>> list(String collection) async =>
      data.collections[collection]!.entries.map((entry) => {'id': entry.key, ...entry.value}).toList();
  @override
  Future<List<Map<String, dynamic>>> requests() async =>
      (await list('requests')).where((row) => admin || row['userId'] == uid).toList();
  @override
  Future<void> save(String collection, String id, Map<String, dynamic> value) async {
    data.collections[collection]![id] = Map.of(value);
  }
  @override
  Future<void> delete(String collection, String id) async {
    data.collections[collection]!.remove(id);
  }
}
