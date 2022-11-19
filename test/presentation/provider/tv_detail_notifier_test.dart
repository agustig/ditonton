import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_tv_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvDetailNotifier provider;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchlistTvStatus mockGetWatchlistTvStatus;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchlistTvStatus = MockGetWatchlistTvStatus();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    provider = TvDetailNotifier(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchlistTvStatus: mockGetWatchlistTvStatus,
      saveWatchlistTv: mockSaveWatchlistTv,
      removeWatchlistTv: mockRemoveWatchlistTv,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 31586;

  final tTvList = testTvList;
  final tTvDetail = testTvDetail;

  group('Get Tv Detail', () {
    // arrange
    setUp(() {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Right(tTvDetail));
    });

    test('should get data from the usecase', () async {
      // act
      await provider.fetchTvDetail(tId);
      // assert
      verify(mockGetTvDetail.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // act
      provider.fetchTvDetail(tId);
      // assert
      expect(provider.tvState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change tvDetail when data is gotten successfully', () async {
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.tvState, RequestState.Loaded);
      expect(provider.tv, tTvDetail);
      expect(listenerCallCount, 2);
    });
  });

  group('Season Expanding', () {
    final tEpisodeId = 757251;
    test('should change TvSeason data when expandSeason called', () async {
      // act
      await provider.expandSeason(testTvSeasonDetail);

      // assert
      expect(provider.isSeasonExpanded(testTvSeasonDetail), true);
      expect(listenerCallCount, 1);
    });

    test('should remove Expanded TvSeason data when showSeason called', () {
      // act
      provider.closeExpandedSeason();
      // assert
      expect(provider.isSeasonExpanded(testTvSeasonDetail), false);
      expect(listenerCallCount, 1);
    });
  });

  group('Get Tv Recommendations', () {
    // arrange
    setUp(() {
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTvList));
    });

    test('should get data from the usecase', () async {
      // act
      await provider.fetchTvRecommendations(tId);
      // assert
      verify(mockGetTvRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // act
      provider.fetchTvRecommendations(tId);
      // assert
      expect(provider.recommendationState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change tvRecommendation when data is gotten successfully',
        () async {
      // act
      await provider.fetchTvRecommendations(tId);
      // assert
      expect(provider.recommendationState, RequestState.Loaded);
      expect(provider.tvRecommendations, tTvList);
      expect(listenerCallCount, 2);
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistTvStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistTvStatus(1);
      // assert
      expect(provider.isTvAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlistTv.execute(tTvDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistTvStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addTvToWatchlist(tTvDetail);
      // assert
      verify(mockSaveWatchlistTv.execute(tTvDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlistTv.execute(tTvDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistTvStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeTvFromWatchlist(tTvDetail);
      // assert
      verify(mockRemoveWatchlistTv.execute(tTvDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlistTv.execute(tTvDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistTvStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addTvToWatchlist(tTvDetail);
      // assert
      verify(mockGetWatchlistTvStatus.execute(tTvDetail.id));
      expect(provider.isTvAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlistTv.execute(tTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistTvStatus.execute(tTvDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addTvToWatchlist(tTvDetail);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTvList));
      // act
      await provider.fetchTvDetail(tId);
      // assert
      expect(provider.tvState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
