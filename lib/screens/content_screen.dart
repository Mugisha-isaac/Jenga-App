import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ContentScreen extends StatefulWidget {
  final String title;
  final String assetPath;

  const ContentScreen({
    super.key,
    required this.title,
    required this.assetPath,
  });

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  String _content = 'Loading...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final content = await rootBundle.loadString(widget.assetPath);
      setState(() {
        _content = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _content = 'Failed to load content. Please try again later.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
    );
  }
}

// Helper functions to create specific content screens
class ContentScreens {
  static Widget helpCenter() => const ContentScreen(
        title: 'Help Center',
        assetPath: 'assets/content/help_center.md',
      );

  static Widget aboutUs() => const ContentScreen(
        title: 'About Us',
        assetPath: 'assets/content/about_us.md',
      );

  static Widget privacyPolicy() => const ContentScreen(
        title: 'Privacy Policy',
        assetPath: 'assets/content/privacy_policy.md',
      );

  static Widget termsOfService() => const ContentScreen(
        title: 'Terms of Service',
        assetPath: 'assets/content/terms_of_service.md',
      );
}
