import 'package:get/get.dart';
import 'package:jenga_app/screens/change_password_screen.dart';
import 'package:jenga_app/screens/edit_profile_screen.dart';
import 'package:jenga_app/screens/home_screen.dart';
import 'package:jenga_app/screens/login_screen.dart';
import 'package:jenga_app/screens/onboarding_screen.dart';
import 'package:jenga_app/screens/payment_screen.dart';
import 'package:jenga_app/screens/profile_screen.dart';
import 'package:jenga_app/screens/register_screen.dart';
import 'package:jenga_app/screens/settings_screen.dart';
import 'package:jenga_app/screens/solution_detail_screen.dart';
import 'package:jenga_app/screens/solutions_list_screen.dart';
import 'package:jenga_app/screens/create_solution_screen.dart';
import 'package:jenga_app/screens/explore_screen.dart';
import 'package:jenga_app/screens/content_screen.dart';
import 'package:jenga_app/screens/splash_screen.dart';
import 'package:jenga_app/screens/welcome_screen.dart';
import 'package:jenga_app/screens/terms_of_service_screen.dart';
import 'package:jenga_app/screens/help_center_screen.dart';
import 'package:jenga_app/screens/about_screen.dart';
import 'package:jenga_app/screens/privacy_policy_screen.dart';
import 'package:jenga_app/screens/onboarding_screen.dart';


class Routes {
  static const SPLASH = '/';
  static const String ONBOARDING = '/onboarding';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const HOME = '/home';
  static const PROFILE = '/profile';
  static const EDIT_PROFILE = '/edit-profile';
  static const CHANGE_PASSWORD = '/change-password';
  static const SETTINGS = '/settings';
  static const CONTENT = '/content';
  static const EXPLORE = '/explore';
  static const PAYMENT = '/payment';
  static const SOLUTION_DETAIL = '/solution-detail';
  static const CREATE_SOLUTION = '/create-solution';
  static const SOLUTIONS_LIST = '/solutions-list';
  static const String WELCOME = '/welcome';
  static const String HELP_CENTER = '/help-center';
  static const String ABOUT = '/about';
  static const String PRIVACY_POLICY = '/privacy-policy';
  static const String TERMS_OF_SERVICE = '/terms-of-service';
}

class AppPages {
  static final List<GetPage> routes = [
    // Auth Routes
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
      page: () => const RegisterScreen(),
    ),
    GetPage(
      name: Routes.WELCOME,
      page: () => const WelcomeScreen(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingScreen(),
    ),
    // Main App Routes
    GetPage(
      name: Routes.HOME,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: Routes.SETTINGS,
      page: () => const SettingsScreen(),
    ),
    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => const EditProfileScreen(),
    ),
    GetPage(
      name: Routes.CHANGE_PASSWORD,
      page: () => const ChangePasswordScreen(),
    ),

    // Solution Routes
    GetPage(
      name: Routes.SOLUTIONS_LIST,
      page: () => const SolutionsListScreen(),
    ),
    GetPage(
      name: Routes.CREATE_SOLUTION,
      page: () => const CreateSolutionScreen(),
    ),
    GetPage(
      name: Routes.EXPLORE,
      page: () => const ExploreScreen(),
    ),
    GetPage(
      name: Routes.SOLUTION_DETAIL,
      page: () => const SolutionDetailScreen(),
    ),
    GetPage(
      name: Routes.PAYMENT,
      page: () => const PaymentScreen(),
    ),

    // Info & Support Routes
    GetPage(
      name: Routes.HELP_CENTER,
      page: () => const HelpCenterScreen(),
    ),
    GetPage(
      name: Routes.ABOUT,
      page: () => const AboutScreen(),
    ),
    GetPage(
      name: Routes.PRIVACY_POLICY,
      page: () => const PrivacyPolicyScreen(),
    ),
    GetPage(
      name: Routes.TERMS_OF_SERVICE,
      page: () => const TermsOfServiceScreen(),
    ),
  ];
}