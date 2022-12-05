import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';

import '../../dummy_data/dummy_tv_objects.dart';
import 'mock_tv_repository.dart';

void main() {
  late GetPopularTvs usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetPopularTvs(mockTvRepository);
  });

  final tTvList = testTvList;

  test('should get list of Tv from the repository', () async {
    // arrange
    when(() => mockTvRepository.getPopularTvs())
        .thenAnswer((_) async => Right(tTvList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTvList));
  });
}
