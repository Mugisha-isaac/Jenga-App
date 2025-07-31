# Contributing to Jenga App 🤝

Thank you for your interest in contributing to Jenga App! This document provides guidelines and information for contributors.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)
- [Pull Request Process](#pull-request-process)
- [Issue Reporting](#issue-reporting)

## 🤝 Code of Conduct

### Our Pledge
We are committed to providing a welcoming and inclusive experience for everyone, regardless of age, body size, disability, ethnicity, gender identity and expression, level of experience, nationality, personal appearance, race, religion, or sexual identity and orientation.

### Expected Behavior
- Use welcoming and inclusive language
- Be respectful of differing viewpoints and experiences
- Gracefully accept constructive criticism
- Focus on what is best for the community
- Show empathy towards other community members

## 🚀 Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Git knowledge
- Basic understanding of Firebase
- Familiarity with GetX state management

### Development Setup

1. **Fork and Clone**
```bash
git clone https://github.com/yourusername/Jenga-App.git
cd Jenga-App
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Setup Environment**
```bash
cp .env.example .env
# Edit .env with your configuration
```

4. **Run Tests**
```bash
flutter test
```

5. **Start Development**
```bash
flutter run
```

## 🔄 Development Workflow

### Branch Naming Convention
- `feature/feature-name` - New features
- `fix/bug-description` - Bug fixes
- `docs/update-description` - Documentation updates
- `refactor/component-name` - Code refactoring
- `test/test-description` - Test improvements

### Commit Message Format
```
type(scope): brief description

Detailed explanation of changes (if necessary)

Closes #issue-number
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(auth): add Google Sign-In integration
fix(payment): resolve PayPal timeout issue
docs(readme): update setup instructions
test(auth): add unit tests for login controller
```

## 📝 Coding Standards

### Dart Style Guide
Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines:

#### Naming Conventions
```dart
// Classes: PascalCase
class PaymentController extends GetxController {}

// Variables and functions: camelCase
final String userName = 'john_doe';
void processPayment() {}

// Constants: camelCase
static const String apiBaseUrl = 'https://api.example.com';

// Files: snake_case
payment_controller.dart
user_repository.dart
```

#### Code Structure
```dart
// Import order: dart, flutter, packages, local
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user.dart';
import '../services/api_service.dart';

class ExampleController extends GetxController {
  // Constants first
  static const String defaultRole = 'user';
  
  // Private variables
  final ApiService _apiService = Get.find<ApiService>();
  
  // Observable variables
  final RxBool isLoading = false.obs;
  final RxString status = ''.obs;
  
  // Getters
  bool get isReady => !isLoading.value;
  
  // Lifecycle methods
  @override
  void onInit() {
    super.onInit();
    _initialize();
  }
  
  // Public methods
  Future<void> loadData() async {
    // Implementation
  }
  
  // Private methods
  void _initialize() {
    // Implementation
  }
}
```

### Architecture Guidelines

#### GetX Controllers
```dart
class UserController extends GetxController {
  // Dependency injection in onInit
  @override
  void onInit() {
    super.onInit();
    _userRepository = Get.find<UserRepository>();
  }
  
  // Error handling
  Future<void> loadUser() async {
    try {
      isLoading.value = true;
      final user = await _userRepository.getCurrentUser();
      currentUser.value = user;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user data');
    } finally {
      isLoading.value = false;
    }
  }
}
```

#### Repository Pattern
```dart
abstract class UserRepository {
  Future<User> getCurrentUser();
  Future<void> updateUser(User user);
}

class UserRepositoryImpl implements UserRepository {
  final FirebaseUserProvider _provider;
  
  UserRepositoryImpl(this._provider);
  
  @override
  Future<User> getCurrentUser() async {
    return await _provider.getCurrentUser();
  }
}
```

## 🧪 Testing Guidelines

### Test Structure
```
test/
├── unit/
│   ├── controllers/
│   ├── repositories/
│   └── models/
├── widget/
│   ├── screens/
│   └── widgets/
└── integration/
    └── auth_flow_test.dart
```

### Writing Tests

#### Unit Tests
```dart
void main() {
  group('AuthController', () {
    late AuthController controller;
    late MockAuthRepository mockRepository;
    
    setUp(() {
      mockRepository = MockAuthRepository();
      Get.put<AuthRepository>(mockRepository);
      controller = AuthController();
    });
    
    tearDown(() {
      Get.reset();
    });
    
    test('should login user successfully', () async {
      // Arrange
      when(mockRepository.login(any, any))
          .thenAnswer((_) async => mockUser);
      
      // Act
      await controller.login('test@example.com', 'password');
      
      // Assert
      expect(controller.currentUser.value, equals(mockUser));
      expect(controller.isLoggedIn, isTrue);
    });
  });
}
```

#### Widget Tests
```dart
void main() {
  testWidgets('LoginScreen should display login form', (tester) async {
    // Arrange
    await tester.pumpWidget(
      GetMaterialApp(
        home: LoginScreen(),
        initialBinding: AuthBinding(),
      ),
    );
    
    // Assert
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
```

### Test Coverage
- Aim for **>= 80%** code coverage
- All controllers must have unit tests
- Critical user flows need integration tests
- UI components should have widget tests

## 📚 Documentation

### Code Documentation
```dart
/// Repository for managing user data operations.
/// 
/// This repository provides a clean interface for user-related
/// operations and handles the communication with Firebase services.
class UserRepository {
  /// Retrieves the current authenticated user.
  /// 
  /// Returns a [User] object if authenticated, null otherwise.
  /// Throws [AuthException] if authentication fails.
  Future<User?> getCurrentUser() async {
    // Implementation
  }
}
```

### README Updates
When adding new features:
1. Update the Features section
2. Add new dependencies to the Dependencies section
3. Update setup instructions if needed
4. Add screenshots for UI changes

## 🔄 Pull Request Process

### Before Submitting
- [ ] Code follows the style guidelines
- [ ] Tests pass locally (`flutter test`)
- [ ] Code analysis passes (`flutter analyze`)
- [ ] Code is formatted (`flutter format .`)
- [ ] Documentation is updated
- [ ] Screenshots added for UI changes

### PR Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Manual testing completed

## Screenshots (if applicable)
Add screenshots for UI changes

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Tests pass
- [ ] Documentation updated
```

### Review Process
1. **Automated Checks**: All CI checks must pass
2. **Code Review**: At least one maintainer review required
3. **Testing**: Manual testing for significant changes
4. **Merge**: Squash merge preferred for clean history

## 🐛 Issue Reporting

### Bug Reports
Use the bug report template and include:
- Device information
- Flutter/Dart versions
- Steps to reproduce
- Expected vs actual behavior
- Screenshots/logs if applicable

### Feature Requests
Use the feature request template and include:
- Problem description
- Proposed solution
- Alternative solutions considered
- Additional context

### Issue Labels
- `bug` - Something isn't working
- `enhancement` - New feature or request
- `documentation` - Improvements to documentation
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed
- `priority: high/medium/low` - Priority level

## 🏆 Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes for significant contributions
- GitHub contributor statistics

## 📞 Getting Help

- **Questions**: Use GitHub Discussions
- **Real-time Chat**: Join our Discord server (if available)
- **Documentation**: Check the main README.md
- **Issues**: Search existing issues first

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to Jenga App! 🎉
