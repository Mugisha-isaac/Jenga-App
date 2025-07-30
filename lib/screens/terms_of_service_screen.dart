import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
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
              '1. Acceptance of Terms',
              'By accessing or using the Jenga platform, you agree to be bound by these Terms of Service. Jenga is a technology platform that enables Rwandans to document, share, and discover local solutions and innovations.',
            ),
            _buildSection(
              '2. User Responsibilities',
              'As a user of Jenga, you agree to:\n\n'
              '• Share accurate and helpful information about local solutions\n'
              '• Respect intellectual property rights when posting content\n'
              '• Maintain the confidentiality of your account credentials\n'
              '• Use the platform in a manner that promotes community development',
            ),
            _buildSection(
              '3. Content Ownership',
              'Users retain ownership of the content they create and share on Jenga. By posting content, you grant Jenga a non-exclusive, royalty-free license to use, modify, and display such content in connection with the platform.',
            ),
            _buildSection(
              '4. Community Guidelines',
              'Jenga is committed to fostering a positive community. Prohibited activities include:\n\n'
              '• Posting harmful or misleading information\n'
              '• Engaging in harassment or discrimination\n'
              '• Violating any applicable laws or regulations\n'
              '• Attempting to compromise platform security',
            ),
            _buildSection(
              '5. Limitation of Liability',
              'Jenga is provided "as is" without warranties of any kind. We are not responsible for the accuracy or reliability of user-generated content. Users are encouraged to verify information before implementation.',
            ),
            const SizedBox(height: 24),
            const Text(
              'For any questions about these Terms of Service, please contact us at support@jenga.rw',
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