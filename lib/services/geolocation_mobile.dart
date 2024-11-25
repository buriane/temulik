// ignore_for_file: deprecated_member_use

import 'package:geolocator/geolocator.dart';
import 'geolocation_interface.dart';

class GeolocationService implements GeolocationInterface {
  @override
  Future<bool> isLocationAvailable() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<LocationData> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
      timeLimit: const Duration(seconds: 5),
    );

    return LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
    );
  }
}