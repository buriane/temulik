part of 'map_bloc.dart';

abstract class MapEvent {}

class InitializeMapEvent extends MapEvent {}

class UpdateLocationEvent extends MapEvent {}

class UpdateBearingEvent extends MapEvent {
  final double bearing;
  UpdateBearingEvent(this.bearing);
}

class ToggleCompassEvent extends MapEvent {
  final bool showCompass;
  ToggleCompassEvent(this.showCompass);
}

class FilterFacultiesEvent extends MapEvent {
  final List<String> selectedCategories;
  FilterFacultiesEvent(this.selectedCategories);
}