import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/entities/tv_season.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail _getTvDetail;
  final GetTvRecommendations _getTvRecommendations;
  final GetWatchlistTvStatus _getWatchlistTvStatus;
  final SaveWatchlistTv _saveWatchlistTv;
  final RemoveWatchlistTv _removeWatchlistTv;

  late TvDetailHasData _currentTvDataState;

  TvDetailBloc({
    required GetTvDetail getTvDetail,
    required GetTvRecommendations getTvRecommendations,
    required GetWatchlistTvStatus getWatchlistTvStatus,
    required SaveWatchlistTv saveWatchlistTv,
    required RemoveWatchlistTv removeWatchlistTv,
  })  : _getTvDetail = getTvDetail,
        _getTvRecommendations = getTvRecommendations,
        _getWatchlistTvStatus = getWatchlistTvStatus,
        _saveWatchlistTv = saveWatchlistTv,
        _removeWatchlistTv = removeWatchlistTv,
        super(TvDetailEmpty()) {
    on<FetchDetail>(_onFetchDetail);
    on<AddToWatchlist>(_onAddToWatchlist);
    on<RemoveFromWatchlist>(_onRemoveFromWatchlist);
    on<ExpandSeason>(_onExpandSeason);
    on<CollapseSeason>(_onCloseExpandedSeason);
  }

  _onFetchDetail(FetchDetail event, Emitter<TvDetailState> emit) async {
    emit(TvDetailLoading());

    try {
      final tvId = event.tvId;
      final getDetail = await _getTvDetail.execute(tvId);
      final getRecommendations = await _getTvRecommendations.execute(tvId);
      final getWatchlistStatus = await _getWatchlistTvStatus.execute(tvId);

      late final TvDetail detailResult;
      late final List<Tv> recommendationResult;

      getDetail.fold(
        (failure) => throw failure,
        (data) => detailResult = data,
      );
      getRecommendations.fold(
        (failure) => throw failure,
        (data) => recommendationResult = data,
      );

      _currentTvDataState = TvDetailHasData(
        detail: detailResult,
        tvRecommendations: recommendationResult,
        isOnWatchlist: getWatchlistStatus,
      );

      emit(_currentTvDataState);
    } on Failure catch (failure) {
      emit(TvDetailError(failure.message));
    } on DatabaseException catch (error) {
      emit(TvDetailError(error.message));
    }
  }

  _onAddToWatchlist(AddToWatchlist event, Emitter<TvDetailState> emit) async {
    final tvDetail = _currentTvDataState.detail;
    try {
      final saveWatchlist = await _saveWatchlistTv.execute(tvDetail);
      late final String saveMessage;

      saveWatchlist.fold(
        (failure) => saveMessage = failure.message,
        (result) => saveMessage = result,
      );

      final watchlistStatus = await _getWatchlistTvStatus.execute(tvDetail.id);

      _currentTvDataState = _currentTvDataState.changeAttr(
        isOnWatchlist: watchlistStatus,
        watchlistMessage: saveMessage,
      );

      emit(_currentTvDataState);
    } on DatabaseException catch (e) {
      emit(TvDetailError(e.message));
    }
  }

  _onRemoveFromWatchlist(
    RemoveFromWatchlist event,
    Emitter<TvDetailState> emit,
  ) async {
    final tvDetail = _currentTvDataState.detail;

    try {
      final removeWatchlist = await _removeWatchlistTv.execute(tvDetail);
      late final String removeMessage;

      removeWatchlist.fold(
        (failure) => removeMessage = failure.message,
        (message) => removeMessage = message,
      );

      final watchlistStatus = await _getWatchlistTvStatus.execute(tvDetail.id);

      _currentTvDataState = _currentTvDataState.changeAttr(
        watchlistMessage: removeMessage,
        isOnWatchlist: watchlistStatus,
      );

      emit(_currentTvDataState);
    } on DatabaseException catch (e) {
      emit(TvDetailError(e.message));
    }
  }

  _onExpandSeason(ExpandSeason event, Emitter<TvDetailState> emit) =>
      emit(_currentTvDataState.changeAttr(expandedSeason: event.season));

  _onCloseExpandedSeason(
    CollapseSeason event,
    Emitter<TvDetailState> emit,
  ) =>
      emit(_currentTvDataState.changeAttr(expandedSeason: null));
}
