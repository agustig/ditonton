import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';

import '../../dummy_data/dummy_tv_objects.dart';
import 'mock_tv_repository.dart';

void main() {
  late GetTvRecommendations usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvRecommendations(mockTvRepository);
  });

  final tTvList = testTvList;
  const tId = 1;

  test('should get list of Tv from the repository', () async {
    // arrange
    when(() => mockTvRepository.getTvRecommendations(tId))
        .thenAnswer((_) async => Right(tTvList));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tTvList));
  });
}
