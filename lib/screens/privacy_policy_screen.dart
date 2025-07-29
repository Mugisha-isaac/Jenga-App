import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
            const Text(
              'Last Updated: July 29, 2025',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              '1. Information We Collect',
              'To provide our knowledge-sharing platform, we collect:\n\n'
              '• Account information for community participation\n'
              '• Location data to connect users with relevant local solutions\n'
              '• Content you share about local innovations and solutions\n'
              '• Usage data to improve our platform\'s effectiveness',
            ),
            _buildSection(
              '2. How We Use Your Information',
              'We use the information we collect to:\n\n'
              '• Connect community members with relevant local solutions\n'
              '• Improve and personalize your experience on our platform\n'
              '• Facilitate collaboration between users\n'
              '• Analyze usage patterns to enhance our services\n'
              '• Comply with legal obligations',
            ),
            _buildSection(
              '3. Information Sharing',
              'We may share your information with:\n\n'
              '• Other community members (as part of your public profile)\n'
              '• Service providers who assist in platform operations\n'
              '• Authorities when required by law or to protect rights\n\n'
              'We never sell your personal information to third parties.',
            ),
            _buildSection(
              '4. Data Security',
              'We implement appropriate security measures to protect your information, including:\n\n'
              '• Secure server infrastructure\n'
              '• Data encryption in transit and at rest\n'
              '• Regular security audits\n'
              '• Access controls and authentication',
            ),
            _buildSection(
              '5. Your Rights',
              'You have the right to:\n\n'
              '• Access and receive a copy of your personal data\n'
              '• Request correction of inaccurate information\n'
              '• Request deletion of your data\n'
              '• Withdraw consent for data processing\n\n'
              'To exercise these rights, please contact us at privacy@jenga.rw',
            ),
            const SizedBox(height: 24),
            const Text(
              'For any questions about our privacy practices, please contact us at privacy@jenga.rw',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}