import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';

class MovieModel extends Equatable {
  const MovieModel({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.title,
  });

  final int id;
  final String overview;
  final String? posterPath;
  final String title;

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
        id: json["id"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "overview": overview,
        "poster_path": posterPath,
        "title": title,
      };

  Movie toEntity() {
    return Movie(
      id: id,
      overview: overview,
      posterPath: posterPath,
      title: title,
    );
  }

  @override
  List<Object?> get props => [
        id,
        overview,
        posterPath,
        title,
      ];
}
