import 'package:explorer/features/auth/view/sign_up_page.dart';
import 'package:explorer/features/books/views/book_view.dart';
import 'package:explorer/features/core/view/landing_page.dart';
import 'package:explorer/features/core/view/tabs/profilePage/all_user_page.dart';
import 'package:explorer/features/core/view/tabs/profilePage/favourites_page.dart';
import 'package:explorer/features/core/view/tabs/profilePage/pending_book_request_page.dart';
import 'package:explorer/features/core/view/tabs/profilePage/stations_page.dart';
import 'package:explorer/features/core/view/tabs/profilePage/user_auth_log.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  Routes._();

  static const splash = '/splashScreen';
  static const landing = '/'; //'/loginPage';
  static const signUp = '/signUpPage';
  static const allStations = '/allStations';
  static const allbookRequest = '/allbookRequest';
  static const bookView = '/bookView';
  static const favourites = '/favourites';
  static const allUsersPage = '/allUsersPage';
  static const userAuthLog = '/userAuthLog';
}

Route generatedRoutes(RouteSettings settings) {
  Widget child;
  switch (settings.name) {
    case Routes.landing:
      child = const LandingPage();
      break;
    case Routes.signUp:
      child = const SignUpPage();
      break;
    case Routes.allStations:
      child = AllStations();
      break;
    case Routes.allbookRequest:
      child = AllBookRequests();
      break;

    case Routes.bookView:
      child = BookView(
        bookurl: settings.arguments! as String,
      );
      break;
    case Routes.favourites:
      child = const FavouritesPage();
      break;
    case Routes.allUsersPage:
      child = const AllUsersPage();
      break;
    case Routes.userAuthLog:
      child = UserAuthLogPage(
        userData: settings.arguments! as AuthLogData,
      );
      break;

    default:
      throw Exception('Invalid route: ${settings.name}');
  }
  return PageTransition(
    child: child,
    type: PageTransitionType.scale,
    settings: settings,
    alignment: Alignment.bottomRight,
    duration: const Duration(milliseconds: 500),
    reverseDuration: const Duration(milliseconds: 500),
  );
}
