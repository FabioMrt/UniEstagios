import 'package:uniestagios/screens/enterprise/enterprise_page.dart';
import 'package:uniestagios/screens/login/login.dart';
import 'package:uniestagios/screens/onboarding/onboarding_screen.dart';
import 'package:uniestagios/screens/profileUser/user_info_page.dart';
import 'package:uniestagios/screens/signup/enterprise/enterprise_signup.dart';
import 'package:uniestagios/screens/signup/intern/intern_signup.dart';
import 'package:uniestagios/screens/signup/intern/intern_signup_2.dart';
import 'package:uniestagios/screens/signup/signup.dart';
import 'package:uniestagios/screens/splash/splash_page.dart';
import 'package:get/get.dart';

import '../components/nav.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashPage(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => Nav(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => LogInScreen(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => SignUpScreen(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => Onboarding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfilePage(),
    ),
    GetPage(
      name: Routes.INTERNSIGNUP,
      page: () => InternSignUp(),
    ),
    GetPage(
      name: Routes.INTERNSECONDSIGNUP,
      page: () => InternSecondSignUp(),
    ),
    GetPage(
      name: Routes.ENTERPRISESIGNUP,
      page: () => EnterpriseSignUp(),
    ),
    GetPage(
      name: Routes.ENTERPRISE,
      page: () => EnterprisePage(),
    ),
  ];
}
