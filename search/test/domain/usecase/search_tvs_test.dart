import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/domain/usecase/search_tvs.dart';
import 'package:tv/tv.dart' show Tv, TvRepository;

class MockTvRepository extends Mock implements TvRepository {}

void main() {
  late SearchTvs usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SearchTvs(mockTvRepository);
  });

  const testTv = Tv(
    id: 31586,
    name: 'La Reina del Sur',
    overview:
        "After years of blood, sweat and tears, a woman of humble origin ends up becoming a drug trafficking legend, with all that that means...",
    posterPath: "/p11t8ckTC6EiuVw5FGFKdc2Z7GH.jpg",
  );

  final tTvList = [testTv];
  const tQuery = 'reina';

  test('should get list of Tv from the repository', () async {
    // arrange
    when(() => mockTvRepository.searchTvs(tQuery))
        .thenAnswer((_) async => Right(tTvList));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tTvList));
  });
}
