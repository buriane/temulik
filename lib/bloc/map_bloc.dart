import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:temulik/services/geolocation_interface.dart';
import 'package:temulik/services/geolocation_mobile.dart';
import 'package:temulik/models/faculty.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GeolocationService _geolocationService;
  StreamSubscription? _compassSubscription;

  MapBloc(this._geolocationService) : super(MapState()) {
    on<InitializeMapEvent>(_onInitializeMap);
    on<UpdateLocationEvent>(_onUpdateLocation);
    on<UpdateBearingEvent>(_onUpdateBearing);
    on<ToggleCompassEvent>(_onToggleCompass);
    on<FilterFacultiesEvent>(_onFilterFaculties);
  }

  Future<void> _onInitializeMap(
    InitializeMapEvent event,
    Emitter<MapState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));

      bool hasPermission = await _checkLocationPermission();
      if (hasPermission) {
        await _getCurrentLocation(emit);
        _listenToCompass();
      }
    } catch (e) {
      print('Error initializing map: $e');
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onUpdateLocation(
    UpdateLocationEvent event,
    Emitter<MapState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _getCurrentLocation(emit);
    } catch (e) {
      print('Error updating location: $e');
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onUpdateBearing(
    UpdateBearingEvent event,
    Emitter<MapState> emit,
  ) {
    emit(state.copyWith(bearing: event.bearing));
  }

  void _onToggleCompass(
    ToggleCompassEvent event,
    Emitter<MapState> emit,
  ) {
    emit(state.copyWith(showCompass: event.showCompass));
  }

  void _onFilterFaculties(
    FilterFacultiesEvent event,
    Emitter<MapState> emit,
  ) {
    emit(state.copyWith(selectedFacultyCategories: event.selectedCategories));
  }

  Future<bool> _checkLocationPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return false;
      }

      if (permission == LocationPermission.deniedForever) return false;

      return true;
    } catch (e) {
      print('Error checking permission: $e');
      return false;
    }
  }

  Future<void> _getCurrentLocation(Emitter<MapState> emit) async {
    try {
      LocationData location = await _geolocationService.getCurrentLocation();

      String accuracyStatus =
          'Akurasi: ${location.accuracy.toStringAsFixed(0)}m';
      bool isHighAccuracy = false;

      if (location.accuracy <= 100) {
        isHighAccuracy = true;
        accuracyStatus += ' (Akurat)';
      } else if (location.accuracy <= 500) {
        isHighAccuracy = true;
        accuracyStatus += ' (Cukup Akurat)';
      } else {
        accuracyStatus += ' (Kurang Akurat)';
      }

      emit(state.copyWith(
        currentLocation: LatLng(location.latitude, location.longitude),
        accuracyStatus: accuracyStatus,
        isHighAccuracy: isHighAccuracy,
      ));
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  void _listenToCompass() {
    _compassSubscription = FlutterCompass.events?.listen((CompassEvent? event) {
      if (event != null) {
        double bearing = event.heading ?? 0;
        if (bearing < 0) {
          bearing += 360;
        }

        // Normalize bearing to 0-360 range
        bearing = bearing % 360;

        add(UpdateBearingEvent(bearing));

        // Toggle compass visibility based on non-zero rotation
        add(ToggleCompassEvent(bearing != 0));
      }
    });
  }

  @override
  Future<void> close() {
    _compassSubscription?.cancel();
    return super.close();
  }
}