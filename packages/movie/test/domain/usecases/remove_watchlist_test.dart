import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/usecases/remove_watchlist.dart';

import '../../../../movie/test/dummy_data/dummy_objects.dart';
import 'mock_movie_repository.dart';

void main() {
  late RemoveWatchlistMovie usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = RemoveWatchlistMovie(mockMovieRepository);
  });

  test(
    'should remove watchlist movie from repository',
    () async {
      // arrange
      when(() => mockMovieRepository.removeWatchlist(testMovieDetail))
          .thenAnswer((_) async => const Right('Removed from watchlist'));
      // act
      final result = await usecase.execute(testMovieDetail);
      // assert
      verify(() => mockMovieRepository.removeWatchlist(testMovieDetail));
      expect(result, const Right('Removed from watchlist'));
    },
  );
}
