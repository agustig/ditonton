import 'package:mockito/annotations.dart';
import 'package:movie/movie.dart' show MovieRepository;
import 'package:tv/tv.dart' show TvRepository;
import 'package:watchlist/domain/usecase/get_watchlist_movies.dart';
import 'package:watchlist/domain/usecase/get_watchlist_tvs.dart';

@GenerateMocks([
  MovieRepository,
  TvRepository,
  GetWatchlistMovies,
  GetWatchlistTvs,
])
void main() {}
