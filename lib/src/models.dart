class Station {
  final String id, name, location;
  const Station(this.id, this.name, this.location);
  Map<String, dynamic> toJson() => {'name': name, 'location': location};
  factory Station.fromJson(String id, Map<String, dynamic> data) =>
      Station(id, data['name'] as String, data['location'] as String);
}

class ReadingBook {
  final String id, title, author, category, stationId, description, url;
  final bool available;
  const ReadingBook(
      {required this.id,
      required this.title,
      required this.author,
      required this.category,
      required this.stationId,
      required this.description,
      this.url = '',
      this.available = true});
  Map<String, dynamic> toJson() => {
        'title': title,
        'author': author,
        'category': category,
        'stationId': stationId,
        'description': description,
        'url': url,
        'available': available
      };
  factory ReadingBook.fromJson(String id, Map<String, dynamic> d) =>
      ReadingBook(
          id: id,
          title: d['title'] as String,
          author: d['author'] as String,
          category: d['category'] as String,
          stationId: d['stationId'] as String,
          description: d['description'] as String,
          url: d['url'] as String? ?? '',
          available: d['available'] as bool? ?? true);
}

class MaterialRequest {
  final String id, userId, title, author, type, status;
  const MaterialRequest(
      {required this.id,
      required this.userId,
      required this.title,
      required this.author,
      required this.type,
      this.status = 'pending'});
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'title': title,
        'author': author,
        'type': type,
        'status': status
      };
  factory MaterialRequest.fromJson(String id, Map<String, dynamic> d) =>
      MaterialRequest(
          id: id,
          userId: d['userId'] as String,
          title: d['title'] as String,
          author: d['author'] as String,
          type: d['type'] as String,
          status: d['status'] as String);
}

const demoStations = [
  Station('station-1', 'Central reading room',
      'Sample location · Main academic building'),
  Station('station-2', 'Science corner', 'Sample location · Science building'),
  Station(
      'station-3', 'Garden reading station', 'Sample location · Campus garden'),
];
const demoBooks = [
  ReadingBook(
      id: 'book-1',
      title: 'Pride and Prejudice',
      author: 'Jane Austen',
      category: 'Literature',
      stationId: 'station-1',
      description:
          'A classic novel of first impressions, family, and finding understanding. Sample catalogue entry.',
      url: 'https://www.gutenberg.org/ebooks/1342'),
  ReadingBook(
      id: 'book-2',
      title: 'A Brief Guide to Astronomy',
      author: 'Demo editorial team',
      category: 'Science',
      stationId: 'station-2',
      description:
          'An illustrative catalogue entry about observing the night sky. No digital book is bundled.'),
  ReadingBook(
      id: 'book-3',
      title: 'The Adventures of Sherlock Holmes',
      author: 'Arthur Conan Doyle',
      category: 'Literature',
      stationId: 'station-3',
      description:
          'Twelve adventures featuring the consulting detective. Sample catalogue entry.',
      url: 'https://www.gutenberg.org/ebooks/1661'),
  ReadingBook(
      id: 'book-4',
      title: 'Introduction to Algorithms',
      author: 'Demo editorial team',
      category: 'Technology',
      stationId: 'station-2',
      description:
          'A fictional introductory reading guide for exploring computational thinking.',
      available: false),
  ReadingBook(
      id: 'book-5',
      title: 'Campus Stories',
      author: 'Demo writing circle',
      category: 'Community',
      stationId: 'station-3',
      description:
          'A fictional collection celebrating reading and sharing stories across campus.'),
  ReadingBook(
      id: 'book-6',
      title: 'Learning to Learn',
      author: 'Demo study group',
      category: 'Study skills',
      stationId: 'station-1',
      description:
          'An illustrative reading entry about curiosity, habits, and independent study.'),
];
