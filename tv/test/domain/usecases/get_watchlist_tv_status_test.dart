import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/domain/usecases/get_watchlist_tv_status.dart';

import 'mock_tv_repository.dart';

void main() {
  late GetWatchlistTvStatus usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetWatchlistTvStatus(mockTvRepository);
  });

  test('should get watchlist status from repository', () async {
    // arrange
    when(() => mockTvRepository.isAddedTvToWatchlist(1))
        .thenAnswer((_) async => true);
    // act
    final result = await usecase.execute(1);
    // assert
    expect(result, true);
  });
}
