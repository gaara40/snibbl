import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/core/services/auth_services.dart';

//auth service provider
final authServiceProvider = Provider<AuthServices>((ref) {
  return AuthServices();
});

//auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
