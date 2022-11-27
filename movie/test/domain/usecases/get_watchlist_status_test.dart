import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';

import 'mock_movie_repository.dart';

void main() {
  late GetWatchlistMovieStatus usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = GetWatchlistMovieStatus(mockMovieRepository);
  });

  test(
    'should get watchlist status from repository',
    () async {
      // arrange
      when(() => mockMovieRepository.isAddedToWatchlist(1))
          .thenAnswer((_) async => true);
      // act
      final result = await usecase.execute(1);
      // assert
      expect(result, true);
    },
  );
}
