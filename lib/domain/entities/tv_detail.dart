import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/tv_season.dart';
import 'package:equatable/equatable.dart';

class TvDetail extends Equatable {
  final int id;
  final String name;
  final String overview;
  final List<Genre> _genres;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<TvSeason> seasons;
  final String posterPath;
  final double voteAverage;

  List<Genre> get genres => _genres;

  TvDetail({
    required this.id,
    required this.name,
    required this.overview,
    List<Genre>? genres,
    this.numberOfEpisodes = -1,
    this.numberOfSeasons = -1,
    required this.seasons,
    required this.posterPath,
    this.voteAverage = -1,
  }) : _genres = genres ?? [];

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        _genres,
        numberOfEpisodes,
        numberOfSeasons,
        seasons,
        posterPath,
        voteAverage,
      ];
}
