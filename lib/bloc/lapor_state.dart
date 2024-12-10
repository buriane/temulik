part of 'lapor_bloc.dart';

abstract class LaporState extends Equatable {
  const LaporState();

  @override
  List<Object> get props => [];
}

class LaporInitial extends LaporState {}

class LaporLoading extends LaporState {}

class LaporSuccess extends LaporState {}

class LaporError extends LaporState {
  final String errorMessage;

  const LaporError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

class PahlawanAdded extends LaporState {}
