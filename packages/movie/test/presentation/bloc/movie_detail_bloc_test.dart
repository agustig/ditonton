import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetMovieDetail extends Mock implements GetMovieDetail {}

class MockGetMovieRecommendations extends Mock
    implements GetMovieRecommendations {}

class MockGetWatchlistMovieStatus extends Mock
    implements GetWatchlistMovieStatus {}

class MockSaveWatchlistMovie extends Mock implements SaveWatchlistMovie {}

class MockRemoveWatchlistMovie extends Mock implements RemoveWatchlistMovie {}

void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchlistMovieStatus mockGetWatchlistMovieStatus;
  late MockSaveWatchlistMovie mockSaveWatchlistMovie;
  late MockRemoveWatchlistMovie mockRemoveWatchlistMovie;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistMovieStatus = MockGetWatchlistMovieStatus();
    mockSaveWatchlistMovie = MockSaveWatchlistMovie();
    mockRemoveWatchlistMovie = MockRemoveWatchlistMovie();
    movieDetailBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchlistMovieStatus: mockGetWatchlistMovieStatus,
      saveWatchlistMovie: mockSaveWatchlistMovie,
      removeWatchlistMovie: mockRemoveWatchlistMovie,
    );
  });

  const testMovieId = 1;

  final initialDataState = MovieDetailHasData(
    detail: testMovieDetail,
    movieRecommendations: testMovieList,
    isOnWatchlist: false,
  );

  test('initial setup should be empty', () {
    expect(movieDetailBloc.state, MovieDetailEmpty());
  });

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, HasData] when detail data is gotten successfully',
    build: () {
      when(() => mockGetMovieDetail.execute(testMovieId))
          .thenAnswer((_) async => const Right(testMovieDetail));
      when(() => mockGetMovieRecommendations.execute(testMovieId))
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetWatchlistMovieStatus.execute(testMovieId))
          .thenAnswer((_) async => false);
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(FetchMovieDetail(testMovieId)),
    expect: () => [
      MovieDetailLoading(),
      initialDataState,
    ],
    verify: (_) {
      verify(() => mockGetMovieDetail.execute(testMovieId));
      verify(() => mockGetMovieRecommendations.execute(testMovieId));
      verify(() => mockGetWatchlistMovieStatus.execute(testMovieId));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, Error] when detail data is unsuccessfully',
    build: () {
      when(() => mockGetMovieDetail.execute(testMovieId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      when(() => mockGetMovieRecommendations.execute(testMovieId))
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetWatchlistMovieStatus.execute(testMovieId))
          .thenAnswer((_) async => true);
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(FetchMovieDetail(testMovieId)),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailError('Server Failure'),
    ],
    verify: (_) {
      verify(() => mockGetMovieDetail.execute(testMovieId));
      verify(() => mockGetMovieRecommendations.execute(testMovieId));
      verify(() => mockGetWatchlistMovieStatus.execute(testMovieId));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, Error] when recommendations data is unsuccessfully',
    build: () {
      when(() => mockGetMovieDetail.execute(testMovieId))
          .thenAnswer((_) async => const Right(testMovieDetail));
      when(() => mockGetMovieRecommendations.execute(testMovieId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      when(() => mockGetWatchlistMovieStatus.execute(testMovieId))
          .thenAnswer((_) async => true);
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(FetchMovieDetail(testMovieId)),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailError('Server Failure'),
    ],
    verify: (_) {
      verify(() => mockGetMovieDetail.execute(testMovieId));
      verify(() => mockGetMovieRecommendations.execute(testMovieId));
      verify(() => mockGetWatchlistMovieStatus.execute(testMovieId));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit [Loading, Error] when watchlistStatus data is unsuccessfully',
    build: () {
      when(() => mockGetMovieDetail.execute(testMovieId))
          .thenAnswer((_) async => const Right(testMovieDetail));
      when(() => mockGetMovieRecommendations.execute(testMovieId))
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetWatchlistMovieStatus.execute(testMovieId))
          .thenThrow(DatabaseException('Failed to get watchlist'));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(FetchMovieDetail(testMovieId)),
    expect: () => [
      MovieDetailLoading(),
      MovieDetailError('Failed to get watchlist'),
    ],
    verify: (_) {
      verify(() => mockGetMovieDetail.execute(testMovieId));
      verify(() => mockGetMovieRecommendations.execute(testMovieId));
      verify(() => mockGetWatchlistMovieStatus.execute(testMovieId));
    },
  );

  group('insert or remove Movie watchlist', () {
    setUp(() {
      when(() => mockGetMovieDetail.execute(testMovieId))
          .thenAnswer((_) async => const Right(testMovieDetail));
      when(() => mockGetMovieRecommendations.execute(testMovieId))
          .thenAnswer((_) async => Right(testMovieList));
    });

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, HasData, HasData] when save watchlist is successful',
      build: () {
        final statusAnswer = [false, true];
        when(() => mockGetWatchlistMovieStatus.execute(testMovieId))
            .thenAnswer((_) async => statusAnswer.removeAt(0));
        when(() => mockSaveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        return movieDetailBloc;
      },
      act: (bloc) async {
        bloc.add(FetchMovieDetail(testMovieId));
        Future.delayed(const Duration(milliseconds: 0))
            .then((_) => bloc.add(AddMovieToWatchlist()));
      },
      wait: const Duration(milliseconds: 0),
      expect: () => [
        MovieDetailLoading(),
        initialDataState,
        initialDataState.changeAttr(
          isOnWatchlist: true,
          watchlistMessage: 'Added to Watchlist',
        ),
      ],
      verify: (_) {
        verify(() => mockGetMovieDetail.execute(testMovieId));
        verify(() => mockGetMovieRecommendations.execute(testMovieId));
        verify(() => mockGetWatchlistMovieStatus.execute(testMovieId))
            .called(2);
        verify(() => mockSaveWatchlistMovie.execute(testMovieDetail));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, HasData, HasData] with failure message when save watchlist is not successful',
      build: () {
        final statusAnswer = [false, false];
        when(() => mockGetWatchlistMovieStatus.execute(testMovieId))
            .thenAnswer((_) async => statusAnswer.removeAt(0));
        when(() => mockSaveWatchlistMovie.execute(testMovieDetail)).thenAnswer(
            (_) async => const Left(DatabaseFailure('Save failed')));
        return movieDetailBloc;
      },
      act: (bloc) async {
        bloc.add(FetchMovieDetail(testMovieId));
        Future.delayed(const Duration(milliseconds: 100))
            .then((_) => bloc.add(AddMovieToWatchlist()));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        MovieDetailLoading(),
        initialDataState,
        initialDataState.changeAttr(
          isOnWatchlist: false,
          watchlistMessage: 'Save failed',
        ),
      ],
      verify: (_) {
        verify(() => mockGetMovieDetail.execute(testMovieId));
        verify(() => mockGetMovieRecommendations.execute(testMovieId));
        verify(() => mockGetWatchlistMovieStatus.execute(testMovieId))
            .called(2);
        verify(() => mockSaveWatchlistMovie.execute(testMovieDetail));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, HasData, Error] when save watchlist is not successful with Exception',
      build: () {
        final List<Future<bool> Function(Invocation)> mockResult = [
          (_) async => false,
          (_) => throw DatabaseException('Failed to get watchlist'),
        ];
        when(() => mockGetWatchlistMovieStatus.execute(testMovieId))
            .thenAnswer((invocation) => mockResult.removeAt(0)(invocation));
        when(() => mockSaveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        return movieDetailBloc;
      },
      act: (bloc) async {
        bloc.add(FetchMovieDetail(testMovieId));
        Future.delayed(const Duration(milliseconds: 100))
            .then((_) => bloc.add(AddMovieToWatchlist()));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        MovieDetailLoading(),
        initialDataState,
        MovieDetailError('Failed to get watchlist'),
      ],
      verify: (_) {
        verify(() => mockGetMovieDetail.execute(testMovieId));
        verify(() => mockGetMovieRecommendations.execute(testMovieId));
        verify(() => mockGetWatchlistMovieStatus.execute(testMovieId))
            .called(2);
        verify(() => mockSaveWatchlistMovie.execute(testMovieDetail));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, HasData, HasData] when remove watchlist is successful',
      build: () {
        final statusAnswer = [true, false];
        when(() => mockGetWatchlistMovieStatus.execute(testMovieId))
            .thenAnswer((_) async => statusAnswer.removeAt(0));
        when(() => mockRemoveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Remove Success'));
        return movieDetailBloc;
      },
      act: (bloc) async {
        bloc.add(FetchMovieDetail(testMovieId));
        Future.delayed(const Duration(milliseconds: 100))
            .then((_) => bloc.add(RemoveMovieFromWatchlist()));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        MovieDetailLoading(),
        initialDataState.changeAttr(
          isOnWatchlist: true,
        ),
        initialDataState.changeAttr(
          isOnWatchlist: false,
          watchlistMessage: 'Remove Success',
        )
      ],
      verify: (_) {
        verify(() => mockGetMovieDetail.execute(testMovieId));
        verify(() => mockGetMovieRecommendations.execute(testMovieId));
        verify(() => mockGetWatchlistMovieStatus.execute(testMovieId))
            .called(2);
        verify(() => mockRemoveWatchlistMovie.execute(testMovieDetail));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, HasData, HasData] with failure message when remove watchlist is unsuccessful',
      build: () {
        final statusAnswer = [true, true];
        when(() => mockGetWatchlistMovieStatus.execute(testMovieId))
            .thenAnswer((_) async => statusAnswer.removeAt(0));
        when(() => mockRemoveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer(
                (_) async => const Left(DatabaseFailure('Remove failed')));
        return movieDetailBloc;
      },
      act: (bloc) async {
        bloc.add(FetchMovieDetail(testMovieId));
        Future.delayed(const Duration(milliseconds: 100))
            .then((_) => bloc.add(RemoveMovieFromWatchlist()));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        MovieDetailLoading(),
        initialDataState.changeAttr(
          isOnWatchlist: true,
        ),
        initialDataState.changeAttr(
          isOnWatchlist: true,
          watchlistMessage: 'Remove failed',
        )
      ],
      verify: (_) {
        verify(() => mockGetMovieDetail.execute(testMovieId));
        verify(() => mockGetMovieRecommendations.execute(testMovieId));
        verify(() => mockGetWatchlistMovieStatus.execute(testMovieId))
            .called(2);
        verify(() => mockRemoveWatchlistMovie.execute(testMovieDetail));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, HasData, Error] when remove watchlist is not successful with Exception',
      build: () {
        final List<Future<bool> Function(Invocation)> mockResult = [
          (_) async => true,
          (_) => throw DatabaseException('Failed to get watchlist'),
        ];
        when(() => mockGetWatchlistMovieStatus.execute(testMovieId))
            .thenAnswer((invocation) => mockResult.removeAt(0)(invocation));
        when(() => mockRemoveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Remove Success'));
        return movieDetailBloc;
      },
      act: (bloc) async {
        bloc.add(FetchMovieDetail(testMovieId));
        Future.delayed(const Duration(milliseconds: 100))
            .then((_) => bloc.add(RemoveMovieFromWatchlist()));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        MovieDetailLoading(),
        initialDataState.changeAttr(
          isOnWatchlist: true,
        ),
        MovieDetailError('Failed to get watchlist'),
      ],
      verify: (_) {
        verify(() => mockGetMovieDetail.execute(testMovieId));
        verify(() => mockGetMovieRecommendations.execute(testMovieId));
        verify(() => mockGetWatchlistMovieStatus.execute(testMovieId))
            .called(2);
        verify(() => mockRemoveWatchlistMovie.execute(testMovieDetail));
      },
    );
  });
}
