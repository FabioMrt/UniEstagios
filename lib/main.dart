import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:uniestagios/app_bindings.dart';
import 'package:uniestagios/routes/app_pages.dart';
import 'package:uniestagios/routes/app_routes.dart';
import 'package:uniestagios/theme.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyC_PiR9sRwVY3MBTQm8YUhSJiFWA1ghhrU",
      authDomain: "uniestagios-343a1.firebaseapp.com",
      projectId: "uniestagios-343a1",
      storageBucket: "uniestagios-343a1.appspot.com",
      messagingSenderId: "557868574089",
      appId: "1:557868574089:web:eb1953aee4af13b42ded58",
    ),
  );
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Poppins',
              primaryColor: kPrimaryColor,
            ),
            initialRoute: Routes.SPLASH,
            initialBinding: AppBindings(),
            getPages: AppPages.routes,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('pt', 'BR'),
            ],
          );
        }
        return Container();
      },
    );
  }
}
