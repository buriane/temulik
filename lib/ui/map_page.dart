// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:async';
import 'package:temulik/services/geolocation_interface.dart';
import 'package:temulik/services/geolocation_mobile.dart';
import 'package:temulik/constants/colors.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final GeolocationService _geolocationService = GeolocationService();
  LatLng? _currentLocation;
  double _bearing = 0.0;
  bool _showCompass = false;
  bool _isLoading = true;
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _locationUpdateTimer;
  bool _isHighAccuracy = false;
  String _accuracyStatus = '';

  @override
  void initState() {
    super.initState();
    _initializeMap();

    _mapController.mapEventStream.listen((event) {
      if (event is MapEventRotateEnd) {
        setState(() {
          _showCompass = _mapController.camera.rotationRad != 0;
        });
      }
    });

    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 100), (timer) {
      if (mounted) {
        _updateCurrentLocation();
      }
    });
  }

  Future<void> _initializeMap() async {
    try {
      bool hasPermission = await _checkLocationPermission();
      if (hasPermission) {
        await _getCurrentLocation();
        _listenToCompass();
      }
    } catch (e) {
      print('Error initializing map: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateCurrentLocation() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _getCurrentLocation();
    } catch (e) {
      print('Error updating location: $e');
      _showErrorSnackBar('Gagal memperbarui lokasi: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> _checkLocationPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showErrorSnackBar(
            'Layanan lokasi tidak aktif. Mohon aktifkan layanan lokasi.');
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorSnackBar('Izin lokasi ditolak.');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorSnackBar(
            'Izin lokasi ditolak secara permanen. Mohon ubah pengaturan perangkat Anda.');
        return false;
      }

      return true;
    } catch (e) {
      print('Error checking permission: $e');
      _showErrorSnackBar('Gagal memeriksa izin lokasi: ${e.toString()}');
      return false;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationData location = await _geolocationService.getCurrentLocation();

      if (mounted) {
        setState(() {
          _currentLocation = LatLng(location.latitude, location.longitude);
          _accuracyStatus = 'Akurasi: ${location.accuracy.toStringAsFixed(0)}m';

          if (location.accuracy <= 100) {
            _isHighAccuracy = true;
            _accuracyStatus += ' (Akurat)';
          } else if (location.accuracy <= 500) {
            _isHighAccuracy = true;
            _accuracyStatus += ' (Cukup Akurat)';
          } else {
            _isHighAccuracy = false;
            _accuracyStatus += ' (Kurang Akurat)';
          }
        });

        if (_currentLocation != null) {
          _animatedMapMove(_currentLocation!, 15);
        }
      }
    } catch (e) {
      print('Error getting current location: $e');
      _showErrorSnackBar('Gagal mendapatkan lokasi saat ini.');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  void _listenToCompass() {
    FlutterCompass.events?.listen((CompassEvent? event) {
      if (mounted && event != null) {
        setState(() {
          _bearing = event.heading ?? 0;
          if (_bearing < 0) {
            _bearing += 360;
          }
        });
      }
    });
  }

  void _resetRotation() {
    _animatedMapRotate(0);
    setState(() {
      _showCompass = false;
      _bearing = 0;
    });
  }

  Future<void> _moveToCurrentLocation() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await _getCurrentLocation();
    } catch (e) {
      if (mounted) {
        print('Error in moveToCurrentLocation: $e');
        _showErrorSnackBar('Gagal mendapatkan lokasi saat ini.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    _mapController.move(destLocation, destZoom);
  }

  void _animatedMapRotate(double angle) {
    _mapController.rotate(angle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentLocation ??
                  const LatLng(0, 0),
              initialZoom: 15,
              onMapReady: () {
                if (_currentLocation != null) {
                  _animatedMapMove(_currentLocation!, 15);
                }
              },
              onMapEvent: (MapEvent event) {
                if (event is MapEventRotateEnd) {
                  setState(() {
                    _showCompass = _mapController.camera.rotationRad != 0;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.temulik.app',
                tileProvider: CancellableNetworkTileProvider(),
              ),
              MarkerLayer(
                markers: [
                  if (_currentLocation != null)
                    Marker(
                      width: 80,
                      height: 80,
                      point: _currentLocation!,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.blue.withOpacity(0.2),
                            ),
                            child: Center(
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.blue,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ),
                          if (_accuracyStatus.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Text(
                                _accuracyStatus,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: _isHighAccuracy
                                      ? AppColors.blue
                                      : AppColors.red,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              backgroundColor: AppColors.blue,
              onPressed: () {
                _moveToCurrentLocation();
                if (!_isHighAccuracy) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Petunjuk Meningkatkan Akurasi'),
                      content: const Text(
                        '1. Pastikan GPS/Location Services aktif\n'
                        '2. Izinkan akses lokasi di browser\n'
                        '3. Gunakan browser Chrome terbaru\n'
                        '4. Jika menggunakan WiFi, coba gunakan koneksi data seluler\n'
                        '5. Tunggu beberapa saat sampai akurasi meningkat',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(
                      Icons.my_location,
                      color: Colors.white,
                    ),
            ),
          ),
          if (_showCompass)
            Positioned(
              left: 16,
              bottom: 88,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: _resetRotation,
                  child: Transform.rotate(
                    angle: _mapController.camera.rotationRad * -1,
                    child: Icon(
                      Icons.explore,
                      color: AppColors.dark,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    _positionStreamSubscription?.cancel();
    _locationUpdateTimer?.cancel();
    super.dispose();
  }
}
