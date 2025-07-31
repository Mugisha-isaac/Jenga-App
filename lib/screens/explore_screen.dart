import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/solution_controller.dart';
import '../modules/auth_controller.dart';
import '../models/solution.dart';
import '../routes/routes.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SolutionController>();
    final authController = Get.find<AuthController>();

    // Handle initial category from arguments
    final arguments = Get.arguments as Map<String, dynamic>?;
    final initialCategory = arguments?['category'] as String?;

    if (initialCategory != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.filterByCategory(initialCategory);
      });
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Explore',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(controller),
          _buildCategoryTabs(controller),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildTrendingSolutions(controller, authController),
                  const SizedBox(height: 16),
                  _buildSolutionsList(controller, authController),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(SolutionController controller) {
    final theme = Theme.of(Get.context!);
    final colorScheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withOpacity(0.3)),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for solutions',
          prefixIcon: Icon(Icons.search, color: colorScheme.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (query) {
          controller.searchSolutions(query);
        },
      ),
    );
  }

  Widget _buildCategoryTabs(SolutionController controller) {
    final categories = [
      'All',
      'Agriculture',
      'Health',
      'Education',
      'Technology',
      'Business',
    ];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;
          final textTheme = theme.textTheme;

          return Obx(() {
            final isSelected =
                controller.selectedFilterCategory.value == category ||
                    (controller.selectedFilterCategory.value.isEmpty &&
                        category == 'All');

            return GestureDetector(
              onTap: () {
                controller.filterByCategory(category == 'All' ? '' : category);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : colorScheme.surface,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? colorScheme.primary : colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  category,
                  style: textTheme.bodyMedium?.copyWith(
                    color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface.withOpacity(0.7),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildTrendingSolutions(
    SolutionController controller,
    AuthController authController,
  ) {
    return Obx(() {
      if (controller.isLoadingSolutions.value) {
        return const Padding(
          padding: EdgeInsets.all(20),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
        );
      }

      final allSolutions = controller.filteredSolutions.isNotEmpty
          ? controller.filteredSolutions
          : controller.solutions;

      final trendingSolutions =
          allSolutions.where((solution) => !solution.featured).take(3).toList();

      if (trendingSolutions.isEmpty) {
        return const SizedBox
            .shrink(); // Don't show anything if no trending solutions
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Trending Solutions',
              style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(Get.context!).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: trendingSolutions.length,
            itemBuilder: (context, index) {
              final solution = trendingSolutions[index];
              return _buildTrendingSolutionCard(solution, authController);
            },
          ),
        ],
      );
    });
  }

  Widget _buildTrendingSolutionCard(
    Solution solution,
    AuthController authController,
  ) {
    final theme = Theme.of(Get.context!);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return GestureDetector(
      onTap: () => _handleSolutionTap(solution),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                image: solution.images.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(solution.images.first.url),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: solution.images.isEmpty ? colorScheme.background : null,
              ),
              child: solution.images.isEmpty
                  ? Icon(
                      Icons.lightbulb_outlined,
                      size: 40,
                      color: colorScheme.secondary,
                    )
                  : null,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            solution.category.toUpperCase(),
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (solution.isPremium)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.secondary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'PREMIUM',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      solution.title,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      solution.description,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (solution.isPremium) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            size: 16,
                            color: colorScheme.secondary,
                          ),
                          Text(
                            solution.premiumPrice?.toStringAsFixed(2) ?? '0.00',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolutionsList(
    SolutionController controller,
    AuthController authController,
  ) {
    return Obx(() {
      if (controller.isLoadingSolutions.value) {
        return const Padding(
          padding: EdgeInsets.all(50),
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
        );
      }

      final solutions = controller.filteredSolutions.isNotEmpty
          ? controller.filteredSolutions
          : controller.solutions;

      if (solutions.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No solutions found',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Try adjusting your search or filters',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'All Solutions',
              style: Theme.of(Get.context!).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(Get.context!).colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: solutions.length,
            itemBuilder: (context, index) {
              final solution = solutions[index];
              return _buildSolutionCard(solution, authController);
            },
          ),
          const SizedBox(height: 20), // Bottom padding
        ],
      );
    });
  }

  Widget _buildSolutionCard(Solution solution, AuthController authController) {
    final theme = Theme.of(Get.context!);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return GestureDetector(
      onTap: () => _handleSolutionTap(solution),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                image: solution.images.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(solution.images.first.url),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: solution.images.isEmpty ? colorScheme.background : null,
              ),
              child: solution.images.isEmpty
                  ? Center(
                      child: Icon(
                        Icons.lightbulb_outlined,
                        size: 60,
                        color: colorScheme.secondary,
                      ),
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          solution.category.toUpperCase(),
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (solution.featured)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.tertiary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'FEATURED',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.tertiary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      if (solution.isPremium)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.secondary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'PREMIUM',
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    solution.title,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    solution.description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: colorScheme.secondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${solution.city}, ${solution.country}',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.secondary,
                        ),
                      ),
                      const Spacer(),
                      if (solution.isPremium)
                        Row(
                          children: [
                            Icon(
                              Icons.attach_money,
                              size: 16,
                              color: colorScheme.secondary,
                            ),
                            Text(
                              solution.premiumPrice?.toStringAsFixed(2) ?? '0.00',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSolutionTap(Solution solution) {
    Get.toNamed(Routes.SOLUTION_DETAIL, arguments: solution);
  }
}
