import 'package:ditonton/domain/entities/tv_episode.dart';
import 'package:equatable/equatable.dart';

class TvEpisodeModel extends Equatable {
  final int id;
  final int episodeNumber;
  final String name;
  final String overview;
  final int seasonNumber;
  final int showId;
  final int? runtime;
  final String? stillPath;

  TvEpisodeModel({
    required this.id,
    required this.episodeNumber,
    required this.name,
    required this.overview,
    required this.seasonNumber,
    required this.showId,
    required this.runtime,
    required this.stillPath,
  });

  factory TvEpisodeModel.fromJson(Map<String, dynamic> json) {
    return TvEpisodeModel(
      id: json['id'],
      episodeNumber: json['episode_number'],
      name: json['name'],
      overview: json['overview'],
      seasonNumber: json['season_number'],
      showId: json['show_id'],
      runtime: json['runtime'],
      stillPath: json['still_path'],
    );
  }

  TvEpisode toEntity() {
    return TvEpisode(
      id: id,
      episodeNumber: episodeNumber,
      name: name,
      overview: overview,
      seasonNumber: seasonNumber,
      showId: showId,
      runtime: runtime,
      stillPath: stillPath,
    );
  }

  @override
  List<Object?> get props => [
        id,
        episodeNumber,
        name,
        overview,
        seasonNumber,
        showId,
        runtime,
        stillPath,
      ];
}
