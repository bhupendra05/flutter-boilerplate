import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/user_model.dart';
import '../../features/auth/data/auth_repository.dart';

/// The current logged-in user — null means not authenticated.
/// Watched by go_router to redirect to /login when null.
final authStateProvider = FutureProvider<User?>((ref) async {
  final repo = ref.watch(authRepositoryProvider);
  return repo.getCurrentUser();
});
