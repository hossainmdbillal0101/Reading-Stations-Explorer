import 'package:explorer/features/auth/view/login_page.dart';
import 'package:explorer/features/core/view/main_page.dart';
import 'package:explorer/misc/state_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        return snapshot.hasError
            ? const ErrorHandleWidget(
                error: "Something Went Wrong",
              )
            : snapshot.connectionState == ConnectionState.active
                ? snapshot.hasData
                    ? const MainPage()
                    : LoginPage()
                : const Loader();
      },
    );
  }
}
