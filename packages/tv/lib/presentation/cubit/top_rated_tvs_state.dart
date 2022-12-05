part of 'top_rated_tvs_cubit.dart';

abstract class TopRatedTvsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TopRatedTvsEmpty extends TopRatedTvsState {}

class TopRatedTvsLoading extends TopRatedTvsState {}

class TopRatedTvsHasData extends TopRatedTvsState {
  final List<Tv> tvs;

  TopRatedTvsHasData(this.tvs);

  @override
  List<Object?> get props => [tvs];
}

class TopRatedTvsError extends TopRatedTvsState {
  final String message;

  TopRatedTvsError(this.message);

  @override
  List<Object?> get props => [message];
}
