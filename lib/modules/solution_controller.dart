// lib/controllers/solution_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../models/solution.dart';
import '../repositories/solution_repository.dart';
import '../modules/auth_controller.dart';
import '../themes/app_theme.dart';

class SolutionController extends GetxController {
  late final SolutionRepository _solutionRepository;

  // Form Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final materialController = TextEditingController();
  final tagController = TextEditingController();
  final stepDescriptionController = TextEditingController();
  final premiumPriceController = TextEditingController();

  // Observable lists and variables
  final RxList<String> materials = <String>[].obs;
  final RxList<String> tags = <String>[].obs;
  final RxList<SolutionStep> steps = <SolutionStep>[].obs;
  final RxList<String> imageUrls = <String>[].obs;
  final RxBool isPremium = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isUploadingImages = false.obs;
  final RxString selectedCategory = ''.obs;

  // Edit mode variables
  final RxBool isEditMode = false.obs;
  final Rx<Solution?> editingSolution = Rx<Solution?>(null);
  final RxList<Solution> solutions = <Solution>[].obs;
  final RxBool isLoadingSolutions = false.obs;

  // New variables for filtering and search
  final RxString selectedFilterCategory = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxList<Solution> filteredSolutions = <Solution>[].obs;

  // Categories list
  final List<String> categories = [
    'Agriculture',
    'Health',
    'Education',
    'Technology',
    'Business',
    'Environment',
  ];

  @override
  void onInit() {
    super.onInit();
    _solutionRepository = Get.find<SolutionRepository>();

    // Set default values
    countryController.text = 'Rwanda';
    cityController.text = 'Kigali';

    // Load solutions if not already loaded
    if (solutions.isEmpty) {
      loadSolutions();
    }

    // Listen to solutions changes and update filtered solutions
    ever(solutions, (_) => _updateFilteredSolutions());
    ever(selectedFilterCategory, (_) => _updateFilteredSolutions());
    ever(searchQuery, (_) => _updateFilteredSolutions());

    // Initial update of filtered solutions
    _updateFilteredSolutions();
  }

  @override
  void onClose() {
    // Dispose controllers
    titleController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    countryController.dispose();
    cityController.dispose();
    materialController.dispose();
    tagController.dispose();
    stepDescriptionController.dispose();
    premiumPriceController.dispose();
    super.onClose();
  }

  // Load all solutions
  Future<void> loadSolutions() async {
    if (isLoadingSolutions.value) return; // Prevent multiple simultaneous loads

    isLoadingSolutions.value = true;
    try {
      final loadedSolutions = await _solutionRepository.getAllSolutions(
        limit: 50,
      );
      solutions.assignAll(loadedSolutions);
      _updateFilteredSolutions();
    } catch (e) {
      // Error loading solutions - log silently or handle as needed
      // Don't show error snackbar on initial load failure
    } finally {
      isLoadingSolutions.value = false;
    }
  }

  // Set edit mode with solution data
  void setEditMode(Solution solution) {
    isEditMode.value = true;
    editingSolution.value = solution;

    // Populate form fields
    titleController.text = solution.title;
    descriptionController.text = solution.description;
    countryController.text = solution.country;
    cityController.text = solution.city;
    selectedCategory.value = solution.category;
    isPremium.value = solution.isPremium;
    premiumPriceController.text = solution.premiumPrice?.toString() ?? '';

    // Populate lists
    materials.assignAll(solution.materials);
    tags.assignAll(solution.tags);
    steps.assignAll(solution.steps);
    imageUrls.assignAll(solution.images.map((img) => img.url));
  }

  // Exit edit mode
  void exitEditMode() {
    isEditMode.value = false;
    editingSolution.value = null;
    clearForm();
  }

  // Add material to the list
  void addMaterial() {
    if (materialController.text.trim().isNotEmpty) {
      materials.add(materialController.text.trim());
      materialController.clear();
    }
  }

  // Remove material from the list
  void removeMaterial(int index) {
    materials.removeAt(index);
  }

  // Add tag to the list
  void addTag() {
    if (tagController.text.trim().isNotEmpty) {
      tags.add(tagController.text.trim());
      tagController.clear();
    }
  }

  // Remove tag from the list
  void removeTag(int index) {
    tags.removeAt(index);
  }

  // Add step to the list
  void addStep() {
    if (stepDescriptionController.text.trim().isNotEmpty) {
      steps.add(
        SolutionStep(
          stepNumber: steps.length + 1,
          description: stepDescriptionController.text.trim(),
        ),
      );
      stepDescriptionController.clear();
    }
  }

  // Remove step from the list
  void removeStep(int index) {
    steps.removeAt(index);
    // Renumber steps
    for (int i = 0; i < steps.length; i++) {
      steps[i] = SolutionStep(
        stepNumber: i + 1,
        description: steps[i].description,
      );
    }
  }

  // Add image URL from Cloudinary upload
  void addImageUrlFromUpload(String url) {
    if (url.trim().isNotEmpty) {
      imageUrls.add(url.trim());
    }
  }

  // Start image upload
  void startImageUpload() {
    isUploadingImages.value = true;
  }

  // End image upload
  void endImageUpload() {
    isUploadingImages.value = false;
  }

  // Add image URL
  void addImageUrl(String url) {
    if (url.trim().isNotEmpty) {
      imageUrls.add(url.trim());
    }
  }

  // Remove image URL
  void removeImageUrl(int index) {
    imageUrls.removeAt(index);
  }

  // Validate form
  bool validateForm() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Title is required',
        colorText: AppTheme.onError,
        backgroundColor: AppTheme.error,
      );
      return false;
    }
    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Description is required',
        colorText: AppTheme.onError,
        backgroundColor: AppTheme.error,
      );
      return false;
    }
    if (selectedCategory.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Category is required',
        colorText: AppTheme.onError,
        backgroundColor: AppTheme.error,
      );
      return false;
    }
    if (materials.isEmpty) {
      Get.snackbar(
        'Error',
        'At least one material is required',
        colorText: AppTheme.onError,
        backgroundColor: AppTheme.error,
      );
      return false;
    }
    if (steps.isEmpty) {
      Get.snackbar(
        'Error',
        'At least one step is required',
        colorText: AppTheme.onError,
        backgroundColor: AppTheme.error,
      );
      return false;
    }
    if (tags.isEmpty) {
      Get.snackbar(
        'Error',
        'At least one tag is required',
        colorText: AppTheme.onError,
        backgroundColor: AppTheme.error,
      );
      return false;
    }
    if (isPremium.value && premiumPriceController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Premium price is required for premium solutions',
        colorText: AppTheme.onError,
        backgroundColor: AppTheme.error,
      );
      return false;
    }
    return true;
  }

  // Create or update solution
  Future<void> createSolution() async {
    if (!validateForm()) return;

    isLoading.value = true;

    try {
      if (isEditMode.value && editingSolution.value != null) {
        // Update existing solution
        final updatedSolution = editingSolution.value!.copyWith(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          category: selectedCategory.value,
          country: countryController.text.trim(),
          city: cityController.text.trim(),
          images: imageUrls.map((url) => SolutionImage(url: url)).toList(),
          materials: materials.toList(),
          steps: steps.toList(),
          tags: tags.toList(),
          premiumPrice: isPremium.value
              ? double.tryParse(premiumPriceController.text)
              : null,
          isPremium: isPremium.value,
          updatedAt: DateTime.now(),
        );

        await _solutionRepository.updateSolution(updatedSolution);

        Get.snackbar(
          'Success',
          'Solution updated successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.successColor,
          colorText: AppTheme.onSecondary,
        );
      } else {
        // Create new solution
        final solution = Solution(
          solutionId: _generateSolutionId(),
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          category: selectedCategory.value,
          userId:
              Get.find<AuthController>().currentUser.value?.uid ??
              'user123', // Assuming you have AuthController
          country: countryController.text.trim(),
          city: cityController.text.trim(),
          images: imageUrls.map((url) => SolutionImage(url: url)).toList(),
          materials: materials.toList(),
          steps: steps.toList(),
          tags: tags.toList(),
          metrics: SolutionMetrics(), // Default metrics (all zeros)
          premiumPrice: isPremium.value
              ? double.tryParse(premiumPriceController.text)
              : null,
          isPremium: isPremium.value,
          featured: false, // Default to false, can be changed by admin
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await _solutionRepository.createSolution(solution);

        Get.snackbar(
          'Success',
          'Solution created successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppTheme.successColor,
          colorText: AppTheme.onSecondary,
        );
      }

      // Clear form and exit edit mode
      clearForm();
      exitEditMode();

      // Reload solutions
      await loadSolutions();

      // Navigate back or to solutions list
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to ${isEditMode.value ? 'update' : 'create'} solution: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppTheme.error,
        colorText: AppTheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Update solution
  Future<void> updateSolution() async {
    if (!validateForm() || editingSolution.value == null) return;

    isLoading.value = true;

    try {
      final updatedSolution = editingSolution.value!.copyWith(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory.value,
        country: countryController.text.trim(),
        city: cityController.text.trim(),
        images: imageUrls.map((url) => SolutionImage(url: url)).toList(),
        materials: materials.toList(),
        steps: steps.toList(),
        tags: tags.toList(),
        premiumPrice: isPremium.value
            ? double.tryParse(premiumPriceController.text)
            : null,
        isPremium: isPremium.value,
        updatedAt: DateTime.now(),
      );

      await _solutionRepository.updateSolution(updatedSolution);

      Get.snackbar(
        'Success',
        'Solution updated successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppTheme.successColor,
        colorText: AppTheme.onSecondary,
      );

      // Clear form and exit edit mode
      clearForm();
      exitEditMode();

      // Navigate back or to solutions list
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update solution: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppTheme.error,
        colorText: AppTheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Generate unique solution ID
  String _generateSolutionId() {
    return 'sol_${DateTime.now().millisecondsSinceEpoch}_${(1000 + (9000 * (DateTime.now().millisecond / 1000))).round()}';
  }

  // Clear form
  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    categoryController.clear();
    countryController.text = 'Rwanda';
    cityController.text = 'Kigali';
    materialController.clear();
    tagController.clear();
    stepDescriptionController.clear();
    premiumPriceController.clear();

    materials.clear();
    tags.clear();
    steps.clear();
    imageUrls.clear();
    isPremium.value = false;
    isUploadingImages.value = false;
    selectedCategory.value = '';

    // Reset edit mode
    isEditMode.value = false;
    editingSolution.value = null;
  }

  // Set category
  void setCategory(String category) {
    selectedCategory.value = category;
  }

  // Toggle premium status
  void togglePremium() {
    isPremium.value = !isPremium.value;
    if (!isPremium.value) {
      premiumPriceController.clear();
    }
  }

  // Delete solution
  Future<void> deleteSolution(String solutionId) async {
    try {
      await _solutionRepository.deleteSolution(solutionId);
      solutions.removeWhere((s) => s.solutionId == solutionId);

      Get.snackbar(
        'Success',
        'Solution deleted successfully',
        backgroundColor: AppTheme.successColor,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete solution: ${e.toString()}',
        backgroundColor: AppTheme.error,
        colorText: Colors.white,
      );
    }
  }

  // Filter solutions by category
  void filterByCategory(String category) {
    selectedFilterCategory.value = category;
  }

  // Search solutions
  void searchSolutions(String query) {
    searchQuery.value = query;
  }

  // Update filtered solutions based on current filters
  void _updateFilteredSolutions() {
    List<Solution> filtered = solutions.toList();

    // Apply category filter
    if (selectedFilterCategory.value.isNotEmpty) {
      filtered = filtered
          .where(
            (solution) =>
                solution.category.toLowerCase() ==
                selectedFilterCategory.value.toLowerCase(),
          )
          .toList();
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered
          .where(
            (solution) =>
                solution.title.toLowerCase().contains(query) ||
                solution.description.toLowerCase().contains(query) ||
                solution.category.toLowerCase().contains(query) ||
                solution.tags.any((tag) => tag.toLowerCase().contains(query)),
          )
          .toList();
    }

    filteredSolutions.assignAll(filtered);
  }

  // Clear all filters
  void clearFilters() {
    selectedFilterCategory.value = '';
    searchQuery.value = '';
  }

  // Get featured solutions
  List<Solution> get featuredSolutions =>
      solutions.where((solution) => solution.featured).toList();

  // Get trending solutions (non-featured)
  List<Solution> get trendingSolutions =>
      solutions.where((solution) => !solution.featured).toList();

  // Get recent solutions
  List<Solution> get recentSolutions {
    final sorted = solutions.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }
}