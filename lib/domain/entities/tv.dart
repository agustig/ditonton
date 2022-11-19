import 'package:equatable/equatable.dart';

class Tv extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String posterPath;

  Tv({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        posterPath,
      ];
}
