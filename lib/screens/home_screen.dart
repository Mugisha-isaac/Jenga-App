
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jenga_app/modules/auth_controller.dart';
import '../modules/solution_controller.dart';
import '../models/solution.dart';
import '../models/user.dart' as user_model;
import '../routes/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SolutionController>();
    final userController = Get.find<AuthController>();

    final featuredSolutions = controller.solutions
        .where((solution) => solution.featured)
        .take(5)
        .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Jenga',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor ?? Theme.of(context).colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Theme.of(context).iconTheme.color),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(context),
            const SizedBox(height: 24),
            if (featuredSolutions.isNotEmpty)
              _buildFeaturedSolutions(context, controller),
            _buildTrendingTopics(context, controller),
            const SizedBox(height: 32),
            _buildRecentSolutions(context, controller, userController),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.EXPLORE);
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              'Search solutions',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedSolutions(BuildContext context, SolutionController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Featured Solutions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
              return Center(
                child: Text(
                  'No featured solutions yet',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
                ),
              );
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: featuredSolutions.length,
              itemBuilder: (contextList, index) {
                final solution = featuredSolutions[index];
                return _buildFeaturedCard(context, solution);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard(BuildContext context, Solution solution) {
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
              color: Colors.black.withValues(alpha: (0.1)),
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
                  color: solution.images.isEmpty ? Theme.of(context).colorScheme.surfaceVariant : null,
                ),
                child: solution.images.isEmpty
                    ? Center(
                        child: Icon(
                          Icons.lightbulb_outline,
                          size: 60,
                          color: Theme.of(context).colorScheme.primary,
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
                    colors: [
                      Colors.transparent,
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7)
                    ],
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
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        solution.category.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      solution.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      solution.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
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

  Widget _buildTrendingTopics(BuildContext context, SolutionController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Trending Topics',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          // Get trending solutions (non-featured solutions)
          final trendingSolutions = controller.solutions
              .where((solution) => !solution.featured)
              .take(100)
              .toList();

          if (trendingSolutions.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'No trending solutions yet',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
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
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    child: Text(
                      category,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
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

  Widget _buildRecentSolutions(
      BuildContext context, SolutionController controller, AuthController userController) {
    // getting current user
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Recent Solutions',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          // Get recent solutions (sorted by creation date)
          final recentSolutions = controller.solutions.toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (recentSolutions.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'No recent solutions yet',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: recentSolutions.take(10).length,
            itemBuilder: (contextList, index) {
              final solution = recentSolutions[index];
              return _buildRecentSolutionCard(context, solution);
            },
          );
        }),
      ],
    );
  }

  Widget _buildRecentSolutionCard(BuildContext context, Solution solution) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.SOLUTION_DETAIL, arguments: solution);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.05),
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
                color: Theme.of(context).colorScheme.surfaceVariant,
                image: solution.images.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(solution.images.first.url),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: solution.images.isEmpty
                  ? Icon(
                      Icons.lightbulb_outlined,
                      color: Theme.of(context).colorScheme.primary,
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
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  FutureBuilder<user_model.User?>(
                    future: Get.find<SolutionController>()
                        .getUserById(solution.userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          'By ...',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'By Error',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.error),
                        );
                      } else if (snapshot.hasData && snapshot.data != null) {
                        final user = snapshot.data!;
                        return Text(
                          'By ${user.fullName ?? 'No Name'}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
                        );
                      } else {
                        return Text(
                          'By Anonymous',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).hintColor,
                            fontStyle: FontStyle.italic,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 4),
                  Text(
                    solution.category,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
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

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(context, Icons.home, 'Home', true, () {
            // Already on home
          }),
          _buildNavItem(context, Icons.explore, 'Explore', false, () {
            Get.toNamed(Routes.EXPLORE);
          }),
          _buildNavItem(context, Icons.add_circle, 'Create', false, () {
            Get.toNamed(Routes.CREATE_SOLUTION);
          }),
          _buildNavItem(context, Icons.person, 'Profile', false, () {
            Get.toNamed(Routes.PROFILE);
          }),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
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
          Icon(
            icon,
            color: isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).hintColor,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).hintColor,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
