import 'package:get/get.dart';
import 'package:jenga_app/bindings/auth_binding.dart';
import 'package:jenga_app/bindings/create_solution_binding.dart';
import 'package:jenga_app/bindings/home_binding.dart';
import 'package:jenga_app/bindings/profile_binding.dart';
import 'package:jenga_app/bindings/settings_binding.dart';
import 'package:jenga_app/bindings/solution_binding.dart';
import 'package:jenga_app/bindings/splash_binding.dart';
import 'package:jenga_app/routes/routes.dart';
import 'package:jenga_app/screens/content_screen.dart';
import 'package:jenga_app/screens/create_solution_screen.dart';
import 'package:jenga_app/screens/explore_screen.dart';
import 'package:jenga_app/screens/home_screen.dart';
import 'package:jenga_app/screens/login_screen.dart';
import 'package:jenga_app/screens/onboarding_screen.dart';
import 'package:jenga_app/screens/payment_screen.dart';
import 'package:jenga_app/screens/profile_screen.dart';
import 'package:jenga_app/screens/register_screen.dart';
import 'package:jenga_app/screens/settings_screen.dart';
import 'package:jenga_app/screens/solution_detail_screen.dart';
import 'package:jenga_app/screens/splash_screen.dart';
import 'package:jenga_app/screens/welcome_screen.dart';
import 'package:jenga_app/screens/edit_profile_screen.dart';
import 'package:jenga_app/screens/change_password_screen.dart';
import 'package:jenga_app/screens/help_center_screen.dart';
import 'package:jenga_app/screens/about_screen.dart';


class Pages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),

    GetPage(
      name: Routes.WELCOME,
      page: () => const WelcomeScreen(),
    ),

    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingScreen(),
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
    // MISSING ROUTES
    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => const EditProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.CHANGE_PASSWORD,
      page: () => const ChangePasswordScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.HELP_CENTER,
      page: () => const HelpCenterScreen(),
    ),
    GetPage(
      name: Routes.ABOUT,
      page: () => const AboutScreen(),
    ),
    // Privacy Policy screen is missing, so skip binding
    // If you add the file, update this entry
    GetPage(
      name: Routes.PRIVACY_POLICY,
      page: () => ContentScreens.privacyPolicy(),
    ),
    GetPage(
      name: Routes.TERMS_OF_SERVICE,
      page: () => ContentScreens.termsOfService(),
    ),
  ];
}
