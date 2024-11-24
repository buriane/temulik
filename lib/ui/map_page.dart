// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:async';
import 'dart:html' as html;
import 'package:temulik/constants/colors.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  double _bearing = 0.0;
  bool _showCompass = false;
  bool _isLoading = true;
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _locationUpdateTimer;
  bool _isHighAccuracy = false;
  bool _isWeb = false;
  String _accuracyStatus = '';

  @override
  void initState() {
    super.initState();
    _checkPlatform();
    _initializeMap();

    _mapController.mapEventStream.listen((event) {
      if (event is MapEventRotateEnd) {
        setState(() {
          _showCompass = _mapController.camera.rotationRad != 0;
        });
      }
    });

    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        _updateCurrentLocation();
      }
    });
  }

  void _checkPlatform() {
    setState(() {
      _isWeb = identical(0, 0.0);
    });
  }

  Future<void> _initializeMap() async {
    try {
      bool hasPermission = await _checkLocationPermission();
      if (hasPermission) {
        if (_isWeb) {
          await _getCurrentLocationWeb();
        } else {
          await _getCurrentLocation();
        }
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
      if (_isWeb) {
        await _getCurrentLocationWeb();
      } else {
        await _getCurrentLocation();
      }
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
      if (_isWeb) {
        final geolocation = html.window.navigator.geolocation;
        if (geolocation == null) {
          _showErrorSnackBar('Geolokasi tidak didukung di browser ini.');
          return false;
        }
        return true;
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showErrorSnackBar('Layanan lokasi tidak aktif. Mohon aktifkan layanan lokasi.');
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
        _showErrorSnackBar('Izin lokasi ditolak secara permanen. Mohon ubah pengaturan perangkat Anda.');
        return false;
      }

      return true;
    } catch (e) {
      print('Error checking permission: $e');
      _showErrorSnackBar('Gagal memeriksa izin lokasi: ${e.toString()}');
      return false;
    }
  }

  Future<bool> _isLocationAvailableInBrowser() async {
    try {
      return html.window.navigator.geolocation != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> _getCurrentLocationWeb() async {
    final completer = Completer<void>();

    try {
      html.window.navigator.geolocation.getCurrentPosition().then((position) {
        if (mounted) {
          final lat = position.coords!.latitude;
          final lng = position.coords!.longitude;
          final accuracy = position.coords!.accuracy;

          print('Web Location - Lat: $lat, Lng: $lng, Accuracy: $accuracy meters');

          setState(() {
            _currentLocation = LatLng(lat!.toDouble(), lng!.toDouble());
            _accuracyStatus = 'Akurasi: ${accuracy?.toStringAsFixed(0)}m';

            if (accuracy! <= 100) {
              _isHighAccuracy = true;
              _accuracyStatus += ' (Akurat)';
            } else if (accuracy <= 500) {
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
          completer.complete();
        }
      }).catchError((error) {
        String errorMessage = 'Gagal mendapatkan lokasi';
        if (error is html.PositionError) {
          switch (error.code) {
            case 1:
              errorMessage = 'Izin lokasi ditolak. Mohon izinkan akses lokasi di browser Anda.';
              break;
            case 2:
              errorMessage = 'Lokasi tidak tersedia. Pastikan GPS/Location Services aktif.';
              break;
            case 3:
              errorMessage = 'Waktu mendapatkan lokasi habis. Coba lagi.';
              break;
          }
        }
        _showErrorSnackBar(errorMessage);
        completer.completeError(errorMessage);
      }, test: (e) => e is html.PositionError);

    } catch (e) {
      final errorMessage = 'Gagal mendapatkan lokasi di browser: $e';
      _showErrorSnackBar(errorMessage);
      completer.completeError(errorMessage);
    }

    return completer.future;
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 5),
      );

      print(
          'Native Location - Lat: ${position.latitude}, Lng: ${position.longitude}, Accuracy: ${position.accuracy} meters');

      if (mounted && position.accuracy <= 20) {
        // Hanya update jika akurasi <= 20 meter
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
          _isHighAccuracy = true;
        });

        _animatedMapMove(_currentLocation!, 15);
      } else {
        _showErrorSnackBar('Mencoba mendapatkan lokasi yang lebih akurat...');
      }
    } catch (e) {
      print('Error getting current location: $e');
      if (mounted) {
        _showErrorSnackBar('Gagal mendapatkan lokasi saat ini.');
      }
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
      // Di web, gunakan getCurrentLocationWeb
      if (await _isLocationAvailableInBrowser()) {
        await _getCurrentLocationWeb();
      } else {
        await _getCurrentLocation();
      }
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
              initialCenter: _currentLocation ?? const LatLng(0, 0), // Default ke koordinat 0,0
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
                                  border: Border.all(color: Colors.white, width: 2),
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
                                  color: _isHighAccuracy ? AppColors.blue : AppColors.red,
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
                // Menampilkan dialog petunjuk jika akurasi rendah
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