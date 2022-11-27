import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/presentation/cubit/top_rated_movies_cubit.dart';

import '../../dummy_data/dummy_objects.dart';

class MockGetTopRatedMovies extends Mock implements GetTopRatedMovies {}

void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMoviesCubit topRatedMoviesCubit;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMoviesCubit = TopRatedMoviesCubit(mockGetTopRatedMovies);
  });

  test('initial state should Empty state', () {
    expect(topRatedMoviesCubit.state, TopRatedMoviesEmpty());
  });

  blocTest<TopRatedMoviesCubit, TopRatedMoviesState>(
    'should emit [Loading, HasData] when get data is successful',
    build: () {
      when(() => mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => Right(testMovieList));
      return topRatedMoviesCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () =>
        [TopRatedMoviesLoading(), TopRatedMoviesHasData(testMovieList)],
    verify: (_) => mockGetTopRatedMovies.execute(),
  );

  blocTest<TopRatedMoviesCubit, TopRatedMoviesState>(
    'should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(() => mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('No connection')));
      return topRatedMoviesCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () =>
        [TopRatedMoviesLoading(), TopRatedMoviesError('No connection')],
    verify: (_) => mockGetTopRatedMovies.execute(),
  );
}
