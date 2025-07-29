import 'package:get/get.dart';
import 'package:jenga_app/screens/change_password_screen.dart';
import 'package:jenga_app/screens/edit_profile_screen.dart';
import 'package:jenga_app/screens/home_screen.dart';
import 'package:jenga_app/screens/login_screen.dart';
import 'package:jenga_app/screens/profile_screen.dart';
import 'package:jenga_app/screens/register_screen.dart';
import 'package:jenga_app/screens/settings_screen.dart';
import 'package:jenga_app/screens/splash_screen.dart';


class Routes {
  static const SPLASH = '/';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const HOME = '/home';
  static const PROFILE = '/profile';
  static const EDIT_PROFILE = '/edit-profile';
  static const CHANGE_PASSWORD = '/change-password';
  static const SETTINGS = '/settings';
  static const CONTENT = '/content';
  static const EXPLORE = '/explore';
  static const SOLUTION_DETAIL = '/solution-detail';
  static const CREATE_SOLUTION = '/create-solution';
}

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterScreen(), 
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => const EditProfileScreen(),
    ),
    GetPage(
      name: Routes.CHANGE_PASSWORD,
      page: () => const ChangePasswordScreen(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsScreen(),
    ),
  ];
}
