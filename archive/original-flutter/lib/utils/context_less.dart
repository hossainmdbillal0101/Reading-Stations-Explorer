import 'package:flutter/widgets.dart';

class ContextLess {
  ContextLess._();

  /// get current context.
  static BuildContext get currentContext {
    return key.currentContext!;
  }

  static final key = GlobalKey<NavigatorState>();
}

/// `Navigator.of(context)` as `context.nav`
extension TinyContextNavigator on BuildContext {
  NavigatorState get nav {
    return Navigator.of(this);
  }
}
