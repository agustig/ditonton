import 'package:core/data/datasources/db/database_helper.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:tv/data/datasources/tv_local_data_source.dart';
import 'package:tv/data/datasources/tv_remote_data_source.dart';
import 'package:tv/domain/repositories/tv_repository.dart';
import 'package:tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:tv/presentation/provider/on_the_air_tvs_notifier.dart';
import 'package:tv/presentation/provider/popular_tvs_notifier.dart';
import 'package:tv/presentation/provider/top_rated_tvs_notifier.dart';
import 'package:tv/presentation/provider/tv_detail_notifier.dart';

@GenerateMocks([
  DatabaseHelper,
  TvRemoteDataSource,
  TvLocalDataSource,
  TvRepository,
  GetOnTheAirTvs,
  GetPopularTvs,
  GetTopRatedTvs,
  GetTvDetail,
  GetTvRecommendations,
  GetWatchlistTvStatus,
  SaveWatchlistTv,
  OnTheAirTvsNotifier,
  PopularTvsNotifier,
  TopRatedTvsNotifier,
  TvDetailNotifier,
  RemoveWatchlistTv,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient),
])
void main() {}
