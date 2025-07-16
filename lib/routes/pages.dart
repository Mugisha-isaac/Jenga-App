import 'package:get/get.dart';
import 'package:jenga_app/bindings/auth_binding.dart';
import 'package:jenga_app/bindings/create_solution_binding.dart';
import 'package:jenga_app/bindings/home_binding.dart';
import 'package:jenga_app/bindings/profile_binding.dart';
import 'package:jenga_app/bindings/settings_binding.dart';
import 'package:jenga_app/bindings/solution_binding.dart';
import 'package:jenga_app/bindings/splash_binding.dart';
import 'package:jenga_app/routes/routes.dart';
import 'package:jenga_app/screens/create_solution_screen.dart';
import 'package:jenga_app/screens/explore_screen.dart';
import 'package:jenga_app/screens/home_screen.dart';
import 'package:jenga_app/screens/login_screen.dart';
import 'package:jenga_app/screens/payment_screen.dart';
import 'package:jenga_app/screens/profile_screen.dart';
import 'package:jenga_app/screens/register_screen.dart';
import 'package:jenga_app/screens/settings_screen.dart';
import 'package:jenga_app/screens/solution_detail_screen.dart';
import 'package:jenga_app/screens/splash_screen.dart';

class Pages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.CREATE_SOLUTION,
      page: () => const CreateSolutionScreen(),
      binding: CreateSolutionBinding(),
    ),
    GetPage(
      name: Routes.EXPLORE,
      page: () => const ExploreScreen(),
      binding: SolutionBinding(),
    ),
    GetPage(
      name: Routes.SOLUTION_DETAIL,
      page: () => const SolutionDetailScreen(),
      binding: SolutionBinding(),
    ),
    GetPage(
      name: Routes.PAYMENT,
      page: () => const PaymentScreen(),
      binding: SolutionBinding(),
    ),
  ];
}
