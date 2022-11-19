import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_tv_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvDetail usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvDetail(mockTvRepository);
  });

  final tTvDetail = testTvDetail;
  final tId = 1;

  test('should get list of TvDetail from the repository', () async {
    // arrange
    when(mockTvRepository.getTvDetail(tId))
        .thenAnswer((_) async => Right(tTvDetail));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tTvDetail));
  });
}
