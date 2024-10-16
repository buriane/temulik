part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final UserProfile profile;

  const UpdateProfile(this.profile);

  @override
  List<Object> get props => [profile];
}

class UploadProfilePhoto extends ProfileEvent {
  final Uint8List imageData;

  const UploadProfilePhoto(this.imageData);

  @override
  List<Object> get props => [imageData];
}

class PickAndUploadProfilePhoto extends ProfileEvent {
  final ImageSource source;

  const PickAndUploadProfilePhoto({
    this.source = ImageSource.gallery,
  });

  @override
  List<Object> get props => [source];
}