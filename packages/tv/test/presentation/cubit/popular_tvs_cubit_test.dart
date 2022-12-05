import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/domain/usecases/get_popular_tvs.dart';
import 'package:tv/presentation/cubit/popular_tvs_cubit.dart';

import '../../dummy_data/dummy_tv_objects.dart';

class MockGetPopularTvs extends Mock implements GetPopularTvs {}

void main() {
  late MockGetPopularTvs mockGetPopularTvs;
  late PopularTvsCubit popularTvsCubit;

  setUp(() {
    mockGetPopularTvs = MockGetPopularTvs();
    popularTvsCubit = PopularTvsCubit(mockGetPopularTvs);
  });

  test('initial state should Empty state', () {
    expect(popularTvsCubit.state, PopularTvsEmpty());
  });

  blocTest<PopularTvsCubit, PopularTvsState>(
    'should emit [Loading, HasData] when get data is successful',
    build: () {
      when(() => mockGetPopularTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      return popularTvsCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [PopularTvsLoading(), PopularTvsHasData(testTvList)],
    verify: (_) => mockGetPopularTvs.execute(),
  );

  blocTest<PopularTvsCubit, PopularTvsState>(
    'should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(() => mockGetPopularTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('No connection')));
      return popularTvsCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [PopularTvsLoading(), PopularTvsError('No connection')],
    verify: (_) => mockGetPopularTvs.execute(),
  );
}
