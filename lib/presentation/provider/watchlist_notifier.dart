import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tvs.dart';
import 'package:flutter/foundation.dart';

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
