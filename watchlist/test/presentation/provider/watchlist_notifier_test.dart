import 'package:core/utils/failure.dart';
import 'package:core/utils/state_enum.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/presentation/provider/watchlist_notifier.dart';

import '../../dummy_data/dummy_object.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late WatchlistNotifier provider;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchlistTvs mockGetWatchlistTvs;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchlistTvs = MockGetWatchlistTvs();
    provider = WatchlistNotifier(
      getWatchlistMovies: mockGetWatchlistMovies,
      getWatchlistTvs: mockGetWatchlistTvs,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  test('should change movies and Tvs data when data is gotten successfully',
      () async {
    // arrange
    when(mockGetWatchlistMovies.execute())
        .thenAnswer((_) async => const Right([testWatchlistMovie]));
    when(mockGetWatchlistTvs.execute())
        .thenAnswer((_) async => const Right([testWatchlistTv]));
    // act
    await provider.fetchWatchlist();
    // assert
    expect(provider.watchlistState, RequestState.loaded);
    expect(provider.watchlistMovies, [testWatchlistMovie]);
    expect(provider.watchlistTvs, [testWatchlistTv]);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetWatchlistMovies.execute())
        .thenAnswer((_) async => const Left(DatabaseFailure("Can't get data")));
    when(mockGetWatchlistTvs.execute())
        .thenAnswer((_) async => const Left(DatabaseFailure("Can't get data")));
    // act
    await provider.fetchWatchlist();
    // assert
    expect(provider.watchlistState, RequestState.error);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 2);
  });

  test('should return state error when Movies data is unsuccessful', () async {
    // arrange
    when(mockGetWatchlistMovies.execute())
        .thenAnswer((_) async => const Left(DatabaseFailure("Can't get data")));
    when(mockGetWatchlistTvs.execute())
        .thenAnswer((_) async => const Right([testWatchlistTv]));
    // act
    await provider.fetchWatchlist();
    // assert
    expect(provider.watchlistState, RequestState.error);
    expect(provider.watchlistTvs, [testWatchlistTv]);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 2);
  });

  test('should return state error when Tvs data is unsuccessful', () async {
    // arrange
    when(mockGetWatchlistMovies.execute())
        .thenAnswer((_) async => const Right([testWatchlistMovie]));
    when(mockGetWatchlistTvs.execute())
        .thenAnswer((_) async => const Left(DatabaseFailure("Can't get data")));
    // act
    await provider.fetchWatchlist();
    // assert
    expect(provider.watchlistState, RequestState.error);
    expect(provider.watchlistMovies, [testWatchlistMovie]);
    expect(provider.message, "Can't get data");
    expect(listenerCallCount, 2);
  });
}
