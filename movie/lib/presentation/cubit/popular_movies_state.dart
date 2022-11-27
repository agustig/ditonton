part of 'popular_movies_cubit.dart';

abstract class PopularMoviesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PopularMoviesEmpty extends PopularMoviesState {}

class PopularMoviesLoading extends PopularMoviesState {}

class PopularMoviesHasData extends PopularMoviesState {
  final List<Movie> movies;

  PopularMoviesHasData(this.movies);

  @override
  List<Object?> get props => [movies];
}

class PopularMoviesError extends PopularMoviesState {
  final String message;

  PopularMoviesError(this.message);

  @override
  List<Object?> get props => [message];
}
