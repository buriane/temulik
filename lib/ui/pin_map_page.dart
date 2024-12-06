import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:temulik/bloc/map_bloc.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/services/geolocation_mobile.dart';
import 'package:temulik/models/faculty.dart';

class PinMapPage extends StatefulWidget {
  final LatLng? initialLocation;
  final String? selectedFaculty;

  const PinMapPage({
    super.key, 
    this.initialLocation, 
    this.selectedFaculty
  });

  @override
  State<PinMapPage> createState() => _PinMapPageState();
}

class _PinMapPageState extends State<PinMapPage> {
  final MapController _mapController = MapController();
  String? _selectedFaculty;
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _selectedFaculty = widget.selectedFaculty;
    
    // If initial location is provided, use it
    if (widget.initialLocation != null) {
      _currentLocation = widget.initialLocation;
    }
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Faculty.unsoedFaculties.length,
        itemBuilder: (context, index) {
          final faculty = Faculty.unsoedFaculties[index];
          final isSelected = _selectedFaculty == faculty.name;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(faculty.name),
              selected: isSelected,
              onSelected: (bool value) {
                setState(() {
                  _selectedFaculty = value ? faculty.name : null;
                  final facultyLocation = 
                      LatLng(faculty.latitude, faculty.longitude);
                  _mapController.move(facultyLocation, 17);
                });
              },
              selectedColor: AppColors.blue.withOpacity(0.2),
              checkmarkColor: AppColors.blue,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MapBloc(GeolocationService())..add(InitializeMapEvent()),
      child: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state.currentLocation != null) {
            // If no initial location was provided, use current location
            if (_currentLocation == null) {
              _currentLocation = state.currentLocation;
              _mapController.move(state.currentLocation!, 15);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('Pilih Lokasi'),
            ),
            body: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentLocation ?? const LatLng(0, 0),
                    initialZoom: 15,
                    minZoom: 2,
                    maxZoom: 22,
                    interactionOptions: InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                    onMapReady: () {
                      if (_currentLocation != null) {
                        _mapController.move(_currentLocation!, 15);
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.temulik.app',
                      tileProvider: CancellableNetworkTileProvider(),
                    ),
                  ],
                ),

                // Pinpoint in center of screen
                const Center(
                  child: Icon(
                    Icons.place,
                    color: Colors.red,
                    size: 50,
                  ),
                ),

                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildCategoryFilter(),
                  ),
                ),

                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Column(
                    children: [
                      // Location Button
                      FloatingActionButton(
                        backgroundColor: AppColors.blue,
                        onPressed: () {
                          context.read<MapBloc>().add(UpdateLocationEvent());
                          if (state.currentLocation != null) {
                            _mapController.move(state.currentLocation!, 15);
                            setState(() {
                              _currentLocation = state.currentLocation;
                            });
                          }
                        },
                        child: state.isLoading
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
                    ],
                  ),
                ),
              ],
            ),
            bottomSheet: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  // Return selected location and faculty
                  final selectedLocation = _mapController.camera.center;
                  Navigator.pop(context, {
                    'location': selectedLocation,
                    'faculty': _selectedFaculty
                  });
                },
                child: const Text('Pilih Lokasi'),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}