import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:jenga_app/firebase_options.dart';
import 'package:jenga_app/routes/pages.dart';
import 'package:jenga_app/routes/routes.dart';
import 'package:jenga_app/services/dependency_injection.dart';
import 'package:jenga_app/themes/app_theme.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await DependencyInjection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Jenga App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: Routes.SOLUTIONS_LIST,
      getPages: Pages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
