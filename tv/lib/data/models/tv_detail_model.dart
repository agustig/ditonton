import 'package:core/data/models/genre_model.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/data/models/tv_season_model.dart';
import 'package:tv/domain/entities/tv_detail.dart';

class TvDetailModel extends Equatable {
  final int id;
  final String name;
  final String overview;
  final List<GenreModel> genres;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<TvSeasonModel> seasons;
  final String posterPath;
  final double voteAverage;

  const TvDetailModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.genres,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.seasons,
    required this.posterPath,
    required this.voteAverage,
  });

  factory TvDetailModel.fromJson(Map<String, dynamic> json) {
    return TvDetailModel(
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      genres: List.from(json["genres"].map((x) => GenreModel.fromJson(x))),
      numberOfEpisodes: json['number_of_episodes'],
      numberOfSeasons: json['number_of_seasons'],
      seasons: List.from(json['seasons'].map((x) => TvSeasonModel.fromJson(x))),
      posterPath: json['poster_path'],
      voteAverage: json['vote_average'],
    );
  }

  TvDetail toEntity() {
    return TvDetail(
      id: id,
      name: name,
      overview: overview,
      genres: List.of(genres.map((genre) => genre.toEntity())),
      numberOfEpisodes: numberOfEpisodes,
      numberOfSeasons: numberOfSeasons,
      seasons: List.of(seasons.map((season) => season.toEntity())),
      posterPath: posterPath,
      voteAverage: voteAverage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        genres,
        numberOfEpisodes,
        numberOfSeasons,
        seasons,
        posterPath,
        voteAverage,
      ];
}
