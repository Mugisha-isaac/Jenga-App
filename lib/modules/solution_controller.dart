import 'package:get/get.dart';
import 'package:jenga_app/models/solution.dart';

class SolutionController extends GetxController {
  // Mock data for demonstration
  final RxList<Solution> _solutions = <Solution>[].obs;
  
  // Getter for solutions
  List<Solution> get solutions => _solutions;

  @override
  void onInit() {
    super.onInit();
    // Load mock data when the controller initializes
    loadSolutions();
  }

  // Load solutions (in a real app, this would be an API call)
  Future<void> loadSolutions() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data
    final mockSolutions = [
      Solution(
        id: '1',
        title: 'Sustainable Water Filtration',
        description: 'An innovative water filtration system using locally available materials',
        category: 'Environment',
        userId: 'user1',
        featured: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        images: [
          SolutionImage(
            id: 'img1',
            url: 'https://images.unsplash.com/photo-1509391366360-2e959784a276?w=600',
          ),
        ],
      ),
      Solution(
        id: '2',
        title: 'Solar-Pered Irrigation',
        description: 'Affordable solar-powered irrigation for small-scale farmers',
        category: 'Agriculture',
        userId: 'user2',
        featured: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        images: [
          SolutionImage(
            id: 'img2',
            url: 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=600',
          ),
        ],
      ),
      Solution(
        id: '3',
        title: 'Mobile Health Clinic',
        description: 'Bringing healthcare to remote communities with mobile clinics',
        category: 'Healthcare',
        userId: 'user3',
        featured: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];

    _solutions.assignAll(mockSolutions);
  }

  // Get solutions by category
  List<Solution> getSolutionsByCategory(String category) {
    return _solutions.where((solution) => solution.category == category).toList();
  }

  // Get featured solutions
  List<Solution> getFeaturedSolutions() {
    return _solutions.where((solution) => solution.featured).toList();
  }

  // Get recent solutions
  List<Solution> getRecentSolutions({int limit = 3}) {
    final sorted = List<Solution>.from(_solutions)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(limit).toList();
  }

  // Add a new solution (for create solution functionality)
  void addSolution(Solution solution) {
    _solutions.insert(0, solution);
  }
}
