import 'package:explorer/features/core/view/tabs/home_page_button_def.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profilePageButtons = Provider<List<HomePageButtonModel>>(
  (ref) => [
    HomePageButtonModel(
      route: '/edit',
      title: 'Edit Profile',
      icon: Icons.edit_attributes,
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
