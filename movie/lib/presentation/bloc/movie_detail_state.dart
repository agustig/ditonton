part of 'movie_detail_bloc.dart';

abstract class MovieDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieDetailEmpty extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailHasData extends MovieDetailState {
  final MovieDetail detail;
  final List<Movie> movieRecommendations;
  final bool _isOnWatchlist;
  final String _watchlistMessage;

  bool get isAddedToWatchlist => _isOnWatchlist;
  String get watchlistMessage => _watchlistMessage;

  MovieDetailHasData({
    required this.detail,
    required this.movieRecommendations,
    required bool isOnWatchlist,
    String watchlistMessage = '',
  })  : _isOnWatchlist = isOnWatchlist,
        _watchlistMessage = watchlistMessage;

  MovieDetailHasData changeAttr({
    bool? isOnWatchlist,
    String watchlistMessage = '',
  }) {
    return MovieDetailHasData(
      detail: detail,
      movieRecommendations: movieRecommendations,
      isOnWatchlist: isOnWatchlist ?? _isOnWatchlist,
      watchlistMessage: watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
        detail,
        movieRecommendations,
        _isOnWatchlist,
        _watchlistMessage,
      ];
}

class MovieDetailError extends MovieDetailState {
  final String message;

  MovieDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
