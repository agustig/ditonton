import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tv/tv.dart' show Tv, TvRepository;

class SearchTvs {
  final TvRepository repository;

  SearchTvs(this.repository);

  Future<Either<Failure, List<Tv>>> execute(String query) {
    return repository.searchTvs(query);
  }
}
