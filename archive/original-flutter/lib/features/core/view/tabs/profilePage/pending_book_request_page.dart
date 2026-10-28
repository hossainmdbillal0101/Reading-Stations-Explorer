import 'package:explorer/features/core/logic/core_provider.dart';
import 'package:explorer/features/core/view/tabs/home_page.dart';
import 'package:explorer/misc/consts.dart';
import 'package:explorer/misc/diaglouges.dart';
import 'package:explorer/misc/state_widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllBookRequests extends ConsumerWidget {
  AllBookRequests({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(allBookRequestProvider);
    if (books.isNotEmpty) {
      books.sort(
        (a, b) {
          return a.status.compareTo(b.status);
        },
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: NeumorphicAppBar(
          title: const Text('All Book Requests'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                if (books[index].status == 0) {
                  addBookDialoug(
                    context,
                    _formKey,
                    ref.watch(allStationsProvider),
                    books[index],
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: Neumorphic(
                  padding: EdgeInsets.all(20.r),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${books[index].bookName} ${books[index].edition}",
                              style: KEltTextStyle.blackTitleText,
                            ),
                            AppSpacerH(10.h),
                            Text(
                              books[index].author,
                              style: KEltTextStyle.subtitleText,
                            ),
                          ],
                        ),
                      ),
                      AppSpacerW(10.w),
                      Text(
                        books[index].status == 0 ? "Pending" : "Accepted",
                        style: KEltTextStyle.subtitleText,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: GestureDetector(
          onTap: () {
            addBookDialoug(
              context,
              _formKey,
              ref.watch(allStationsProvider),
              null,
            );
          },
          child: const HomePageSmallButton(
            icon: Icons.add,
          ),
        ),
      ),
    );
  }
}
