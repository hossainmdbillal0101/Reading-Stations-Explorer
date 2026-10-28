import 'package:explorer/features/books/data/book_details_model.dart';
import 'package:explorer/features/books/logic/books_provider.dart';
import 'package:explorer/features/books/views/widgets/book_card_small.dart';
import 'package:explorer/features/core/logic/core_provider.dart';
import 'package:explorer/misc/consts.dart';
import 'package:explorer/misc/global_functions.dart';
import 'package:explorer/misc/state_widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  List<BookDetails> books = [];
  @override
  Widget build(BuildContext context) {
    final List<BookDetails> allBooks = ref.watch(booksProvider);
    final stations = ref.watch(allStationsProvider);
    return SizedBox(
      height: 640.h,
      width: 360.w,
      child: Column(
        children: [
          AppSpacerH(20.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Neumorphic(
              style: KEltDecoration.innerShadow,
              child: TextField(
                decoration: KEltInputDecoration.inputDecoration.copyWith(
                  hintText: 'Type to search',
                  suffixIcon: const Icon(Icons.search),
                ),
                onChanged: (value) {
                  books = allBooks;
                  if (value != '') {
                    setState(() {
                      books = books
                          .where(
                            (element) => element.bookName
                                .toLowerCase()
                                .contains(value.toLowerCase()),
                          )
                          .toList();
                    });
                  } else {
                    setState(() {
                      books = allBooks;
                    });
                  }
                },
              ),
            ),
          ),
          AppSpacerH(20.h),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return BookCardSmall(
                  onTap: () {
                    EasyLoading.showSuccess(
                      "${book.bookName} is On Station ${processStation(book, stations)}",
                    );
                  },
                  bookDetails: book,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
