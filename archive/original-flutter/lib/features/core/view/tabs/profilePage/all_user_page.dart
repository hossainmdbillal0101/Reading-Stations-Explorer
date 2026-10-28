import 'package:explorer/features/core/logic/core_provider.dart';
import 'package:explorer/features/core/view/tabs/profilePage/user_auth_log.dart';
import 'package:explorer/misc/consts.dart';
import 'package:explorer/misc/routes.dart';
import 'package:explorer/misc/state_widgets.dart';
import 'package:explorer/utils/context_less.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllUsersPage extends ConsumerWidget {
  const AllUsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: NeumorphicAppBar(
          title: const Text('All Users'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ref.watch(allUserProvider).map(
                initial: (_) => const Loader(),
                loading: (_) => const Loader(),
                loaded: (value) {
                  return ListView.builder(
                    itemCount: value.data.length,
                    itemBuilder: (context, index) {
                      final user = value.data[index];
                      return GestureDetector(
                        onTap: () {
                          //Todo: navigate to Log Page
                          context.nav.pushNamed(
                            Routes.userAuthLog,
                            arguments:  AuthLogData(uid: user.uid,name: user.name) ,
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10.h),
                          child: Neumorphic(
                            padding: EdgeInsets.all(20.r),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: KEltTextStyle.blackTitleText,
                                ),
                                AppSpacerH(10.h),
                                Text(
                                  user.metric,
                                  style: KEltTextStyle.subtitleText,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                error: (_) => ErrorHandleWidget(error: _.error),
              ),
        ),
      ),
    );
  }
}
