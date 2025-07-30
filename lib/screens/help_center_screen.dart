import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jenga_app/themes/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Frequently Asked Questions'),
            _buildFaqItem(
              'How do I share a local solution?',
              'Tap the "+" button on the home screen to document and share a local solution. Include clear details and images to help others understand and implement it.',
            ),
            _buildFaqItem(
              'How can I find solutions in my area?',
              'Use the search function with relevant keywords or browse by category. You can also filter solutions by location to find innovations near you.',
            ),
            _buildFaqItem(
              'Is there a way to collaborate with other users?',
              'Yes! You can connect with other innovators through the platform, share feedback, and even collaborate on improving existing solutions.',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Contact Us'),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email Support'),
              subtitle: const Text('support@jenga.rw'),
              onTap: () => _launchEmail(),
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Call Support'),
              subtitle: const Text('+250 790 801 369'),
              onTap: () => _launchPhoneCall(),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('Visit Our Office'),
            const ListTile(
              leading: Icon(Icons.location_on),
              title: Text('Kigali Innovation City'),
              subtitle: Text('KG 7 Ave, Kigali, Rwanda'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(answer),
          ),
        ],
      ),
    );
  }

  void _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@jenga.rw',
      queryParameters: {'subject': 'Jenga App Support'},
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }

  void _launchPhoneCall() async {
    final Uri phoneLaunchUri = Uri(
      scheme: 'tel',
      path: '+250790801369',
    );
    if (await canLaunchUrl(phoneLaunchUri)) {
      await launchUrl(phoneLaunchUri);
    }
  }
}