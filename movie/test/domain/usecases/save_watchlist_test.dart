import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/usecases/save_watchlist.dart';

import '../../../../movie/test/dummy_data/dummy_objects.dart';
import 'mock_movie_repository.dart';

void main() {
  late SaveWatchlistMovie usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SaveWatchlistMovie(mockMovieRepository);
  });

  test(
    'should save movie to the repository',
    () async {
      // arrange
      when(() => mockMovieRepository.saveWatchlist(testMovieDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      // act
      final result = await usecase.execute(testMovieDetail);
      // assert
      verify(() => mockMovieRepository.saveWatchlist(testMovieDetail));
      expect(result, const Right('Added to Watchlist'));
    },
  );
}
