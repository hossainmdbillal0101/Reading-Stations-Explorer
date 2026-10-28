import 'package:cached_network_image/cached_network_image.dart';
import 'package:explorer/features/books/data/book_details_model.dart';
import 'package:explorer/features/core/logic/core_provider.dart';
import 'package:explorer/misc/consts.dart';
import 'package:explorer/misc/firebase_constants.dart';
import 'package:explorer/misc/global_functions.dart';
import 'package:explorer/misc/routes.dart';
import 'package:explorer/misc/state_widgets.dart';
import 'package:explorer/utils/context_less.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookCardSmall extends ConsumerWidget {
  const BookCardSmall({
    Key? key,
    required this.bookDetails,
    this.onTap,
  }) : super(key: key);
  final BookDetails bookDetails;
  final Function()? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stations = ref.watch(allStationsProvider);
    final userData = ref.watch(currentUserData);
    return GestureDetector(
      onTap: () {
        onTap?.call();
        FBC.booksCollection.doc(bookDetails.bookID).update({
          "bookViews": bookDetails.bookViews + 1,
        });
        context.nav.pushNamed(Routes.bookView, arguments: bookDetails.book);
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Row(
          children: [
            const AppSpacerW(20),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(5.h),
                decoration: BoxDecoration(
                  color: KEltColor.white,
                  borderRadius: BorderRadius.circular(10.h),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 73.h,
                      width: 120.w,
                      transform: Matrix4.translationValues(-20.w, 0, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.h),
                        child: CachedNetworkImage(
                          imageUrl: bookDetails.cover,
                          fit: BoxFit.cover,
                          height: 73.h,
                          width: 120.w,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                              value: downloadProgress.progress,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                    ),
                    AppSpacerW(10.w),
                    Expanded(
                      child: Transform(
                        transform: Matrix4.translationValues(-20.w, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    bookDetails.bookName,
                                    style: KEltTextStyle.bold14black,
                                  ),
                                ),
                                if (userData != null)
                                  GestureDetector(
                                    onTap: () {
                                      final List<String> favs =
                                          userData.favourites;
                                      if (userData.favourites
                                          .contains(bookDetails.bookID)) {
                                        favs.remove(bookDetails.bookID);
                                      } else {
                                        favs.add(bookDetails.bookID!);
                                      }
                                      FBC.usersCollection
                                          .doc(userData.uid)
                                          .update({"favourites": favs});
                                    },
                                    child: Icon(
                                      Icons.favorite,
                                      color: userData.favourites
                                              .contains(bookDetails.bookID)
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                                  )
                              ],
                            ),
                            AppSpacerH(5.h),
                            Text(
                              'Author: ${bookDetails.author}',
                              style: KEltTextStyle.normal14light,
                            ),
                            AppSpacerH(5.h),
                            Text(
                              'Edition: ${bookDetails.edition}',
                              style: KEltTextStyle.normal14light,
                            ),
                            Text(
                              'Station: ${processStation(bookDetails, stations)}',
                              style: KEltTextStyle.normal14light,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
