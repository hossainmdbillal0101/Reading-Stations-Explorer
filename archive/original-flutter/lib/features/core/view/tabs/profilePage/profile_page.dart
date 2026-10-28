import 'package:explorer/features/auth/logic/auth_provider.dart';
import 'package:explorer/features/core/logic/core_provider.dart';
import 'package:explorer/misc/consts.dart';
import 'package:explorer/misc/diaglouges.dart';
import 'package:explorer/misc/global_functions.dart';
import 'package:explorer/misc/routes.dart';
import 'package:explorer/misc/state_widgets.dart';
import 'package:explorer/utils/context_less.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    final isAdmin = ref.watch(isAdminProvider);

    return SizedBox(
      height: 640.h,
      width: 360.w,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const ProfileCard(),
                  AppSpacerH(20.h),
                  if (isAdmin) ...[
                    ProfilePageButton(
                      onTap: () {
                        context.nav.pushNamed(Routes.allStations);
                      },
                      title: 'Stations',
                      icon: Icons.settings_applications_outlined,
                    ),
                    AppSpacerH(10.h),
                    ProfilePageButton(
                      onTap: () {
                        context.nav.pushNamed(Routes.allbookRequest);
                      },
                      title: 'Pending Book Request',
                      icon: Icons.book,
                    ),
                    AppSpacerH(10.h),
                    ProfilePageButton(
                      onTap: () {
                        context.nav.pushNamed(Routes.allUsersPage);
                      },
                      title: 'Login',
                      icon: Icons.shield,
                    ),
                    AppSpacerH(10.h),
                    ProfilePageButton(
                      onTap: () {
                        bookRequestDialoug(context, _formKey);
                      },
                      title: 'Request Book',
                      icon: Icons.book,
                    ),
                    AppSpacerH(10.h),
                  ] else ...[
                    ProfilePageButton(
                      onTap: () {
                        bookRequestDialoug(context, _formKey);
                      },
                      title: 'Request Book',
                      icon: Icons.book,
                    ),
                    AppSpacerH(10.h),
                  ],
                  ProfilePageButton(
                    onTap: () {
                      context.nav.pushNamed(Routes.favourites);
                    },
                    title: 'Favourites',
                    icon: Icons.favorite_border_rounded,
                  ),
                  AppSpacerH(10.h),
                  ProfilePageButton(
                    onTap: () {
                      ref.watch(logOutProvider.notifier).logOut().then(
                            (value) => context.nav
                                .pushReplacementNamed(Routes.landing),
                          );
                    },
                    title: 'Log Out',
                    icon: Icons.logout,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 70,
            right: 30,
            child: Image.asset(
              "assets/images/CVGCM.png",
              height: 150.h,
              width: 150.h,
              fit: BoxFit.cover,
            ),
          )
        ],
      ),
    );
  }
}

class ProfilePageButton extends StatelessWidget {
  const ProfilePageButton({
    Key? key,
    required this.onTap,
    required this.title,
    required this.icon,
  }) : super(key: key);

  final Function()? onTap;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Neumorphic(
        style: KEltDecoration.boxDecoration.copyWith(
          color: KEltColor.flat[randomNumber(0, 5)],
        ),
        child: SizedBox(
          height: 50.h,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: KEltTextStyle.whiteTitleText,
                ),
                AppSpacerW(10.w),
                Icon(
                  icon,
                  size: 25.w,
                  color: KEltColor.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends ConsumerWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(currentUserData);
    return SizedBox(
      height: 120.h,
      width: 340.w,
      child: Neumorphic(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 240.w,
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData?.name ?? "Undefined",
                      style: KEltTextStyle.blackTitleText,
                    ),
                    Text(
                      userData?.email ?? "Undefined",
                      style: KEltTextStyle.subtitleText,
                    ),
                    Text(
                      "Metric : ${userData?.metric}",
                      style: KEltTextStyle.subtitleText,
                    ),
                    Text(
                      ref.watch(isAdminProvider) ? 'Admin' : 'Student',
                      style: KEltTextStyle.subtitleText,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 100.w,
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: LottieBuilder.asset(
                  'assets/lotties/person2.json',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
