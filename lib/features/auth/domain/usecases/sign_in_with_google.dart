import '../../../../core/utils/usecases/usecase.dart';
import '../entities/auth_user.dart';
import '../repository_interfaces/auth_repository.dart';

class SignInWithGoogle implements UseCase<AuthUser, NoParams> {
  const SignInWithGoogle(this._repository);

  final AuthRepository _repository;

  @override
  Future<AuthUser> call(NoParams params) {
    return _repository.signInWithGoogle();
  }
}