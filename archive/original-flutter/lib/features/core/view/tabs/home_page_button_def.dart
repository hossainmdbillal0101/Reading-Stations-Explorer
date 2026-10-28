import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageButtonModel {
  String route;
  String title;
  IconData icon;
  HomePageButtonModel({
    required this.route,
    required this.title,
    required this.icon,
  });
}

final homePageButtons = Provider<List<HomePageButtonModel>>(
  (ref) => [
    HomePageButtonModel(
      route: '/',
      title: 'Home',
      icon: Icons.home,
    ),
    HomePageButtonModel(
      route: '/search',
      title: 'Search',
      icon: Icons.search,
    ),
    HomePageButtonModel(
      route: '/profile',
      title: 'Profile',
      icon: Icons.person,
    ),
    HomePageButtonModel(
      route: '/admin',
      title: 'Admin',
      icon: Icons.admin_panel_settings,
    ),
    HomePageButtonModel(
      route: '/books',
      title: 'Books',
      icon: Icons.book,
    ),
  ],
);
