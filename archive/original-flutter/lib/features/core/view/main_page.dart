import 'package:explorer/features/books/logic/books_provider.dart';
import 'package:explorer/features/core/logic/core_provider.dart';
import 'package:explorer/features/core/view/tabs/home_page.dart';
import 'package:explorer/features/core/view/tabs/profilePage/profile_page.dart';
import 'package:explorer/features/core/view/tabs/search_page.dart';
import 'package:explorer/misc/consts.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  @override
  void initState() {
    super.initState();
    ref.refresh(allBooksProvider);
    ref.refresh(adminListProvider);
    ref.refresh(stationsProvider);
    ref.refresh(allbookRequestProvider);
    ref.refresh(isAdminProvider);
    ref.refresh(currentUserProvider);
    ref.refresh(currentUserData);
  }

  @override
  Widget build(BuildContext context) {
    final bottomIndex = ref.watch(bottomBarIndex);
    final bottomIndexM =
        ref.watch(bottomBarIndex.notifier); //M stands for Mutable
    ref.watch(allBooksProvider);
    final pageViewController = ref.watch(bottomPageController);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              child: SizedBox(
                height: 640.h,
                width: 360.w,
                child: PageView(
                  controller: pageViewController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    bottomIndexM.state = index;
                  },
                  children: [
                    HomePage(),
                    const SearchPage(),
                    const ProfilePage(),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: SizedBox(
                height: 60.h,
                width: 360.w,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Neumorphic(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BottomBarIcon(
                            onTap: () {
                              bottomIndexM.state = 0;
                              pageViewController.animateToPage(
                                0,
                                curve: Curves.easeInCubic,
                                duration: const Duration(milliseconds: 500),
                              );
                            },
                            icon: Icons.home,
                            isActive: bottomIndex == 0,
                          ),
                          BottomBarIcon(
                            onTap: () {
                              bottomIndexM.state = 1;
                              pageViewController.animateToPage(
                                1,
                                curve: Curves.easeInCubic,
                                duration: const Duration(milliseconds: 500),
                              );
                            },
                            icon: Icons.search,
                            isActive: bottomIndex == 1,
                          ),
                          BottomBarIcon(
                            onTap: () {
                              bottomIndexM.state = 2;
                              pageViewController.animateToPage(
                                2,
                                curve: Curves.easeInCubic,
                                duration: const Duration(milliseconds: 500),
                              );
                            },
                            icon: Icons.person,
                            isActive: bottomIndex == 2,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BottomBarIcon extends StatelessWidget {
  const BottomBarIcon({
    Key? key,
    required this.icon,
    this.onTap,
    this.isActive = false,
  }) : super(key: key);
  final IconData icon;
  final Function()? onTap;
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 26.w,
        color: isActive ? KEltColor.primary : KEltColor.txt,
      ),
    );
  }
}
