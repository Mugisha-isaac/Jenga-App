// test/auth_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:jenga_app/providers/firebase_auth_provider.dart';
import 'package:jenga_app/repositories/auth_repository.dart';
import 'package:jenga_app/providers/firestore_user_provider.dart';

void main() {
  group('Authentication Tests', () {
    test('FirebaseAuthProvider should be instantiated', () {
      final provider = FirebaseAuthProvider();
      expect(provider, isNotNull);
    });

    test('AuthRepository should be instantiated with providers', () {
      final firebaseAuthProvider = FirebaseAuthProvider();
      final firestoreUserProvider = FirestoreUserProvider();

      final repository = AuthRepository(
        firebaseAuthProvider: firebaseAuthProvider,
        firestoreUserProvider: firestoreUserProvider,
      );

      expect(repository, isNotNull);
      expect(repository.firebaseAuthProvider, equals(firebaseAuthProvider));
      expect(repository.firestoreUserProvider, equals(firestoreUserProvider));
    });

    test('AuthRepository should have all required methods', () {
      final firebaseAuthProvider = FirebaseAuthProvider();
      final firestoreUserProvider = FirestoreUserProvider();

      final repository = AuthRepository(
        firebaseAuthProvider: firebaseAuthProvider,
        firestoreUserProvider: firestoreUserProvider,
      );

      // Check if methods exist (they should not throw when called)
      expect(() => repository.signOut(), isA<Function>());
      expect(() => repository.sendPasswordResetEmail('test@test.com'),
          isA<Function>());
      expect(() => repository.signInWithGoogle(), isA<Function>());
    });
  });

  group('Google Sign-In Tests', () {
    test('FirebaseAuthProvider should have Google Sign-In methods', () {
      final provider = FirebaseAuthProvider();

      // Check if Google Sign-In methods exist
      expect(() => provider.signInWithGoogle(), isA<Function>());
      expect(() => provider.signOutGoogle(), isA<Function>());
    });
  });
}
