import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/auth_user_model.dart';

abstract interface class AuthRemoteDataSource {
  Stream<AuthUserModel?> authStateChanges();

  Future<AuthUserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<AuthUserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });

  Future<AuthUserModel> signInWithGoogle();

  Future<void> signOut();
}

class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  FirebaseAuthRemoteDataSource({
    required this.firebaseAuth,
    required this.firestore,
    required this.googleSignIn,
  });

  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final GoogleSignIn googleSignIn;

  @override
  Stream<AuthUserModel?> authStateChanges() {
    return firebaseAuth.authStateChanges().map((user) {
      if (user == null) {
        return null;
      }

      return AuthUserModel.fromFirebaseUser(user);
    });
  }

  @override
  Future<AuthUserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final credential = await firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'missing-user',
        message: 'Authentication completed without a user profile.',
      );
    }

    return AuthUserModel.fromFirebaseUser(user);
  }

  @override
  Future<AuthUserModel> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final user = credential.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'missing-user',
        message: 'Registration completed without a user profile.',
      );
    }

    await user.updateDisplayName(displayName.trim());
    await firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'displayName': displayName.trim(),
      'photoUrl': user.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await user.reload();
    final refreshedUser = firebaseAuth.currentUser ?? user;
    return AuthUserModel.fromFirebaseUser(refreshedUser);
  }

  @override
  Future<AuthUserModel> signInWithGoogle() async {
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw FirebaseAuthException(
        code: 'canceled',
        message: 'Google Sign-In was canceled.',
      );
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final authResult = await firebaseAuth.signInWithCredential(credential);
    final user = authResult.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'missing-user',
        message: 'Google Sign-In completed without a user profile.',
      );
    }

    // Ensure Firestore user document exists
    await firestore.collection('users').doc(user.uid).set({
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return AuthUserModel.fromFirebaseUser(user);
  }

  @override
  Future<void> signOut() {
    return firebaseAuth.signOut();
  }
}