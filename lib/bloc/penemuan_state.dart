part of 'penemuan_bloc.dart';

abstract class PenemuanState extends Equatable {
  const PenemuanState();

  @override
  List<Object> get props => [];
}

class PenemuanInitial extends PenemuanState {}

class PenemuanLoading extends PenemuanState {}

class PenemuanSuccess extends PenemuanState {}

class PenemuanError extends PenemuanState {
  final String errorMessage;

  const PenemuanError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
