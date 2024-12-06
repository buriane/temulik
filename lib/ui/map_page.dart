import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:temulik/bloc/map_bloc.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/services/geolocation_mobile.dart';
import 'package:temulik/models/faculty.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final List<String> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
    _mapController.mapEventStream.listen((event) {
      if (event is MapEventRotateEnd) {
        context.read<MapBloc>().add(
              ToggleCompassEvent(_mapController.camera.rotationRad != 0),
            );
      }
    });
  }

  void _showAccuracyDialog() {
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

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: Faculty.unsoedFaculties.length,
        itemBuilder: (context, index) {
          final faculty = Faculty.unsoedFaculties[index];
          final isSelected = _selectedCategories.contains(faculty.name);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(faculty.name),
              selected: isSelected,
              onSelected: (bool value) {
                setState(() {
                  _selectedCategories.clear();
                  if (value) {
                    _selectedCategories.add(faculty.name);
                  }
                  final facultyLocation =
                      LatLng(faculty.latitude, faculty.longitude);
                  _mapController.move(facultyLocation, 17);
                  context.read<MapBloc>().add(
                        FilterFacultiesEvent(_selectedCategories),
                      );
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
            if (_mapController.camera.center.latitude == 0.0 &&
                _mapController.camera.center.longitude == 0.0) {
              _mapController.move(state.currentLocation!, 15);
            }
          }
        },
        builder: (context, state) {
          final filteredFaculties = state.selectedFacultyCategories.isEmpty
              ? Faculty.unsoedFaculties
              : Faculty.unsoedFaculties
                  .where((faculty) =>
                      state.selectedFacultyCategories.contains(faculty.name))
                  .toList();

          return Scaffold(
            body: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: state.currentLocation ?? const LatLng(0, 0),
                    initialZoom: 15,
                    minZoom: 2,
                    maxZoom: 22,
                    interactionOptions: InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                    onMapReady: () {
                      if (state.currentLocation != null) {
                        _mapController.move(state.currentLocation!, 15);
                      }
                    },
                    onMapEvent: (event) {
                      if (event is MapEventRotateEnd) {
                        context.read<MapBloc>().add(
                              ToggleCompassEvent(
                                  _mapController.camera.rotationRad != 0),
                            );
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
                    if (state.currentLocation != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            width: 80,
                            height: 80,
                            point: state.currentLocation!,
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
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                    ),
                                  ),
                                ),
                                if (state.accuracyStatus.isNotEmpty)
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
                                      state.accuracyStatus,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: state.isHighAccuracy
                                            ? AppColors.blue
                                            : AppColors.red,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          ...filteredFaculties.map((faculty) => Marker(
                                width: 120,
                                height: 80,
                                point:
                                    LatLng(faculty.latitude, faculty.longitude),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.school,
                                      color: AppColors.blue,
                                      size: 30,
                                    ),
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
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        faculty.name,
                                        style: TextStyle(
                                          color: AppColors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                  ],
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
                      if (state.showCompass)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
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
                            onPressed: () {
                              _mapController.rotate(0);
                              context
                                  .read<MapBloc>()
                                  .add(ToggleCompassEvent(false));
                              context
                                  .read<MapBloc>()
                                  .add(UpdateBearingEvent(0));
                            },
                            child: Transform.rotate(
                              angle: state.bearing * (3.141592653589793 / 180),
                              child: Icon(
                                Icons.explore,
                                color: AppColors.dark,
                              ),
                            ),
                          ),
                        ),

                      // Location Button
                      FloatingActionButton(
                        backgroundColor: AppColors.blue,
                        onPressed: () {
                          context.read<MapBloc>().add(UpdateLocationEvent());
                          if (!state.isHighAccuracy) {
                            _showAccuracyDialog();
                          }
                          if (state.currentLocation != null) {
                            _mapController.move(state.currentLocation!, 15);
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
