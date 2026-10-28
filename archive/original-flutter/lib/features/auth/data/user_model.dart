// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserDataModel {
  String uid;
  String name;
  String email;
  String metric;
  List<String> favourites = [];
  UserDataModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.metric,
    required this.favourites,
  });

  UserDataModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? metric,
    List<String>? favourites,
  }) {
    return UserDataModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      metric: metric ?? this.metric,
      favourites: favourites ?? this.favourites,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'metric': metric,
      'favourites': favourites,
    };
  }

  factory UserDataModel.fromMap(Map<String, dynamic> map) {
    return UserDataModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      metric: map['metric'] as String,
      favourites: List<String>.from(
        map['favourites'] as List<dynamic>,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDataModel.fromJson(String source) =>
      UserDataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserDataModel(uid: $uid, name: $name, email: $email, metric: $metric, favourites: $favourites)';
  }

  @override
  bool operator ==(covariant UserDataModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.metric == metric &&
        listEquals(other.favourites, favourites);
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        metric.hashCode ^
        favourites.hashCode;
  }
}
