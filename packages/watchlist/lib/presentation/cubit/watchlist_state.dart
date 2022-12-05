part of 'watchlist_cubit.dart';

abstract class WatchlistState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WatchlistEmpty extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistHasData extends WatchlistState {
  final List<Movie> movies;
  final List<Tv> tvs;

  WatchlistHasData({
    required this.movies,
    required this.tvs,
  });

  @override
  List<Object?> get props => [
        movies,
        tvs,
      ];
}

class WatchlistError extends WatchlistState {
  final String message;

  WatchlistError(this.message);
}
