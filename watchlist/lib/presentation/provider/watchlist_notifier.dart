import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart' show Tv;
import 'package:watchlist/domain/usecase/get_watchlist_movies.dart';
import 'package:watchlist/domain/usecase/get_watchlist_tvs.dart';

class WatchlistNotifier extends ChangeNotifier {
  var _watchlistMovies = <Movie>[];
  List<Movie> get watchlistMovies => _watchlistMovies;

  var _watchlistTvs = <Tv>[];
  List<Tv> get watchlistTvs => _watchlistTvs;

  var _watchlistState = RequestState.empty;
  RequestState get watchlistState => _watchlistState;

  String _message = '';
  String get message => _message;

  WatchlistNotifier({
    required this.getWatchlistMovies,
    required this.getWatchlistTvs,
  });

  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchlistTvs getWatchlistTvs;

  Future<void> fetchWatchlist() async {
    _watchlistState = RequestState.loading;
    notifyListeners();

    final movieResult = await getWatchlistMovies.execute();
    final tvResult = await getWatchlistTvs.execute();

    Failure? failureData;

    movieResult.fold(
      (failure) {
        failureData = failure;
      },
      (moviesData) {
        _watchlistMovies = moviesData;
      },
    );

    tvResult.fold(
      (failure) {
        failureData = failure;
      },
      (tvsData) {
        _watchlistTvs = tvsData;
      },
    );

    if (failureData != null) {
      _watchlistState = RequestState.error;
      _message = failureData!.message;
    } else {
      _watchlistState = RequestState.loaded;
    }
    notifyListeners();
  }
}
