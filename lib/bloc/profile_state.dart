part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  final UserProfile profile;
  
  const ProfileState(this.profile);
  
  @override
  List<Object> get props => [profile];
}

class ProfileInitial extends ProfileState {
  ProfileInitial() : super(UserProfile(email: ''));
}

class ProfileLoading extends ProfileState {
  ProfileLoading() : super(UserProfile(email: ''));
}

class ProfileUpdating extends ProfileState {
  ProfileUpdating() : super(UserProfile(email: ''));
}

class ProfileComplete extends ProfileState {
  const ProfileComplete(UserProfile profile) : super(profile);
}

class ProfileIncomplete extends ProfileState {
  const ProfileIncomplete(UserProfile profile) : super(profile);
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message) : super(UserProfile(email: ''));

  @override
  List<Object> get props => [message, profile];
}