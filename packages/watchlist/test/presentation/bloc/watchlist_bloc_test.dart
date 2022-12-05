import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watchlist/domain/usecase/get_watchlist_movies.dart';
import 'package:watchlist/domain/usecase/get_watchlist_tvs.dart';
import 'package:watchlist/presentation/cubit/watchlist_cubit.dart';

import '../../dummy_data/dummy_object.dart';

class MockGetWatchlistMovies extends Mock implements GetWatchlistMovies {}

class MockGetWatchlistTvs extends Mock implements GetWatchlistTvs {}

void main() {
  late WatchlistCubit watchlistCubit;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchlistTvs mockGetWatchlistTvs;
  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchlistTvs = MockGetWatchlistTvs();
    watchlistCubit = WatchlistCubit(
      getWatchlistMovies: mockGetWatchlistMovies,
      getWatchlistTvs: mockGetWatchlistTvs,
    );
  });

  test('initial state should be empty', () {
    expect(watchlistCubit.state, WatchlistEmpty());
  });

  blocTest(
    'Should state has [WatchlistLoading, WatchlistHasData] when get watchlist is successful',
    build: () {
      when(() => mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(testWatchlistMovieList));
      when(() => mockGetWatchlistTvs.execute())
          .thenAnswer((_) async => Right(testWatchlistTvList));
      return watchlistCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [
      WatchlistLoading(),
      WatchlistHasData(
        movies: testWatchlistMovieList,
        tvs: testWatchlistTvList,
      ),
    ],
  );

  blocTest(
    'Should state has [WatchlistLoading, WatchlistError] when get movie watchlist is error',
    build: () {
      when(() => mockGetWatchlistMovies.execute()).thenAnswer((_) async =>
          const Left(DatabaseFailure('Error when get data from Local')));
      when(() => mockGetWatchlistTvs.execute())
          .thenAnswer((_) async => Right(testWatchlistTvList));
      return watchlistCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [
      WatchlistLoading(),
      WatchlistError('Error when get data from Local'),
    ],
  );

  blocTest(
    'Should state has [WatchlistLoading, WatchlistError] when get tv watchlist is error',
    build: () {
      when(() => mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(testWatchlistMovieList));
      when(() => mockGetWatchlistTvs.execute()).thenAnswer((_) async =>
          const Left(DatabaseFailure('Error when get data from Local')));
      return watchlistCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [
      WatchlistLoading(),
      WatchlistError('Error when get data from Local'),
    ],
  );
}
