import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/presentation/cubit/home_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetNowPlayingMovies extends Mock implements GetNowPlayingMovies {}

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

class MockGetTopRatedMovies extends Mock implements GetTopRatedMovies {}

class MockGetOnTheAirTvs extends Mock implements GetOnTheAirTvs {}

class MockGetPopularTvs extends Mock implements GetPopularTvs {}

class MockGetTopRatedTvs extends Mock implements GetTopRatedTvs {}

void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late MockGetOnTheAirTvs mockGetOnTheAirTvs;
  late MockGetPopularTvs mockGetPopularTvs;
  late MockGetTopRatedTvs mockGetTopRatedTvs;
  late HomeCubit homeCubit;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    mockGetOnTheAirTvs = MockGetOnTheAirTvs();
    mockGetPopularTvs = MockGetPopularTvs();
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    homeCubit = HomeCubit(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
      getOnTheAirTvs: mockGetOnTheAirTvs,
      getPopularTvs: mockGetPopularTvs,
      getTopRatedTvs: mockGetTopRatedTvs,
    );
  });

  test('initial state should Empty state', () {
    expect(homeCubit.state, HomeEmpty());
  });

  blocTest<HomeCubit, HomeState>(
    'should emit [Loading, HasData] when get data is successful',
    build: () {
      when(() => mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      when(() => mockGetPopularTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      when(() => mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      return homeCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [
      HomeLoading(),
      HomeHasData(
        nowPlayingMovies: testMovieList,
        popularMovies: testMovieList,
        topRatedMovies: testMovieList,
        onTheAirTvs: testTvList,
        popularTvs: testTvList,
        topRatedTvs: testTvList,
      ),
    ],
    verify: (_) {
      mockGetNowPlayingMovies.execute();
      mockGetPopularMovies.execute();
      mockGetTopRatedMovies.execute();
      mockGetOnTheAirTvs.execute();
      mockGetPopularTvs.execute();
      mockGetTopRatedTvs.execute();
    },
  );

  blocTest<HomeCubit, HomeState>(
    'should emit [Loading, Error] when getNowPlayingMovies data is unsuccessful',
    build: () {
      when(() => mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('No connection')));
      when(() => mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      when(() => mockGetPopularTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      when(() => mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      return homeCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [HomeLoading(), HomeError('No connection')],
    verify: (_) {
      mockGetNowPlayingMovies.execute();
      mockGetPopularMovies.execute();
      mockGetTopRatedMovies.execute();
      mockGetOnTheAirTvs.execute();
      mockGetPopularTvs.execute();
      mockGetTopRatedTvs.execute();
    },
  );

  blocTest<HomeCubit, HomeState>(
    'should emit [Loading, Error] when getPopularMovies data is unsuccessful',
    build: () {
      when(() => mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetPopularMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('No connection')));
      when(() => mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      when(() => mockGetPopularTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      when(() => mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      return homeCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [HomeLoading(), HomeError('No connection')],
    verify: (_) {
      mockGetNowPlayingMovies.execute();
      mockGetPopularMovies.execute();
      mockGetTopRatedMovies.execute();
      mockGetOnTheAirTvs.execute();
      mockGetPopularTvs.execute();
      mockGetTopRatedTvs.execute();
    },
  );

  blocTest<HomeCubit, HomeState>(
    'should emit [Loading, Error] when getTopRatedMovies data is unsuccessful',
    build: () {
      when(() => mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('No connection')));
      when(() => mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      when(() => mockGetPopularTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      when(() => mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      return homeCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [HomeLoading(), HomeError('No connection')],
    verify: (_) {
      mockGetNowPlayingMovies.execute();
      mockGetPopularMovies.execute();
      mockGetTopRatedMovies.execute();
      mockGetOnTheAirTvs.execute();
      mockGetPopularTvs.execute();
      mockGetTopRatedTvs.execute();
    },
  );

  blocTest<HomeCubit, HomeState>(
    'should emit [Loading, Error] when getOnTheAirTvs data is unsuccessful',
    build: () {
      when(() => mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('No connection')));
      when(() => mockGetPopularTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      when(() => mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      return homeCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [HomeLoading(), HomeError('No connection')],
    verify: (_) {
      mockGetNowPlayingMovies.execute();
      mockGetPopularMovies.execute();
      mockGetTopRatedMovies.execute();
      mockGetOnTheAirTvs.execute();
      mockGetPopularTvs.execute();
      mockGetTopRatedTvs.execute();
    },
  );

  blocTest<HomeCubit, HomeState>(
    'should emit [Loading, Error] when getPopularTvs data is unsuccessful',
    build: () {
      when(() => mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      when(() => mockGetPopularTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('No connection')));
      when(() => mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      return homeCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [HomeLoading(), HomeError('No connection')],
    verify: (_) {
      mockGetNowPlayingMovies.execute();
      mockGetPopularMovies.execute();
      mockGetTopRatedMovies.execute();
      mockGetOnTheAirTvs.execute();
      mockGetPopularTvs.execute();
      mockGetTopRatedTvs.execute();
    },
  );

  blocTest<HomeCubit, HomeState>(
    'should emit [Loading, Error] when getTopRatedTvs data is unsuccessful',
    build: () {
      when(() => mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      when(() => mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      when(() => mockGetPopularTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      when(() => mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('No connection')));
      return homeCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [HomeLoading(), HomeError('No connection')],
    verify: (_) {
      mockGetNowPlayingMovies.execute();
      mockGetPopularMovies.execute();
      mockGetTopRatedMovies.execute();
      mockGetOnTheAirTvs.execute();
      mockGetPopularTvs.execute();
      mockGetTopRatedTvs.execute();
    },
  );
}
