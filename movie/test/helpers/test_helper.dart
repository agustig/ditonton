import 'package:core/data/datasources/db/database_helper.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:movie/data/datasources/movie_local_data_source.dart';
import 'package:movie/data/datasources/movie_remote_data_source.dart';
import 'package:movie/domain/repositories/movie_repository.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:movie/presentation/provider/movie_detail_notifier.dart';
import 'package:movie/presentation/provider/popular_movies_notifier.dart';
import 'package:movie/presentation/provider/top_rated_movies_notifier.dart';

@GenerateMocks([
  DatabaseHelper,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  MovieRepository,
  GetMovieDetail,
  GetMovieRecommendations,
  GetPopularMovies,
  GetTopRatedMovies,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
  MovieDetailNotifier,
  PopularMoviesNotifier,
  TopRatedMoviesNotifier,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
