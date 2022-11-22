import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/domain/usecase/get_watchlist_tvs.dart';

import '../../dummy_data/dummy_object.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTvs usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetWatchlistTvs(mockTvRepository);
  });
  

  test('should get list of tvs from the repository', () async {
    // arrange
    when(mockTvRepository.getWatchlistTvs())
        .thenAnswer((_) async => Right(testWatchlistTvList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testWatchlistTvList));
  });
}
