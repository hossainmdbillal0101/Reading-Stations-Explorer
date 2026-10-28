import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:reading_stations_explorer/src/firebase_api.dart';

void main() {
  test('Firestore codec preserves supported document fields', () {
    final original = <String, dynamic>{
      'name': 'Reader',
      'favourites': ['one', 'two'],
      'available': true,
      'count': 3
    };
    final fields = original
        .map((key, value) => MapEntry(key, FirebaseApi.encodeValue(value)));
    expect(FirebaseApi.decodeFields(fields), original);
  });
  test('reader requests use an owner query with bearer authentication',
      () async {
    final payload = base64Url
        .encode(utf8.encode(jsonEncode({'admin': false})))
        .replaceAll('=', '');
    final token = 'header.$payload.signature';
    final api = FirebaseApi(client: MockClient((request) async {
      if (request.url.host == 'identitytoolkit.googleapis.com') {
        return http.Response(
            jsonEncode({
              'localId': 'reader-1',
              'idToken': token,
              'refreshToken': 'fake-test-refresh',
              'expiresIn': '3600'
            }),
            200);
      }
      expect(request.url.path, endsWith('/documents:runQuery'));
      expect(request.headers['Authorization'], 'Bearer $token');
      expect(
          jsonDecode(request.body)['structuredQuery']['where']['fieldFilter']
              ['value']['stringValue'],
          'reader-1');
      return http.Response('[]', 200);
    }));
    await api.authenticate('reader@example.invalid', 'fake-test-password');
    expect(await api.requests(), isEmpty);
    api.signOut();
    expect(api.uid, isNull);
    expect(api.admin, false);
  });
  test('authentication errors do not establish a session', () async {
    final api = FirebaseApi(
        client: MockClient((_) async => http.Response(
            '{"error":{"message":"INVALID_LOGIN_CREDENTIALS"}}', 400)));
    await expectLater(
        api.authenticate('reader@example.invalid', 'fake-test-password'),
        throwsException);
    expect(api.uid, isNull);
  });
}
