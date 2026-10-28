import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_api.dart';
import 'models.dart';

class ExplorerStore extends ChangeNotifier {
  final FirebaseApi api;
  ExplorerStore({FirebaseApi? api}) : api = api ?? FirebaseApi();
  bool get live => FirebaseApi.enabled;
  bool signedIn = false, admin = false, busy = false;
  String name = 'Demo reader', email = '', uid = 'demo-reader';
  String? error;
  List<Station> stations = [];
  List<ReadingBook> books = [];
  List<MaterialRequest> requests = [];
  Set<String> favourites = {};
  SharedPreferences? _prefs;

  void dismissError() {
    error = null;
    notifyListeners();
  }

  Future<void> initialize() async {
    if (live) return;
    try {
      _prefs = await SharedPreferences.getInstance();
      final raw = _prefs!.getString('rse-demo-v2');
      if (raw != null) {
        final d = jsonDecode(raw) as Map<String, dynamic>;
        stations = (d['stations'] as List)
            .map((e) => Station.fromJson(
                e['id'] as String, Map<String, dynamic>.from(e)))
            .toList();
        books = (d['books'] as List)
            .map((e) => ReadingBook.fromJson(
                e['id'] as String, Map<String, dynamic>.from(e)))
            .toList();
        requests = (d['requests'] as List)
            .map((e) => MaterialRequest.fromJson(
                e['id'] as String, Map<String, dynamic>.from(e)))
            .toList();
        favourites = Set<String>.from(d['favourites'] as List);
        return;
      }
    } catch (_) {
      error =
          'Local demo storage is unavailable. Changes may last only this session.';
    }
    _seed();
  }

  void _seed() {
    stations = List.of(demoStations);
    books = List.of(demoBooks);
    requests = [];
    favourites = {};
  }

  Future<void> _persist() async {
    if (live) return;
    final ok = await _prefs?.setString(
        'rse-demo-v2',
        jsonEncode({
          'stations': stations.map((e) => {'id': e.id, ...e.toJson()}).toList(),
          'books': books.map((e) => {'id': e.id, ...e.toJson()}).toList(),
          'requests': requests.map((e) => {'id': e.id, ...e.toJson()}).toList(),
          'favourites': favourites.toList()
        }));
    if (ok != true) {
      error =
          'Changes are available this session; local storage could not save them.';
    }
  }

  Future<bool> run(Future<void> Function() action) async {
    if (busy) return false;
    busy = true;
    error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      busy = false;
      notifyListeners();
    }
  }

  void enterDemo({bool asAdmin = false}) {
    if (live) return;
    signedIn = true;
    admin = asAdmin;
    name = asAdmin ? 'Demo administrator' : 'Demo reader';
    uid = 'demo-reader';
    email = '';
    error = null;
    notifyListeners();
  }

  Future<bool> authenticate(String mail, String password, String displayName,
          {bool register = false}) =>
      run(() async {
        await api.authenticate(mail, password, register: register);
        uid = api.uid!;
        admin = api.admin;
        email = api.email ?? mail;
        final profile = await api.profile();
        name = profile?['name'] as String? ??
            (displayName.isEmpty ? mail.split('@').first : displayName);
        favourites = Set<String>.from(profile?['favourites'] as List? ?? []);
        if (profile == null) {
          await api.save('users', uid, {
            'name': name,
            'email': email,
            'favourites': favourites.toList()
          });
        }
        await _reload();
        signedIn = true;
      });

  Future<void> _reload() async {
    if (!live) return;
    // Assign only after all collections load, keeping the last good snapshot on failure.
    final b = await api.list('books');
    final s = await api.list('stations');
    final r = await api.requests();
    books = b.map((d) => ReadingBook.fromJson(d['id'] as String, d)).toList();
    stations = s.map((d) => Station.fromJson(d['id'] as String, d)).toList();
    requests =
        r.map((d) => MaterialRequest.fromJson(d['id'] as String, d)).toList();
  }

  Future<bool> refresh() => run(_reload);
  void signOut() {
    api.signOut();
    signedIn = false;
    admin = false;
    error = null;
    if (live) {
      books = [];
      stations = [];
      requests = [];
      favourites = {};
      name = '';
      email = '';
      uid = '';
    }
    notifyListeners();
  }

  String stationName(String id) =>
      stations.where((s) => s.id == id).map((s) => s.name).firstOrNull ??
      'Unassigned station';

  Future<bool> toggleFavourite(String id) => run(() async {
        final next = Set<String>.of(favourites);
        if (!next.add(id)) next.remove(id);
        if (live) {
          await api.save('users', uid,
              {'name': name, 'email': email, 'favourites': next.toList()});
        }
        favourites = next;
        await _persist();
      });
  Future<bool> saveProfile(String value) => run(() async {
        if (value.trim().isEmpty) throw Exception('Enter your name.');
        if (live) {
          await api.save('users', uid, {
            'name': value.trim(),
            'email': email,
            'favourites': favourites.toList()
          });
        }
        name = value.trim();
      });
  void _requireAdmin() {
    if (!admin) throw Exception('Administrator access required.');
  }

  String newId() => '${DateTime.now().microsecondsSinceEpoch}';
  Future<bool> saveBook(ReadingBook book) => run(() async {
        _requireAdmin();
        if (!stations.any((s) => s.id == book.stationId)) {
          throw Exception('Select an existing station.');
        }
        if (live) await api.save('books', book.id, book.toJson());
        books = [...books.where((b) => b.id != book.id), book];
        await _persist();
      });
  Future<bool> deleteBook(String id) => run(() async {
        _requireAdmin();
        if (live) await api.delete('books', id);
        books = books.where((b) => b.id != id).toList();
        favourites.remove(id);
        await _persist();
      });
  Future<bool> saveStation(Station station) => run(() async {
        _requireAdmin();
        if (live) await api.save('stations', station.id, station.toJson());
        stations = [...stations.where((s) => s.id != station.id), station];
        await _persist();
      });
  Future<bool> deleteStation(String id) => run(() async {
        _requireAdmin();
        if (books.any((b) => b.stationId == id)) {
          throw Exception('Move or remove this station books first.');
        }
        if (live) await api.delete('stations', id);
        stations = stations.where((s) => s.id != id).toList();
        await _persist();
      });
  Future<bool> submitRequest(String title, String author, String type) =>
      run(() async {
        final request = MaterialRequest(
            id: newId(), userId: uid, title: title, author: author, type: type);
        if (live) await api.save('requests', request.id, request.toJson());
        requests = [...requests, request];
        await _persist();
      });
  Future<bool> resolveRequest(MaterialRequest request, String status) =>
      run(() async {
        _requireAdmin();
        final updated = MaterialRequest(
            id: request.id,
            userId: request.userId,
            title: request.title,
            author: request.author,
            type: request.type,
            status: status);
        if (live) await api.save('requests', request.id, updated.toJson());
        requests = [...requests.where((r) => r.id != request.id), updated];
        await _persist();
      });
  Future<bool> resetDemo() => run(() async {
        if (live) throw Exception('Reset is only available in demo mode.');
        _seed();
        await _persist();
      });
}

extension FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
