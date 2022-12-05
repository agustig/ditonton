part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent {}

class FetchTvDetail extends TvDetailEvent {
  final int tvId;

  FetchTvDetail(this.tvId);
}

class AddTvToWatchlist extends TvDetailEvent {}

class RemoveTvFromWatchlist extends TvDetailEvent {}

class ExpandSeason extends TvDetailEvent {
  final TvSeason season;

  ExpandSeason(this.season);
}

class CollapseSeason extends TvDetailEvent {}
