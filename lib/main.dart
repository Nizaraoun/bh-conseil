import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:my_bh/core/themes/color_mangers.dart';
import 'generated/l10n.dart';
import 'routes/app_routing.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      darkTheme: ThemeData.dark(),

      locale: const Locale('an'), // Set the locale to Arabic for RTL

      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: S.delegate.supportedLocales,

      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        scaffoldBackgroundColor: ColorManager.scaffoldbg,
        useMaterial3: true,
      ),

      initialRoute: AppRoutes.homepage,

      getPages: AppRoutes().appRoutes,

      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.ltr, // Set text direction to RTL

          child: child!,
        );
      },
    );
  }
}
