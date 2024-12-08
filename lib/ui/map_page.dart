import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:temulik/bloc/map_bloc.dart';
import 'package:temulik/constants/colors.dart';
import 'package:temulik/services/geolocation_mobile.dart';
import 'package:temulik/models/faculty.dart';
import 'package:temulik/ui/components/components.dart';
import 'package:temulik/ui/detail_barang_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final List<String> _selectedCategories = [];
  final CollectionReference laporanRef =
      FirebaseFirestore.instance.collection('laporan');

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
                    StreamBuilder<QuerySnapshot>(
                      stream: laporanRef.snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const MarkerLayer(markers: []);
                        }

                        List<Marker> markers = [];
                        for (var doc in snapshot.data!.docs) {
                          final data = doc.data() as Map<String, dynamic>;
                          final pinPointStr = data['pinPoint'] as String;
                          final coordinates = pinPointStr.split(',');
                          if (coordinates.length == 2) {
                            final lat = double.parse(coordinates[0].trim());
                            final lng = double.parse(coordinates[1].trim());

                            markers.add(
                              Marker(
                                point: LatLng(lat, lng),
                                width: 40,
                                height: 40,
                                child: GestureDetector(
                                  onTap: () =>
                                      _showLaporanDetail(context, data),
                                  child: Icon(
                                    Icons.place,
                                    color: data['status'] == 'Dalam Proses'
                                        ? Colors.red
                                        : Colors.green,
                                    size: 40,
                                  ),
                                ),
                              ),
                            );
                          }
                        }

                        return MarkerLayer(markers: markers);
                      },
                    ),
                  ],
                ),
                FacultyFilter(
                  selectedCategories: _selectedCategories,
                  onFacultySelected: (facultyName, value) {
                    setState(() {
                      _selectedCategories.clear();
                      if (value) {
                        _selectedCategories.add(facultyName);
                      }
                    });
                  },
                  mapController: _mapController,
                  context: context,
                ),
                MapButtons(
                  mapController: _mapController,
                  state: state,
                  context: context
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLaporanDetail(BuildContext context, Map<String, dynamic> laporanData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailBarangPage(
          activityData: laporanData,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
