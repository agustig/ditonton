import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';
import 'package:tv/domain/usecases/remove_watchlist_tv.dart';
import 'package:tv/domain/usecases/save_watchlist_tv.dart';
import 'package:tv/presentation/bloc/tv_detail_bloc.dart';

import '../../dummy_data/dummy_tv_objects.dart';

class MockGetTvDetail extends Mock implements GetTvDetail {}

class MockGetTvRecommendations extends Mock implements GetTvRecommendations {}

class MockGetWatchlistTvStatus extends Mock implements GetWatchlistTvStatus {}

class MockSaveWatchlistTv extends Mock implements SaveWatchlistTv {}

class MockRemoveWatchlistTv extends Mock implements RemoveWatchlistTv {}

void main() {
  late TvDetailBloc tvDetailBloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchlistTvStatus mockGetWatchlistTvStatus;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchlistTvStatus = MockGetWatchlistTvStatus();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    tvDetailBloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchlistTvStatus: mockGetWatchlistTvStatus,
      saveWatchlistTv: mockSaveWatchlistTv,
      removeWatchlistTv: mockRemoveWatchlistTv,
    );
  });

  const testTvId = 31586;

  final initialDataState = TvDetailHasData(
    detail: testTvDetail,
    tvRecommendations: testTvList,
    isOnWatchlist: false,
  );

  test('initial setup should be empty', () {
    expect(tvDetailBloc.state, TvDetailEmpty());
  });

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, HasData] when detail data is gotten successfully',
    build: () {
      when(() => mockGetTvDetail.execute(testTvId))
          .thenAnswer((_) async => Right(testTvDetail));
      when(() => mockGetTvRecommendations.execute(testTvId))
          .thenAnswer((_) async => Right(testTvList));
      when(() => mockGetWatchlistTvStatus.execute(testTvId))
          .thenAnswer((_) async => false);
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(FetchDetail(testTvId)),
    expect: () => [
      TvDetailLoading(),
      initialDataState,
    ],
    verify: (_) {
      verify(() => mockGetTvDetail.execute(testTvId));
      verify(() => mockGetTvRecommendations.execute(testTvId));
      verify(() => mockGetWatchlistTvStatus.execute(testTvId));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, Error] when detail data is unsuccessfully',
    build: () {
      when(() => mockGetTvDetail.execute(testTvId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      when(() => mockGetTvRecommendations.execute(testTvId))
          .thenAnswer((_) async => Right(testTvList));
      when(() => mockGetWatchlistTvStatus.execute(testTvId))
          .thenAnswer((_) async => true);
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(FetchDetail(testTvId)),
    expect: () => [
      TvDetailLoading(),
      TvDetailError('Server Failure'),
    ],
    verify: (_) {
      verify(() => mockGetTvDetail.execute(testTvId));
      verify(() => mockGetTvRecommendations.execute(testTvId));
      verify(() => mockGetWatchlistTvStatus.execute(testTvId));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, Error] when watchlistStatus data is unsuccessfully',
    build: () {
      when(() => mockGetTvDetail.execute(testTvId))
          .thenAnswer((_) async => Right(testTvDetail));
      when(() => mockGetTvRecommendations.execute(testTvId))
          .thenAnswer((_) async => Right(testTvList));
      when(() => mockGetWatchlistTvStatus.execute(testTvId))
          .thenThrow(DatabaseException('Failed to get watchlist'));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(FetchDetail(testTvId)),
    expect: () => [
      TvDetailLoading(),
      TvDetailError('Failed to get watchlist'),
    ],
    verify: (_) {
      verify(() => mockGetTvDetail.execute(testTvId));
      verify(() => mockGetTvRecommendations.execute(testTvId));
      verify(() => mockGetWatchlistTvStatus.execute(testTvId));
    },
  );

  group('insert or remove watchlist', () {
    setUp(() {
      when(() => mockGetTvDetail.execute(testTvId))
          .thenAnswer((_) async => Right(testTvDetail));
      when(() => mockGetTvRecommendations.execute(testTvId))
          .thenAnswer((_) async => Right(testTvList));
    });

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, HasData, HasData] when save watchlist is successful',
      build: () {
        final statusAnswer = [false, true];
        when(() => mockGetWatchlistTvStatus.execute(testTvId))
            .thenAnswer((_) async => statusAnswer.removeAt(0));
        when(() => mockSaveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        return tvDetailBloc;
      },
      act: (bloc) async {
        bloc.add(FetchDetail(testTvId));
        Future.delayed(const Duration(milliseconds: 100))
            .then((_) => bloc.add(AddToWatchlist()));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        TvDetailLoading(),
        initialDataState,
        initialDataState.changeAttr(
          isOnWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        ),
      ],
      verify: (_) {
        verify(() => mockGetTvDetail.execute(testTvId));
        verify(() => mockGetTvRecommendations.execute(testTvId));
        verify(() => mockGetWatchlistTvStatus.execute(testTvId)).called(2);
        verify(() => mockSaveWatchlistTv.execute(testTvDetail));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, HasData, HasData] with failure message when save watchlist is not successful',
      build: () {
        final statusAnswer = [false, false];
        when(() => mockGetWatchlistTvStatus.execute(testTvId))
            .thenAnswer((_) async => statusAnswer.removeAt(0));
        when(() => mockSaveWatchlistTv.execute(testTvDetail)).thenAnswer(
            (_) async => const Left(DatabaseFailure('Save failed')));
        return tvDetailBloc;
      },
      act: (bloc) async {
        bloc.add(FetchDetail(testTvId));
        Future.delayed(const Duration(milliseconds: 100))
            .then((_) => bloc.add(AddToWatchlist()));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        TvDetailLoading(),
        initialDataState,
        initialDataState.changeAttr(
          isOnWatchlist: false,
          watchlistMessage: 'Save failed',
        ),
      ],
      verify: (_) {
        verify(() => mockGetTvDetail.execute(testTvId));
        verify(() => mockGetTvRecommendations.execute(testTvId));
        verify(() => mockGetWatchlistTvStatus.execute(testTvId)).called(2);
        verify(() => mockSaveWatchlistTv.execute(testTvDetail));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, HasData, HasData] when remove watchlist is successful',
      build: () {
        final statusAnswer = [true, false];
        when(() => mockGetWatchlistTvStatus.execute(testTvId))
            .thenAnswer((_) async => statusAnswer.removeAt(0));
        when(() => mockRemoveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Remove Success'));
        return tvDetailBloc;
      },
      act: (bloc) async {
        bloc.add(FetchDetail(testTvId));
        Future.delayed(const Duration(milliseconds: 100))
            .then((_) => bloc.add(RemoveFromWatchlist()));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        TvDetailLoading(),
        initialDataState.changeAttr(
          isOnWatchlist: true,
        ),
        initialDataState.changeAttr(
          isOnWatchlist: false,
          watchlistMessage: 'Remove Success',
        )
      ],
      verify: (_) {
        verify(() => mockGetTvDetail.execute(testTvId));
        verify(() => mockGetTvRecommendations.execute(testTvId));
        verify(() => mockGetWatchlistTvStatus.execute(testTvId)).called(2);
        verify(() => mockRemoveWatchlistTv.execute(testTvDetail));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, HasData, HasData] with failure message when remove watchlist is unsuccessful',
      build: () {
        final statusAnswer = [true, true];
        when(() => mockGetWatchlistTvStatus.execute(testTvId))
            .thenAnswer((_) async => statusAnswer.removeAt(0));
        when(() => mockRemoveWatchlistTv.execute(testTvDetail)).thenAnswer(
            (_) async => const Left(DatabaseFailure('Remove failed')));
        return tvDetailBloc;
      },
      act: (bloc) async {
        bloc.add(FetchDetail(testTvId));
        Future.delayed(const Duration(milliseconds: 100))
            .then((_) => bloc.add(RemoveFromWatchlist()));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        TvDetailLoading(),
        initialDataState.changeAttr(
          isOnWatchlist: true,
        ),
        initialDataState.changeAttr(
          isOnWatchlist: true,
          watchlistMessage: 'Remove failed',
        )
      ],
      verify: (_) {
        verify(() => mockGetTvDetail.execute(testTvId));
        verify(() => mockGetTvRecommendations.execute(testTvId));
        verify(() => mockGetWatchlistTvStatus.execute(testTvId)).called(2);
        verify(() => mockRemoveWatchlistTv.execute(testTvDetail));
      },
    );
  });

  group('Expand Season', () {
    setUp(() {
      when(() => mockGetTvDetail.execute(testTvId))
          .thenAnswer((_) async => Right(testTvDetail));
      when(() => mockGetTvRecommendations.execute(testTvId))
          .thenAnswer((_) async => Right(testTvList));
      when(() => mockGetWatchlistTvStatus.execute(testTvId))
          .thenAnswer((_) async => false);
    });

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, HasData, HasData] with expand value in last state',
      build: () => tvDetailBloc,
      act: (bloc) {
        tvDetailBloc.add(FetchDetail(testTvId));
        Future.delayed(const Duration(milliseconds: 100))
            .then((_) => bloc.add(ExpandSeason(testTvSeason)));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        TvDetailLoading(),
        initialDataState,
        initialDataState.changeAttr(expandedSeason: testTvSeason),
      ],
      verify: (_) {
        verify(() => mockGetTvDetail.execute(testTvId));
        verify(() => mockGetTvRecommendations.execute(testTvId));
        verify(() => mockGetWatchlistTvStatus.execute(testTvId));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, HasData, HasData, HasData] with remove expand value in last state',
      build: () => tvDetailBloc,
      act: (bloc) {
        tvDetailBloc.add(FetchDetail(testTvId));
        Future.delayed(const Duration(milliseconds: 100))
            .then((_) => bloc.add(ExpandSeason(testTvSeason)));
        Future.delayed(const Duration(milliseconds: 100))
            .then((_) => bloc.add(CollapseSeason()));
      },
      wait: const Duration(milliseconds: 200),
      expect: () => [
        TvDetailLoading(),
        initialDataState,
        initialDataState.changeAttr(expandedSeason: testTvSeason),
        initialDataState
      ],
      verify: (_) {
        verify(() => mockGetTvDetail.execute(testTvId));
        verify(() => mockGetTvRecommendations.execute(testTvId));
        verify(() => mockGetWatchlistTvStatus.execute(testTvId));
      },
    );
  });
}
