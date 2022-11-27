import 'package:movie/domain/repositories/movie_repository.dart';

class GetWatchlistMovieStatus {
  final MovieRepository repository;

  GetWatchlistMovieStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
