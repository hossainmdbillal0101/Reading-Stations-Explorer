import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:explorer/features/books/data/book_details_model.dart';
import 'package:explorer/features/books/logic/books_provider.dart';
import 'package:explorer/features/books/views/widgets/book_card_small.dart';
import 'package:explorer/features/core/logic/core_provider.dart';
import 'package:explorer/misc/consts.dart';
import 'package:explorer/misc/global_functions.dart';
import 'package:explorer/misc/state_widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class HomePage extends ConsumerWidget {
  HomePage({Key? key}) : super(key: key);
  List<Widget> books = [];
  List<BookDetails> sortedBooks = [];
  List<Widget> sliders = [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stations = ref.watch(allStationsProvider);
    ref.watch(allBooksProvider).when(
      initial: () {
        books = [];
        books.add(const Loader());
      },
      loading: () {
        books = [];
        books.add(const Loader());
      },
      loaded: (_) {
        books = [];
        sortedBooks = _;
        if (sortedBooks.isNotEmpty) {
          sortedBooks.sort(
            (a, b) {
              return b.bookViews.compareTo(a.bookViews);
            },
          );
        }
        for (int i = 0;
            i < (sortedBooks.length > 10 ? 10 : sortedBooks.length);
            i++) {
          books.add(
            BookCardSmall(
              
              bookDetails: sortedBooks[i],
            ),
          );
        }
        for (int i = 0;
            i < (sortedBooks.length > 5 ? 5 : sortedBooks.length);
            i++) {
          sliders.add(
            ClipRRect(
              borderRadius: BorderRadius.circular(10.w),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                width: 320.w,
                imageUrl: sortedBooks[i].cover,
                placeholder: (context, url) => LottieBuilder.asset(
                  'assets/lotties/books.json',
                ),
                errorWidget: (context, url, error) => LottieBuilder.asset(
                  'assets/lotties/books.json',
                ),
              ),
            ),
          );
        }
      },
      error: (_) {
        books = [];
        books.add(
          ErrorHandleWidget(
            error: _,
          ),
        );
      },
    );
    return SizedBox(
      height: 640.h,
      width: 360.w,
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (sliders.isNotEmpty)
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.h,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  enlargeCenterPage: true,
                ),
                items: sliders,
              ),
            // const SizedBox(
            //   height: 20,
            // ),
            // GridView.count(
            //   crossAxisCount: 5,
            //   shrinkWrap: true,
            //   children: ref
            //       .watch(homePageButtons)
            //       .map(
            //         (e) => HomePageSmallButton(icon: e.icon),
            //       )
            //       .toList(),
            // ),
            if (books.isNotEmpty) ...[
              AppSpacerH(10.h),
              Text(
                "Top Books",
                style: KEltTextStyle.bold14black,
              )
            ],
            AppSpacerH(10.h),
            ...books,
            AppSpacerH(50.h)
          ],
        ),
      ),
    );
  }
}

class HomePageSmallButton extends StatelessWidget {
  const HomePageSmallButton({
    Key? key,
    required this.icon,
  }) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Neumorphic(
        style: KEltDecoration.boxDecoration.copyWith(
          color: KEltColor.flat[randomNumber(0, 5)],
        ),
        child: Icon(
          icon,
          size: 25.w,
        ),
      ),
    );
  }
}
