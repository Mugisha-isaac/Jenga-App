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
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),

    GetPage(
      name: Routes.welcome,
      page: () => const WelcomeScreen(),
    ),

    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingScreen(),
    ),

    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.createSolution,
      page: () => const CreateSolutionScreen(),
      binding: CreateSolutionBinding(),
    ),
    GetPage(
      name: Routes.explore,
      page: () => const ExploreScreen(),
      binding: SolutionBinding(),
    ),
    GetPage(
      name: Routes.solutionDetail,
      page: () => const SolutionDetailScreen(),
      binding: SolutionBinding(),
    ),
    GetPage(
      name: Routes.payment,
      page: () => const PaymentScreen(),
      binding: SolutionBinding(),
    ),
    // MISSING ROUTES
    GetPage(
      name: Routes.editProfile,
      page: () => const EditProfileScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.changePassword,
      page: () => const ChangePasswordScreen(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.helpCenter,
      page: () => const HelpCenterScreen(),
    ),
    GetPage(
      name: Routes.about,
      page: () => const AboutScreen(),
    ),
    // Privacy Policy screen is missing, so skip binding
    // If you add the file, update this entry
    GetPage(
      name: Routes.privacyPolicy,
      page: () => ContentScreens.privacyPolicy(),
    ),
    GetPage(
      name: Routes.termsOfService,
      page: () => ContentScreens.termsOfService(),
    ),
  ];
}
