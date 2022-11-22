import 'package:mockito/annotations.dart';
import 'package:movie/movie.dart';
import 'package:search/domain/usecase/search_movies.dart';
import 'package:search/domain/usecase/search_tvs.dart';
import 'package:tv/tv.dart' show TvRepository;

@GenerateMocks([
  MovieRepository,
  TvRepository,
  SearchMovies,
  SearchTvs,
])
void main() {}
