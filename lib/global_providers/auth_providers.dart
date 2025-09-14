import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/services/auth_services.dart';

//auth service provider
final authServiceProvider = Provider<AuthServices>((ref) {
  return AuthServices();
});
