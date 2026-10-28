import 'package:explorer/features/books/data/book_details_model.dart';
import 'package:explorer/features/books/logic/books_provider.dart';
import 'package:explorer/features/books/views/widgets/book_card_small.dart';
import 'package:explorer/features/core/logic/core_provider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavouritesPage extends ConsumerWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<BookDetails> favBooks = [];
    final userData = ref.watch(currentUserData);
    final allBooks = ref.watch(booksProvider);

    if (userData != null &&
        userData.favourites.isNotEmpty &&
        allBooks.isNotEmpty) {
      for (final element in userData.favourites) {
        for (final element2 in allBooks) {
          if (element2.bookID == element) {
            favBooks.add(element2);
          }
        }
      }
    }

    return SafeArea(
      child: Scaffold(
        appBar: NeumorphicAppBar(
          title: const Text('Favourites'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView.builder(
            itemCount: favBooks.length,
            itemBuilder: (context, index) => BookCardSmall(
              bookDetails: favBooks[index],
            ),
          ),
        ),
      ),
    );
  }
}
