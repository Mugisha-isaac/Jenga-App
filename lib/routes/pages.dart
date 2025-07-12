import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:jenga_app/bindings/home_binding.dart';
import 'package:jenga_app/bindings/login_binding.dart';
import 'package:jenga_app/bindings/profile_binding.dart';
import 'package:jenga_app/bindings/register_binding.dart';
import 'package:jenga_app/bindings/settings_binding.dart';
import 'package:jenga_app/bindings/splash_binding.dart';
import 'package:jenga_app/routes/routes.dart';
import 'package:jenga_app/screens/home_screen.dart';
import 'package:jenga_app/screens/login_screen.dart';
import 'package:jenga_app/screens/profile_screen.dart';
import 'package:jenga_app/screens/register_screen.dart';
import 'package:jenga_app/screens/settings_screen.dart';
import 'package:jenga_app/screens/splash_screen.dart';
import 'package:jenga_app/screens/create_solution_screen.dart';
import 'package:jenga_app/bindings/solution_binding.dart';

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
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(),
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
        binding: SolutionBinding()
    )
  ];
}
