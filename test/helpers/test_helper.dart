import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';
import 'package:ditonton/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvs.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tvs.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tv_status.dart';
import 'package:ditonton/domain/usecases/get_watchlist_tvs.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/search_tvs.dart';
import 'package:ditonton/presentation/provider/popular_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:ditonton/presentation/provider/on_the_air_tvs_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  MovieRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  GetWatchlistMovies,
  TvRepository,
  TvRemoteDataSource,
  TvLocalDataSource,
  DatabaseHelper,
  GetOnTheAirTvs,
  GetPopularTvs,
  GetTopRatedTvs,
  GetTvDetail,
  GetTvRecommendations,
  SearchTvs,
  OnTheAirTvsNotifier,
  PopularTvsNotifier,
  TopRatedTvsNotifier,
  GetWatchlistTvs,
  GetWatchlistTvStatus,
  SaveWatchlistTv,
  RemoveWatchlistTv,
  TvDetailNotifier,
  WatchlistNotifier,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
