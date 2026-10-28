// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BookDetails {
  String cover;
  String book;
  String author;
  String edition;
  int time;
  int bookViews;
  String bookName;
  String stationID;
  String? bookID;
  BookDetails({
    required this.cover,
    required this.book,
    required this.author,
    required this.edition,
    required this.time,
    required this.bookViews,
    required this.bookName,
    required this.stationID,
    this.bookID,
  });

  BookDetails copyWith({
    String? cover,
    String? book,
    String? author,
    String? edition,
    int? time,
    int? bookViews,
    String? bookName,
    String? stationID,
    String? bookID,
  }) {
    return BookDetails(
      cover: cover ?? this.cover,
      book: book ?? this.book,
      author: author ?? this.author,
      edition: edition ?? this.edition,
      time: time ?? this.time,
      bookViews: bookViews ?? this.bookViews,
      bookName: bookName ?? this.bookName,
      stationID: stationID ?? this.stationID,
      bookID: bookID ?? this.bookID,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cover': cover,
      'book': book,
      'author': author,
      'edition': edition,
      'time': time,
      'bookViews': bookViews,
      'bookName': bookName,
      'stationID': stationID,
      'bookID': bookID,
    };
  }

  factory BookDetails.fromMap(Map<String, dynamic> map) {
    return BookDetails(
      cover: map['cover'] as String,
      book: map['book'] as String,
      author: map['author'] as String,
      edition: map['edition'] as String,
      time: map['time'] as int,
      bookViews: map['bookViews'] as int,
      bookName: map['bookName'] as String,
      stationID: map['stationID'] as String,
      bookID: map['bookID'] != null ? map['bookID'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BookDetails.fromJson(String source) =>
      BookDetails.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BookDetails(cover: $cover, book: $book, author: $author, edition: $edition, time: $time, bookViews: $bookViews, bookName: $bookName, stationID: $stationID, bookID: $bookID)';
  }

  @override
  bool operator ==(covariant BookDetails other) {
    if (identical(this, other)) return true;
  
    return 
      other.cover == cover &&
      other.book == book &&
      other.author == author &&
      other.edition == edition &&
      other.time == time &&
      other.bookViews == bookViews &&
      other.bookName == bookName &&
      other.stationID == stationID &&
      other.bookID == bookID;
  }

  @override
  int get hashCode {
    return cover.hashCode ^
      book.hashCode ^
      author.hashCode ^
      edition.hashCode ^
      time.hashCode ^
      bookViews.hashCode ^
      bookName.hashCode ^
      stationID.hashCode ^
      bookID.hashCode;
  }
}
