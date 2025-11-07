import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:storygram/core/services/user_services.dart';

final userServicesProvider = Provider<UserServices>((ref) => UserServices());
