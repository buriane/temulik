import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// Conditional import
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<UploadProfilePhoto>(_onUploadProfilePhoto);
    on<PickAndUploadProfilePhoto>(_onPickAndUploadProfilePhoto);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          if (_isProfileComplete(data)) {
            emit(ProfileComplete(UserProfile.fromMap(data)));
          } else {
            emit(ProfileIncomplete(UserProfile.fromMap(data)));
          }
        } else {
          emit(ProfileIncomplete(UserProfile(email: user.email ?? '')));
        }
      } else {
        emit(ProfileError('User not authenticated'));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading profile: $e');
      }
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUpdateProfile(UpdateProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileUpdating());
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final data = event.profile.toMap();
        data['updatedAt'] = FieldValue.serverTimestamp();
        
        await _firestore.collection('users').doc(user.uid).set(
          data,
          SetOptions(merge: true),
        );

        if (_isProfileComplete(data)) {
          emit(ProfileComplete(event.profile));
        } else {
          emit(ProfileIncomplete(event.profile));
        }
      } else {
        emit(ProfileError('User not authenticated'));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating profile: $e');
      }
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onPickAndUploadProfilePhoto(
    PickAndUploadProfilePhoto event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      if (kIsWeb) {
        final html.FileUploadInputElement input = html.FileUploadInputElement()..accept = 'image/*';
        input.click();

        await input.onChange.first;
        if (input.files!.isNotEmpty) {
          final file = input.files!.first;
          final reader = html.FileReader();
          reader.readAsArrayBuffer(file);
          await reader.onLoad.first;

          final Uint8List imageData = reader.result as Uint8List;
          add(UploadProfilePhoto(imageData));
        }
      } else {
        final XFile? pickedFile = await _imagePicker.pickImage(
          source: event.source,
          maxWidth: 512,
          maxHeight: 512,
          imageQuality: 75,
        );

        if (pickedFile != null) {
          final File imageFile = File(pickedFile.path);
          add(UploadProfilePhoto(await imageFile.readAsBytes()));
        }
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> _onUploadProfilePhoto(
    UploadProfilePhoto event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(ProfileError('User not authenticated'));
        return;
      }

      emit(ProfileUpdating());

      // Ensure user is authenticated
      if (!(await user.getIdToken() != null)) {
        await user.reload();
        if (!(await user.getIdToken() != null)) {
          emit(ProfileError('User authentication failed'));
          return;
        }
      }

      // Upload to Firebase Storage
      final ref = _storage.ref().child('users/${user.uid}/profile.jpg');
      await ref.putData(event.imageData);
      
      // Get download URL
      final photoUrl = await ref.getDownloadURL();

      // Update Firestore document
      await _firestore.collection('users').doc(user.uid).update({
        'photoUrl': photoUrl,
      });

      // Fetch the updated user data
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final updatedProfile = UserProfile.fromMap(userDoc.data() as Map<String, dynamic>);
      
      if (_isProfileComplete(updatedProfile.toMap())) {
        emit(ProfileComplete(updatedProfile));
      } else {
        emit(ProfileIncomplete(updatedProfile));
      }
    } catch (e) {
      emit(ProfileError('Upload failed: ${e.toString()}'));
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
}

class UserProfile {
  final String email;
  final String? photoUrl;
  final String? fullName;
  final String? nim;
  final String? faculty;
  final String? department;
  final int? year;
  final String? whatsapp;
  final String? address;

  UserProfile({
    required this.email,
    this.photoUrl,
    this.fullName,
    this.nim,
    this.faculty,
    this.department,
    this.year,
    this.whatsapp,
    this.address,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      fullName: map['fullName'],
      nim: map['nim'],
      faculty: map['faculty'],
      department: map['department'],
      year: map['year'],
      whatsapp: map['whatsapp'],
      address: map['address'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'photoUrl': photoUrl,
      'fullName': fullName,
      'nim': nim,
      'faculty': faculty,
      'department': department,
      'year': year,
      'whatsapp': whatsapp,
      'address': address,
    };
  }
}

extension UserProfileExtension on UserProfile {
  UserProfile copyWith({
    String? email,
    String? photoUrl,
    String? fullName,
    String? nim,
    String? faculty,
    String? department,
    int? year,
    String? whatsapp,
    String? address,
  }) {
    return UserProfile(
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      fullName: fullName ?? this.fullName,
      nim: nim ?? this.nim,
      faculty: faculty ?? this.faculty,
      department: department ?? this.department,
      year: year ?? this.year,
      whatsapp: whatsapp ?? this.whatsapp,
      address: address ?? this.address,
    );
  }
}