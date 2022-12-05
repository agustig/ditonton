import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart' show MovieRepository;
import 'package:watchlist/domain/usecase/get_watchlist_movies.dart';

import '../../dummy_data/dummy_object.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late GetWatchlistMovies usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetWatchlistMovies(mockMovieRepository);
  });

  test('should get list of movies from the repository', () async {
    // arrange
    when(() => mockMovieRepository.getWatchlistMovies())
        .thenAnswer((_) async => Right(testWatchlistMovieList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testWatchlistMovieList));
  });
}
