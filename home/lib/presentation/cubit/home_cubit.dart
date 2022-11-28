import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetNowPlayingMovies _getNowPlayingMovies;
  final GetPopularMovies _getPopularMovies;
  final GetTopRatedMovies _getTopRatedMovies;
  final GetOnTheAirTvs _getOnTheAirTvs;
  final GetPopularTvs _getPopularTvs;
  final GetTopRatedTvs _getTopRatedTvs;

  HomeCubit({
    required GetNowPlayingMovies getNowPlayingMovies,
    required GetPopularMovies getPopularMovies,
    required GetTopRatedMovies getTopRatedMovies,
    required GetOnTheAirTvs getOnTheAirTvs,
    required GetPopularTvs getPopularTvs,
    required GetTopRatedTvs getTopRatedTvs,
  })  : _getNowPlayingMovies = getNowPlayingMovies,
        _getPopularMovies = getPopularMovies,
        _getTopRatedMovies = getTopRatedMovies,
        _getOnTheAirTvs = getOnTheAirTvs,
        _getPopularTvs = getPopularTvs,
        _getTopRatedTvs = getTopRatedTvs,
        super(HomeEmpty());

  void fetch() async {
    emit(HomeLoading());
    try {
      final nowPlayingMoviesExe = await _getNowPlayingMovies.execute();
      final popularMoviesExe = await _getPopularMovies.execute();
      final topRatedMoviesExe = await _getTopRatedMovies.execute();
      final onTheAirTvsExe = await _getOnTheAirTvs.execute();
      final popularTvsExe = await _getPopularTvs.execute();
      final topRatedTvsExe = await _getTopRatedTvs.execute();

      late final List<Movie> nowPlayingMoviesResult;
      late final List<Movie> popularMoviesResult;
      late final List<Movie> topRatedMoviesResult;
      late final List<Tv> onTheAirTvsResult;
      late final List<Tv> popularTvsResult;
      late final List<Tv> topRatedTvsResult;

      nowPlayingMoviesExe.fold(
        (failure) => throw failure,
        (movies) => nowPlayingMoviesResult = movies,
      );
      popularMoviesExe.fold(
        (failure) => throw failure,
        (movies) => popularMoviesResult = movies,
      );
      topRatedMoviesExe.fold(
        (failure) => throw failure,
        (movies) => topRatedMoviesResult = movies,
      );
      onTheAirTvsExe.fold(
        (failure) => throw failure,
        (tvs) => onTheAirTvsResult = tvs,
      );
      popularTvsExe.fold(
        (failure) => throw failure,
        (tvs) => popularTvsResult = tvs,
      );
      topRatedTvsExe.fold(
        (failure) => throw failure,
        (tvs) => topRatedTvsResult = tvs,
      );
      emit(HomeHasData(
        nowPlayingMovies: nowPlayingMoviesResult,
        popularMovies: popularMoviesResult,
        topRatedMovies: topRatedMoviesResult,
        onTheAirTvs: onTheAirTvsResult,
        popularTvs: popularTvsResult,
        topRatedTvs: topRatedTvsResult,
      ));
    } on Failure catch (failure) {
      emit(HomeError(failure.message));
    }
  }
}
