import 'package:explorer/features/books/data/book_details_model.dart';
import 'package:explorer/misc/firebase_constants.dart';
import 'package:explorer/utils/api_state.dart';
import 'package:explorer/utils/network_exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllBooksNotifier extends StateNotifier<ApiState<List<BookDetails>>> {
  AllBooksNotifier() : super(const ApiState.initial()) {
    getAllBooks();
  }

  Future<void> getAllBooks() async {
    state = const ApiState.loading();
    try {
      FBC.booksCollection.snapshots().listen((event) {
        if (event.docs.isNotEmpty) {
          final List<BookDetails> data = [];
          for (final element in event.docs) {
            final book = BookDetails.fromMap(element.data());
            if (book.bookID == null) {
              FBC.booksCollection
                  .doc(element.id)
                  .update({'bookID': element.id});
            }
            data.add(book);
          }
          debugPrint('Got ${data.length} items');
          state = ApiState.loaded(data: data);
        } else {
          state = const ApiState.loaded(data: []);
        }
      });
    } catch (e) {
      state = ApiState.error(error: NetworkExceptions.errorText(e));
    }
  }
}
