import 'package:explorer/features/core/view/landing_page.dart';
import 'package:explorer/firebase_options.dart';
import 'package:explorer/misc/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting();
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return NeumorphicApp(
          title: 'Book Manager',
          home: const LandingPage(),
          supportedLocales: const [
            Locale('en'),
          ],
          localizationsDelegates: const [
            FormBuilderLocalizations.delegate,
          ],
          themeMode: ThemeMode.light,
          theme: const NeumorphicThemeData(
            baseColor: Color(0xFFE6E9FF),
            depth: 6,
          ),
          darkTheme: const NeumorphicThemeData(
            baseColor: Color(0xFF3E3E3E),
            depth: 6,
          ),
          onGenerateRoute: (settings) => generatedRoutes(settings),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
