import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/presentation/cubit/popular_movies_cubit.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMoviesCubit popularMoviesCubit;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesCubit = PopularMoviesCubit(mockGetPopularMovies);
  });

  test('initial state should Empty state', () {
    expect(popularMoviesCubit.state, PopularMoviesEmpty());
  });

  blocTest<PopularMoviesCubit, PopularMoviesState>(
    'should emit [Loading, HasData] when get data is successful',
    build: () {
      when(() => mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return popularMoviesCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [PopularMoviesLoading(), PopularMoviesHasData(testMovieList)],
    verify: (_) => mockGetPopularMovies.execute(),
  );

  blocTest<PopularMoviesCubit, PopularMoviesState>(
    'should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(() => mockGetPopularMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('No connection')));
      return popularMoviesCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [PopularMoviesLoading(), PopularMoviesError('No connection')],
    verify: (_) => mockGetPopularMovies.execute(),
  );
}
