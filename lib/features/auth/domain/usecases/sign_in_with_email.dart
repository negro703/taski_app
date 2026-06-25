import '../../../../core/utils/usecases/usecase.dart';
import '../entities/auth_user.dart';
import '../repository_interfaces/auth_repository.dart';

class SignInWithEmail implements UseCase<AuthUser, SignInWithEmailParams> {
  const SignInWithEmail(this._repository);

  final AuthRepository _repository;

  @override
  Future<AuthUser> call(SignInWithEmailParams params) {
    return _repository.signInWithEmailAndPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class SignInWithEmailParams {
  const SignInWithEmailParams({required this.email, required this.password});

  final String email;
  final String password;
}
