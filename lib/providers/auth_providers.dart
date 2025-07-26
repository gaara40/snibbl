import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/services/auth_services.dart';

//auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

//auth service provider
final authServiceProvider = Provider<AuthServices>((ref) {
  return AuthServices();
});
