abstract class GeolocationInterface {
  Future<bool> isLocationAvailable();
  Future<LocationData> getCurrentLocation();
}

class LocationData {
  final double latitude;
  final double longitude;
  final double accuracy;

  LocationData({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
  });
}