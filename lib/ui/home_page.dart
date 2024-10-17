import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/profile_bloc.dart';
import 'login_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthInitial) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginPage()),
            );
          }
        },
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, profileState) {
            if (profileState is ProfileComplete) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: profileState.profile.photoUrl != null
                          ? NetworkImage(profileState.profile.photoUrl!)
                          : null,
                      child: profileState.profile.photoUrl == null
                          ? Icon(Icons.person, size: 50)
                          : null,
                    ),
                    SizedBox(height: 16),
                    Text('Welcome, ${profileState.profile.fullName}!'),
                    SizedBox(height: 16),
                    Text('Email: ${profileState.profile.email}'),
                    SizedBox(height: 16),
                    Text('NIM: ${profileState.profile.nim}'),
                    SizedBox(height: 16),
                    Text('Faculty: ${profileState.profile.faculty}'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      child: Text('Sign Out'),
                      onPressed: () {
                        context.read<AuthBloc>().add(SignOut());
                      },
                    ),
                  ],
                ),
              );
            } else if (profileState is ProfileLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (profileState is ProfileError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error loading profile: ${profileState.message}'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      child: Text('Retry'),
                      onPressed: () {
                        context.read<ProfileBloc>().add(LoadProfile());
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Unexpected state: $profileState'));
            }
          },
        ),
      ),
    );
  }
}