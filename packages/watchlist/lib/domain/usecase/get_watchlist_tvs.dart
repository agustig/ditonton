import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tv/tv.dart' show TvRepository, Tv;

class GetWatchlistTvs {
  final TvRepository repository;

  GetWatchlistTvs(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getWatchlistTvs();
  }
}
