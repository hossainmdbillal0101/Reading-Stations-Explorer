// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BookRequestModel {
  String author;
  String edition;
  String bookName;
  int status;
  String? requestID;
  BookRequestModel({
    required this.author,
    required this.edition,
    required this.bookName,
    required this.status,
    this.requestID,
  });

  BookRequestModel copyWith({
    String? author,
    String? edition,
    String? bookName,
    int? status,
    String? requestID,
  }) {
    return BookRequestModel(
      author: author ?? this.author,
      edition: edition ?? this.edition,
      bookName: bookName ?? this.bookName,
      status: status ?? this.status,
      requestID: requestID ?? this.requestID,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'author': author,
      'edition': edition,
      'bookName': bookName,
      'status': status,
      'requestID': requestID,
    };
  }

  factory BookRequestModel.fromMap(Map<String, dynamic> map) {
    return BookRequestModel(
      author: map['author'] as String,
      edition: map['edition'] as String,
      bookName: map['bookName'] as String,
      status: map['status'] as int,
      requestID: map['requestID'] != null ? map['requestID'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookRequestModel.fromJson(String source) => BookRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BookRequestModel(author: $author, edition: $edition, bookName: $bookName, status: $status, requestID: $requestID)';
  }

  @override
  bool operator ==(covariant BookRequestModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.author == author &&
      other.edition == edition &&
      other.bookName == bookName &&
      other.status == status &&
      other.requestID == requestID;
  }

  @override
  int get hashCode {
    return author.hashCode ^
      edition.hashCode ^
      bookName.hashCode ^
      status.hashCode ^
      requestID.hashCode;
  }
}
