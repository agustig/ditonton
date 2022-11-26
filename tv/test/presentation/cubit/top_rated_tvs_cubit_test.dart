import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/domain/usecases/get_top_rated_tvs.dart';
import 'package:tv/presentation/cubit/top_rated_tvs_cubit.dart';

import '../../dummy_data/dummy_tv_objects.dart';

class MockGetTopRatedTvs extends Mock implements GetTopRatedTvs {}

void main() {
  late MockGetTopRatedTvs mockGetTopRatedTvs;
  late TopRatedTvsCubit topRatedTvsCubit;

  setUp(() {
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    topRatedTvsCubit = TopRatedTvsCubit(mockGetTopRatedTvs);
  });

  test('initial state should Empty state', () {
    expect(topRatedTvsCubit.state, TopRatedTvsEmpty());
  });

  blocTest<TopRatedTvsCubit, TopRatedTvsState>(
    'should emit [Loading, HasData] when get data is successful',
    build: () {
      when(() => mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      return topRatedTvsCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [TopRatedTvsLoading(), TopRatedTvsHasData(testTvList)],
    verify: (_) => mockGetTopRatedTvs.execute(),
  );

  blocTest<TopRatedTvsCubit, TopRatedTvsState>(
    'should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(() => mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('No connection')));
      return topRatedTvsCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [TopRatedTvsLoading(), TopRatedTvsError('No connection')],
    verify: (_) => mockGetTopRatedTvs.execute(),
  );
}
