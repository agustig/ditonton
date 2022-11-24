import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';
import 'package:watchlist/watchlist.dart';

part 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  final GetWatchlistMovies _getWatchlistMovies;
  final GetWatchlistTvs _getWatchlistTvs;

  WatchlistCubit({
    required GetWatchlistMovies getWatchlistMovies,
    required GetWatchlistTvs getWatchlistTvs,
  })  : _getWatchlistMovies = getWatchlistMovies,
        _getWatchlistTvs = getWatchlistTvs,
        super(WatchlistEmpty());

  void fetchWatchlist() async {
    emit(WatchlistLoading());
    try {
      final moviesGet = await _getWatchlistMovies.execute();
      final tvsGet = await _getWatchlistTvs.execute();

      late List<Movie> movieResults;
      late List<Tv> tvResults;

      moviesGet.fold(
        (failure) => throw failure,
        (data) => movieResults = data,
      );
      tvsGet.fold(
        (failure) => throw failure,
        (data) => tvResults = data,
      );

      emit(WatchlistHasData(movies: movieResults, tvs: tvResults));
    } on Failure catch (failure) {
      emit(WatchlistError(failure.message));
    }
  }
}
