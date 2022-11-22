import 'package:core/utils/state_enum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tv/domain/entities/tv.dart';
import 'package:tv/domain/entities/tv_detail.dart';
import 'package:tv/domain/entities/tv_season.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';

class TvDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchlistTvStatus getWatchlistTvStatus;
  final SaveWatchlistTv saveWatchlistTv;
  final RemoveWatchlistTv removeWatchlistTv;

  TvDetailNotifier({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchlistTvStatus,
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
  });

  late TvDetail _tv;
  TvDetail get tv => _tv;

  RequestState _tvState = RequestState.empty;
  RequestState get tvState => _tvState;

  List<Tv> _tvRecommendations = [];
  List<Tv> get tvRecommendations => _tvRecommendations;

  RequestState _recommendationState = RequestState.empty;
  RequestState get recommendationState => _recommendationState;

  TvSeason? _expandedSeason;
  bool isSeasonExpanded(TvSeason season) => (season == _expandedSeason);

  String _message = '';
  String get message => _message;

  bool _isTvAddedToWatchlist = false;
  bool get isTvAddedToWatchlist => _isTvAddedToWatchlist;

  Future<void> fetchTvDetail(int id) async {
    _tvState = RequestState.loading;
    _expandedSeason = null;
    notifyListeners();
    final detailResult = await getTvDetail.execute(id);
    detailResult.fold(
      (failure) {
        _tvState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tv) async {
        _tvState = RequestState.loaded;
        _tv = tv;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTvRecommendations(int id) async {
    _recommendationState = RequestState.loading;
    notifyListeners();

    final recommendationResult = await getTvRecommendations.execute(id);
    recommendationResult.fold(
      (failure) {
        _recommendationState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tvs) {
        _recommendationState = RequestState.loaded;
        _tvRecommendations = tvs;
        notifyListeners();
      },
    );
  }

  Future<void> expandSeason(TvSeason season) async {
    _expandedSeason = season;
    notifyListeners();
  }

  void closeExpandedSeason() {
    _expandedSeason = null;
    notifyListeners();
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addTvToWatchlist(TvDetail tv) async {
    final result = await saveWatchlistTv.execute(tv);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistTvStatus(tv.id);
  }

  Future<void> removeTvFromWatchlist(TvDetail tv) async {
    final result = await removeWatchlistTv.execute(tv);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistTvStatus(tv.id);
  }

  Future<void> loadWatchlistTvStatus(int id) async {
    final result = await getWatchlistTvStatus.execute(id);
    _isTvAddedToWatchlist = result;
    notifyListeners();
  }
}
