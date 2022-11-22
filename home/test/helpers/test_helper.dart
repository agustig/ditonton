import 'package:mockito/annotations.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';

@GenerateMocks([
  GetNowPlayingMovies,
  GetPopularMovies,
  GetTopRatedMovies,
  GetOnTheAirTvs,
  GetPopularTvs,
  GetTopRatedTvs,
])
void main() {}
