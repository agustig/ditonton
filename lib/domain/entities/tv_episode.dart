import 'package:equatable/equatable.dart';

class TvEpisode extends Equatable {
  final int id;
  final int episodeNumber;
  final String name;
  final String overview;
  final int seasonNumber;
  final int showId;
  final int? runtime;
  final String? stillPath;

  TvEpisode({
    required this.id,
    required this.episodeNumber,
    required this.name,
    required this.overview,
    required this.seasonNumber,
    required this.showId,
    required this.runtime,
    required this.stillPath,
  });

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
