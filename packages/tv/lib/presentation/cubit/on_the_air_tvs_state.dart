part of 'on_the_air_tvs_cubit.dart';

abstract class OnTheAirTvsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnTheAirTvsEmpty extends OnTheAirTvsState {}

class OnTheAirTvsLoading extends OnTheAirTvsState {}

class OnTheAirTvsHasData extends OnTheAirTvsState {
  final List<Tv> tvs;

  OnTheAirTvsHasData(this.tvs);

  @override
  List<Object?> get props => [tvs];
}

class OnTheAirTvsError extends OnTheAirTvsState {
  final String message;

  OnTheAirTvsError(this.message);

  @override
  List<Object?> get props => [message];
}
