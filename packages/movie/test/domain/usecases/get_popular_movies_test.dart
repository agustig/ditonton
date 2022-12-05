import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';

import 'mock_movie_repository.dart';

void main() {
  late GetPopularMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetPopularMovies(mockMovieRepository);
  });

  final tMovies = <Movie>[];

  group(
    'GetPopularMovies Tests',
    () {
      test(
        'should get list of movies from the repository when execute function is called',
        () async {
          // arrange
          when(() => mockMovieRepository.getPopularMovies())
              .thenAnswer((_) async => Right(tMovies));
          // act
          final result = await usecase.execute();
          // assert
          expect(result, Right(tMovies));
        },
      );
    },
  );
}
