part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent {}

class FetchDetail extends TvDetailEvent {
  final int tvId;

  FetchDetail(this.tvId);
}

class AddToWatchlist extends TvDetailEvent {}

class RemoveFromWatchlist extends TvDetailEvent {}

class ExpandSeason extends TvDetailEvent {
  final TvSeason season;

  ExpandSeason(this.season);
}

class CollapseSeason extends TvDetailEvent {}
