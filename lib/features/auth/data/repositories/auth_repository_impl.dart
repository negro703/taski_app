import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/utils/errors/app_exception.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repository_interfaces/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Stream<AuthUser?> authStateChanges() {
    return _remoteDataSource.authStateChanges();
  }

  @override
  Future<AuthUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _guardFirebaseCall(
      () => _remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<AuthUser> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) {
    return _guardFirebaseCall(
      () => _remoteDataSource.registerWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      ),
    );
  }

  @override
  Future<AuthUser> signInWithGoogle() {
    return _guardFirebaseCall(
      () => _remoteDataSource.signInWithGoogle(),
    );
  }

  @override
  Future<void> signOut() {
    return _guardFirebaseCall(_remoteDataSource.signOut);
  }

  Future<T> _guardFirebaseCall<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on FirebaseAuthException catch (error) {
      throw AppException(
        error.message ?? 'Authentication request failed.',
        code: error.code,
      );
    } on FirebaseException catch (error) {
      throw AppException(
        error.message ?? 'Firebase request failed.',
        code: error.code,
      );
    }
  }
}