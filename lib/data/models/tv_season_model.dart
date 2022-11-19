import 'package:ditonton/data/models/tv_episode_model.dart';
import 'package:ditonton/domain/entities/tv_season.dart';
import 'package:equatable/equatable.dart';

class TvSeasonModel extends Equatable {
  final int id;
  final int seasonNumber;
  final String name;
  final String overview;
  final String? posterPath;
  final String? airDate;
  final List<TvEpisodeModel> _episodes;

  List<TvEpisodeModel> get episodes => _episodes;

  TvSeasonModel({
    required this.id,
    required this.seasonNumber,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.airDate,
    List<TvEpisodeModel>? episodes,
  }) : _episodes = episodes ?? [];

  factory TvSeasonModel.fromJson(Map<String, dynamic> json) {
    final jsonEpisodes = json['episodes'] ?? [];
    return TvSeasonModel(
      id: json['id'],
      seasonNumber: json['season_number'],
      name: json['name'],
      overview: json['overview'],
      posterPath: json['poster_path'],
      airDate: json['air_date'],
      episodes:
          List.from((jsonEpisodes).map((e) => TvEpisodeModel.fromJson(e))),
    );
  }

  TvSeason toEntity() {
    return TvSeason(
      id: id,
      seasonNumber: seasonNumber,
      name: name,
      overview: overview,
      posterPath: posterPath,
      airDate: airDate,
      episodes: List.of(_episodes.map((episode) => episode.toEntity())),
    );
  }

  @override
  List<Object?> get props => [
        id,
        seasonNumber,
        name,
        overview,
        posterPath,
        airDate,
        _episodes,
      ];
}
