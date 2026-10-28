import 'package:explorer/features/books/data/book_details_model.dart';
import 'package:explorer/features/books/logic/books_notifier.dart';
import 'package:explorer/utils/api_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final allBooksProvider =
    StateNotifierProvider<AllBooksNotifier, ApiState<List<BookDetails>>>((ref) {
  return AllBooksNotifier();
});

final booksProvider = StateProvider<List<BookDetails>>((ref) {
  return ref
      .watch(allBooksProvider)
      .maybeWhen(orElse: () => [], loaded: (data) => data);
});
