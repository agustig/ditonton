import 'package:equatable/equatable.dart';
import 'package:tv/domain/entities/tv.dart';

class TvModel extends Equatable {
  final int id;
  final String overview;
  final String? posterPath;
  final String name;

  const TvModel({
    required this.id,
    required this.overview,
    required this.name,
    required this.posterPath,
  });

  factory TvModel.fromJson(Map<String, dynamic> json) {
    return TvModel(
      id: json['id'],
      overview: json['overview'],
      name: json['name'],
      posterPath: json['poster_path'],
    );
  }

  Tv toEntity() {
    return Tv(
      id: id,
      overview: overview,
      posterPath: posterPath!,
      name: name,
    );
  }

  @override
  List<Object?> get props => [
        id,
        overview,
        posterPath,
        name,
      ];
}
