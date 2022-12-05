part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchEmpty extends SearchState {}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchHasData extends SearchState {
  final List<Movie> movies;
  final List<Tv> tvs;

  SearchHasData({required this.movies, required this.tvs});

  @override
  List<Object?> get props => [movies, tvs];
}
