import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/solution_controller.dart';
import '../models/solution.dart';
import '../routes/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SolutionController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Jenga',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            const SizedBox(height: 24),
            _buildFeaturedSolutions(controller),
            const SizedBox(height: 32),
            _buildTrendingTopics(controller),
            const SizedBox(height: 32),
            _buildRecentSolutions(controller),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.EXPLORE);
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.shade200),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.green.shade700),
            const SizedBox(width: 12),
            Text(
              'Search solutions',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedSolutions(SolutionController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Featured Solutions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: Obx(() {
            // Filter featured solutions
            final featuredSolutions = controller.solutions
                .where((solution) => solution.featured)
                .take(5)
                .toList();

            if (featuredSolutions.isEmpty) {
              return const Center(
                child: Text(
                  'No featured solutions yet',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: featuredSolutions.length,
              itemBuilder: (context, index) {
                final solution = featuredSolutions[index];
                return _buildFeaturedCard(solution);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard(Solution solution) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.SOLUTION_DETAIL, arguments: solution);
      },
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background Image
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: solution.images.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(solution.images.first.url),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: solution.images.isEmpty ? Colors.grey.shade300 : null,
                ),
                child: solution.images.isEmpty
                    ? const Center(
                        child: Icon(
                          Icons.lightbulb_outline,
                          size: 60,
                          color: Colors.grey,
                        ),
                      )
                    : null,
              ),
              // Gradient Overlay
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),
              // Content
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        solution.category.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      solution.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      solution.description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrendingTopics(SolutionController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Trending Topics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          // Get trending solutions (non-featured solutions)
          final trendingSolutions = controller.solutions
              .where((solution) => !solution.featured)
              .take(5)
              .toList();

          if (trendingSolutions.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'No trending solutions yet',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          // Get unique categories from trending solutions
          final categories = trendingSolutions
              .map((solution) => solution.category)
              .toSet()
              .toList();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to explore with category filter
                    Get.toNamed(
                      Routes.EXPLORE,
                      arguments: {'category': category},
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRecentSolutions(SolutionController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Recent Solutions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          // Get recent solutions (sorted by creation date)
          final recentSolutions = controller.solutions.toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (recentSolutions.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'No recent solutions yet',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recentSolutions.take(3).length,
            itemBuilder: (context, index) {
              final solution = recentSolutions[index];
              return _buildRecentSolutionCard(solution);
            },
          );
        }),
      ],
    );
  }

  Widget _buildRecentSolutionCard(Solution solution) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.SOLUTION_DETAIL, arguments: solution);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.green.shade100,
                image: solution.images.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(solution.images.first.url),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: solution.images.isEmpty
                  ? const Icon(
                      Icons.lightbulb_outlined,
                      color: Colors.green,
                      size: 30,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    solution.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'By ${solution.userId}',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    solution.category,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home, 'Home', true, () {
            // Already on home
          }),
          _buildNavItem(Icons.explore, 'Explore', false, () {
            Get.toNamed(Routes.EXPLORE);
          }),
          _buildNavItem(Icons.add_circle, 'Create', false, () {
            Get.toNamed(Routes.CREATE_SOLUTION);
          }),
          _buildNavItem(Icons.person, 'Profile', false, () {
            Get.toNamed(Routes.PROFILE);
          }),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? Colors.green : Colors.grey, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.green : Colors.grey,
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
