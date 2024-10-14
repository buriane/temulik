import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '613061731298-9n4j15ci16gu8ds4quj1stq8lsd40sec.apps.googleusercontent.com',
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  AuthBloc() : super(AuthInitial()) {
    on<SignInWithGoogle>(_onSignInWithGoogle);
    on<SignOut>(_onSignOut);
  }

  Future<void> _onSignInWithGoogle(SignInWithGoogle event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        emit(AuthError('Google sign in aborted'));
        return;
      }

      if (kDebugMode) {
        print('Google Sign In successful. Email: ${googleUser.email}');
      }

      if (!_isAllowedDomain(googleUser.email)) {
        emit(AuthError('Only @mhs.unsoed.ac.id, @fk.unsoed.ac.id, or @unsoed.ac.id domains are allowed'));
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth.accessToken,
      //   idToken: googleAuth.idToken,
      // );

      if (kDebugMode) {
        print('Got Google credentials. Signing in with Firebase...');
      }

      // final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final UserCredential userCredential = await _signInWithGoogle(googleAuth);

      if (kDebugMode) {
        print('Firebase sign in successful. User: ${userCredential.user?.displayName}');
      }

      emit(AuthAuthenticated(userCredential.user!));
    } catch (e) {
      if (kDebugMode) {
        print('Error during sign in: $e');
      }
      emit(AuthError(e.toString()));
    }
  }

  Future<UserCredential> _signInWithGoogle(GoogleSignInAuthentication googleAuth) async {
    try {
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print('Error in _signInWithGoogle: $e');
      rethrow;
    }
  }

  Future<void> _onSignOut(SignOut event, Emitter<AuthState> emit) async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    emit(AuthInitial());
  }

  bool _isAllowedDomain(String email) {
    return email.endsWith('@mhs.unsoed.ac.id') ||
           email.endsWith('@fk.unsoed.ac.id') ||
           email.endsWith('@unsoed.ac.id');
  }
}