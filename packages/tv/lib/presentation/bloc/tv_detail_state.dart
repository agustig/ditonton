part of 'tv_detail_bloc.dart';

abstract class TvDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TvDetailEmpty extends TvDetailState {}

class TvDetailLoading extends TvDetailState {}

class TvDetailHasData extends TvDetailState {
  final TvDetail detail;
  final List<Tv> tvRecommendations;
  final bool _isOnWatchlist;
  final String _watchlistMessage;
  final TvSeason? _expandedSeason;

  bool get isAddedToWatchlist => _isOnWatchlist;
  String get watchlistMessage => _watchlistMessage;
  TvSeason? get expandedSeason => _expandedSeason;

  TvDetailHasData({
    required this.detail,
    required this.tvRecommendations,
    required bool isOnWatchlist,
    String watchlistMessage = '',
    TvSeason? expandedSeason,
  })  : _isOnWatchlist = isOnWatchlist,
        _watchlistMessage = watchlistMessage,
        _expandedSeason = expandedSeason;

  TvDetailHasData changeAttr({
    bool? isOnWatchlist,
    String watchlistMessage = '',
    TvSeason? expandedSeason,
  }) {
    return TvDetailHasData(
      detail: detail,
      tvRecommendations: tvRecommendations,
      isOnWatchlist: isOnWatchlist ?? _isOnWatchlist,
      watchlistMessage: watchlistMessage,
      expandedSeason: expandedSeason ?? _expandedSeason,
    );
  }

  @override
  List<Object?> get props => [
        detail,
        tvRecommendations,
        _isOnWatchlist,
        _watchlistMessage,
        _expandedSeason
      ];
}

class TvDetailError extends TvDetailState {
  final String message;

  TvDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
