import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail _getMovieDetail;
  final GetMovieRecommendations _getMovieRecommendations;
  final GetWatchlistMovieStatus _getWatchlistMovieStatus;
  final SaveWatchlistMovie _saveWatchlistMovie;
  final RemoveWatchlistMovie _removeWatchlistMovie;

  late MovieDetailHasData _currentMovieDataState;

  MovieDetailBloc({
    required GetMovieDetail getMovieDetail,
    required GetMovieRecommendations getMovieRecommendations,
    required GetWatchlistMovieStatus getWatchlistMovieStatus,
    required SaveWatchlistMovie saveWatchlistMovie,
    required RemoveWatchlistMovie removeWatchlistMovie,
  })  : _getMovieDetail = getMovieDetail,
        _getMovieRecommendations = getMovieRecommendations,
        _getWatchlistMovieStatus = getWatchlistMovieStatus,
        _saveWatchlistMovie = saveWatchlistMovie,
        _removeWatchlistMovie = removeWatchlistMovie,
        super(MovieDetailEmpty()) {
    on<FetchMovieDetail>(_onFetchDetail);
    on<AddMovieToWatchlist>(_onAddToWatchlist);
    on<RemoveMovieFromWatchlist>(_onRemoveFromWatchlist);
  }

  _onFetchDetail(FetchMovieDetail event, Emitter<MovieDetailState> emit) async {
    emit(MovieDetailLoading());

    try {
      final movieId = event.movieId;
      final getDetail = await _getMovieDetail.execute(movieId);
      final getRecommendations =
          await _getMovieRecommendations.execute(movieId);
      final getWatchlistStatus =
          await _getWatchlistMovieStatus.execute(movieId);

      late final MovieDetail detailResult;
      late final List<Movie> recommendationResult;

      getDetail.fold(
        (failure) => throw failure,
        (data) => detailResult = data,
      );
      getRecommendations.fold(
        (failure) => throw failure,
        (data) => recommendationResult = data,
      );

      _currentMovieDataState = MovieDetailHasData(
        detail: detailResult,
        movieRecommendations: recommendationResult,
        isOnWatchlist: getWatchlistStatus,
      );

      debugPrint('emit called');
      emit(_currentMovieDataState);
    } on Failure catch (failure) {
      emit(MovieDetailError(failure.message));
    } on DatabaseException catch (error) {
      emit(MovieDetailError(error.message));
    }
  }

  _onAddToWatchlist(
      AddMovieToWatchlist event, Emitter<MovieDetailState> emit) async {
    final movieDetail = _currentMovieDataState.detail;
    try {
      final saveWatchlist = await _saveWatchlistMovie.execute(movieDetail);
      late final String saveMessage;

      saveWatchlist.fold(
        (failure) => saveMessage = failure.message,
        (result) => saveMessage = result,
      );

      final watchlistStatus =
          await _getWatchlistMovieStatus.execute(movieDetail.id);

      _currentMovieDataState = _currentMovieDataState.changeAttr(
        isOnWatchlist: watchlistStatus,
        watchlistMessage: saveMessage,
      );

      emit(_currentMovieDataState);
    } on DatabaseException catch (e) {
      emit(MovieDetailError(e.message));
    }
  }

  _onRemoveFromWatchlist(
    RemoveMovieFromWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final movieDetail = _currentMovieDataState.detail;

    try {
      final removeWatchlist = await _removeWatchlistMovie.execute(movieDetail);
      late final String removeMessage;

      removeWatchlist.fold(
        (failure) => removeMessage = failure.message,
        (message) => removeMessage = message,
      );

      final watchlistStatus =
          await _getWatchlistMovieStatus.execute(movieDetail.id);

      _currentMovieDataState = _currentMovieDataState.changeAttr(
        watchlistMessage: removeMessage,
        isOnWatchlist: watchlistStatus,
      );

      emit(_currentMovieDataState);
    } on DatabaseException catch (e) {
      emit(MovieDetailError(e.message));
    }
  }
}
