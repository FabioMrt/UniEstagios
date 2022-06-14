import 'package:uniestagios/components/enterprise_nav.dart';
import 'package:uniestagios/screens/candidate_cv/candidate_cv_page.dart';
import 'package:uniestagios/screens/candidate_register/candidate_register_page.dart';
import 'package:uniestagios/screens/enterprise/candidate_view.dart';
import 'package:uniestagios/screens/job_register/job_register_page.dart';
import 'package:uniestagios/screens/login/login.dart';
import 'package:uniestagios/screens/onboarding/onboarding_screen.dart';
import 'package:uniestagios/screens/signup/enterprise/enterprise_signup.dart';
import 'package:uniestagios/screens/signup/enterprise/enterprise_signup_2.dart';
import 'package:uniestagios/screens/signup/intern/intern_signup.dart';
import 'package:uniestagios/screens/signup/intern/intern_signup_2.dart';
import 'package:uniestagios/screens/signup/signup.dart';
import 'package:uniestagios/screens/splash/splash_page.dart';
import 'package:get/get.dart';

import '../components/intern_nav.dart';
import '../screens/forgot_password/forgot_password_page.dart';
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
      name: Routes.INTERNSIGNUP,
      page: () => InternSignUp(),
    ),
    GetPage(
      name: Routes.INTERNSECONDSIGNUP,
      page: () => InternSecondSignUp(),
    ),
    GetPage(
      name: Routes.ENTERPRISESECONDSIGNUP,
      page: () => EnterpriseSecondSignUp(),
    ),
    GetPage(
      name: Routes.ENTERPRISESIGNUP,
      page: () => EnterpriseSignUp(),
    ),
    GetPage(
      name: Routes.ENTERPRISE,
      page: () => EnterpriseNav(),
    ),
    GetPage(
      name: Routes.JOBREGISTER,
      page: () => JobRegisterPage(),
    ),
    GetPage(
      name: Routes.CANDIDATEREGISTER,
      page: () => CandidateRegisterPage(),
    ),
    GetPage(
      name: Routes.CANDIDATECV,
      page: () => CandidateCvPage(),
    ),
    GetPage(
      name: Routes.CANDIDATEVIEW,
      page: () => CandidateView(),
    ),
    GetPage(
      name: Routes.FORGOTPASSWORD,
      page: () => ForgotPasswordPage(),
    ),
  ];
}
