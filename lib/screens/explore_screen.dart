import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/solution_controller.dart';
import '../modules/auth_controller.dart';
import '../models/solution.dart';
import '../routes/routes.dart';
import '../themes/app_theme.dart';

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

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          'Explore',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(controller),
          _buildCategoryTabs(controller),
          const SizedBox(height: 16),
          _buildTrendingSolutions(controller, authController),
          Expanded(child: _buildSolutionsList(controller, authController)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(SolutionController controller) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search for solutions',
          prefixIcon: Icon(Icons.search, color: Colors.green),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12),
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

    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];

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
                  color: isSelected ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? Colors.green : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Trending Solutions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.isLoadingSolutions.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
            );
          }

          final allSolutions = controller.filteredSolutions.isNotEmpty
              ? controller.filteredSolutions
              : controller.solutions;

          final trendingSolutions = allSolutions
              .where((solution) => !solution.featured)
              .take(3)
              .toList();

          if (trendingSolutions.isEmpty) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'No trending solutions found',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: trendingSolutions.length,
            itemBuilder: (context, index) {
              final solution = trendingSolutions[index];
              return _buildTrendingSolutionCard(solution, authController);
            },
          );
        }),
      ],
    );
  }

  Widget _buildTrendingSolutionCard(
    Solution solution,
    AuthController authController,
  ) {
    return GestureDetector(
      onTap: () => _handleSolutionTap(solution),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
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
                color: solution.images.isEmpty ? Colors.grey.shade300 : null,
              ),
              child: solution.images.isEmpty
                  ? const Icon(
                      Icons.lightbulb_outlined,
                      size: 40,
                      color: Colors.grey,
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
                            color: AppTheme.lightGreen,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            solution.category.toUpperCase(),
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 10,
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
                              color: Colors.amber.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'PREMIUM',
                              style: TextStyle(
                                color: Colors.amber.shade800,
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      solution.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      solution.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
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
                            color: Colors.amber.shade700,
                          ),
                          Text(
                            '${solution.premiumPrice?.toStringAsFixed(2) ?? '0.00'}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber.shade700,
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
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        );
      }

      final solutions = controller.filteredSolutions.isNotEmpty
          ? controller.filteredSolutions
          : controller.solutions;

      if (solutions.isEmpty) {
        return const Center(
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

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: solutions.length,
        itemBuilder: (context, index) {
          final solution = solutions[index];
          return _buildSolutionCard(solution, authController);
        },
      );
    });
  }

  Widget _buildSolutionCard(Solution solution, AuthController authController) {
    return GestureDetector(
      onTap: () => _handleSolutionTap(solution),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
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
                color: solution.images.isEmpty ? Colors.grey.shade300 : null,
              ),
              child: solution.images.isEmpty
                  ? const Center(
                      child: Icon(
                        Icons.lightbulb_outlined,
                        size: 60,
                        color: Colors.grey,
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
                          color: AppTheme.lightGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          solution.category.toUpperCase(),
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 10,
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
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'FEATURED',
                            style: TextStyle(
                              color: Colors.orange.shade800,
                              fontSize: 10,
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
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'PREMIUM',
                            style: TextStyle(
                              color: Colors.amber.shade800,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    solution.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    solution.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${solution.city}, ${solution.country}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const Spacer(),
                      if (solution.isPremium)
                        Row(
                          children: [
                            Icon(
                              Icons.attach_money,
                              size: 16,
                              color: Colors.amber.shade700,
                            ),
                            Text(
                              '${solution.premiumPrice?.toStringAsFixed(2) ?? '0.00'}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.amber.shade700,
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
