import 'package:ditonton/domain/entities/tv_episode.dart';
import 'package:equatable/equatable.dart';

class TvSeason extends Equatable {
  final int id;
  final int seasonNumber;
  final String name;
  final String overview;
  final String? posterPath;
  final String? airDate;
  final List<TvEpisode> episodes;

  TvSeason({
    required this.id,
    required this.seasonNumber,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.airDate,
    required this.episodes,
  });

  @override
  List<Object?> get props => [
        id,
        seasonNumber,
        name,
        overview,
        posterPath,
        airDate,
        episodes,
      ];
}
