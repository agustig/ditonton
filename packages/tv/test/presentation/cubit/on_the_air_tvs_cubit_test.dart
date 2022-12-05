import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/domain/usecases/get_on_the_air_tvs.dart';
import 'package:tv/presentation/cubit/on_the_air_tvs_cubit.dart';

import '../../dummy_data/dummy_tv_objects.dart';

class MockGetOnTheAirTvs extends Mock implements GetOnTheAirTvs {}

void main() {
  late MockGetOnTheAirTvs mockGetOnTheAirTvs;
  late OnTheAirTvsCubit onTheAirTvsCubit;

  setUp(() {
    mockGetOnTheAirTvs = MockGetOnTheAirTvs();
    onTheAirTvsCubit = OnTheAirTvsCubit(mockGetOnTheAirTvs);
  });

  test('initial state should Empty state', () {
    expect(onTheAirTvsCubit.state, OnTheAirTvsEmpty());
  });

  blocTest<OnTheAirTvsCubit, OnTheAirTvsState>(
    'should emit [Loading, HasData] when get data is successful',
    build: () {
      when(() => mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => Right(testTvList));
      return onTheAirTvsCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [OnTheAirTvsLoading(), OnTheAirTvsHasData(testTvList)],
    verify: (_) => mockGetOnTheAirTvs.execute(),
  );

  blocTest<OnTheAirTvsCubit, OnTheAirTvsState>(
    'should emit [Loading, Error] when get data is unsuccessful',
    build: () {
      when(() => mockGetOnTheAirTvs.execute())
          .thenAnswer((_) async => const Left(ServerFailure('No connection')));
      return onTheAirTvsCubit;
    },
    act: (cubit) => cubit.fetch(),
    expect: () => [OnTheAirTvsLoading(), OnTheAirTvsError('No connection')],
    verify: (_) => mockGetOnTheAirTvs.execute(),
  );
}
