import 'package:cloud_firestore/cloud_firestore.dart';
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
        await _googleSignIn.signOut();
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      if (kDebugMode) {
        print('Got Google credentials. Signing in with Firebase...');
      }

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      
      if (user == null) {
        emit(AuthError('Failed to sign in with Google'));
        return;
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'email': user.email,
          'createdAt': FieldValue.serverTimestamp(),
        });
        emit(AuthNeedsProfile(user));
        return;
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      if (_isProfileComplete(userData)) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthNeedsProfile(user));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during sign in: $e');
      }
      emit(AuthError(e.toString()));
    }
  }

  bool _isProfileComplete(Map<String, dynamic> data) {
    return data['photoUrl'] != null &&
           data['fullName'] != null &&
           data['nim'] != null &&
           data['faculty'] != null &&
           data['department'] != null &&
           data['year'] != null &&
           data['whatsapp'] != null &&
           data['address'] != null;
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