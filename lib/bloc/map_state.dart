part of 'map_bloc.dart';

class MapState {
  final LatLng? currentLocation;
  final double bearing;
  final bool showCompass;
  final bool isLoading;
  final String accuracyStatus;
  final bool isHighAccuracy;
  final List<String> selectedFacultyCategories;

  MapState({
    this.currentLocation,
    this.bearing = 0.0,
    this.showCompass = false,
    this.isLoading = false,
    this.accuracyStatus = '',
    this.isHighAccuracy = false,
    this.selectedFacultyCategories = const [],
  });

  MapState copyWith({
    LatLng? currentLocation,
    double? bearing,
    bool? showCompass,
    bool? isLoading,
    String? accuracyStatus,
    bool? isHighAccuracy,
    List<String>? selectedFacultyCategories,
  }) {
    return MapState(
      currentLocation: currentLocation ?? this.currentLocation,
      bearing: bearing ?? this.bearing,
      showCompass: showCompass ?? this.showCompass,
      isLoading: isLoading ?? this.isLoading,
      accuracyStatus: accuracyStatus ?? this.accuracyStatus,
      isHighAccuracy: isHighAccuracy ?? this.isHighAccuracy,
      selectedFacultyCategories: 
          selectedFacultyCategories ?? this.selectedFacultyCategories,
    );
  }
}