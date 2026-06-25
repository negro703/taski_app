import '../entities/auth_user.dart';
import '../repository_interfaces/auth_repository.dart';

class WatchAuthState {
  const WatchAuthState(this._repository);

  final AuthRepository _repository;

  Stream<AuthUser?> call() {
    return _repository.authStateChanges();
  }
}
