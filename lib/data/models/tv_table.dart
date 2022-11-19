import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TvTable extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String posterPath;

  TvTable({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
  });

  factory TvTable.fromJson(Map<String, dynamic> json) {
    return TvTable(
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      posterPath: json['poster_path'],
    );
  }

  factory TvTable.fromEntity(TvDetail tv) {
    return TvTable(
      id: tv.id,
      name: tv.name,
      overview: tv.overview,
      posterPath: tv.posterPath,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'overview': overview,
        'poster_path': posterPath,
      };

  Tv toEntity() {
    return Tv(
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        posterPath,
      ];
}
