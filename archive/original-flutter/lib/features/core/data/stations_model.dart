// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StationModel {
  String name;
  String? id;
  StationModel({
    required this.name,
    this.id,
  });

  StationModel copyWith({
    String? name,
    String? id,
  }) {
    return StationModel(
      name: name ?? this.name,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'id': id,
    };
  }

  factory StationModel.fromMap(Map<String, dynamic> map) {
    return StationModel(
      name: map['name'] as String,
      id: map['id'] != null ? map['id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StationModel.fromJson(String source) => StationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'StationModel(name: $name, id: $id)';

  @override
  bool operator ==(covariant StationModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.id == id;
  }

  @override
  int get hashCode => name.hashCode ^ id.hashCode;
}
