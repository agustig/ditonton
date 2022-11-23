import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search/presentation/cubit/search_filter_cubit.dart';

void main() {
  late SearchFilterCubit searchFilterCubit;

  setUp(() {
    searchFilterCubit = SearchFilterCubit();
  });

  test('initial state should "SearchFilterOption.all"', () {
    expect(searchFilterCubit.state, SearchFilterOption.all);
  });

  blocTest(
    'should change state when method is called with filter value',
    build: () => searchFilterCubit,
    act: (cubit) => cubit.filterBy(SearchFilterOption.movie),
    expect: () => [SearchFilterOption.movie],
  );

  blocTest(
    'should not change state when method is called with null',
    build: () => searchFilterCubit,
    act: (cubit) => cubit.filterBy(null),
    expect: () => [],
  );

  blocTest(
    'should change state when with value and not with null',
    build: () => searchFilterCubit,
    act: (cubit) {
      cubit.filterBy(SearchFilterOption.movie);
      cubit.filterBy(SearchFilterOption.all);
      cubit.filterBy(null);
      cubit.filterBy(SearchFilterOption.tv);
      cubit.filterBy(null);
      cubit.filterBy(SearchFilterOption.movie);
      cubit.filterBy(SearchFilterOption.all);
    },
    expect: () => [
      SearchFilterOption.movie,
      SearchFilterOption.all,
      SearchFilterOption.tv,
      SearchFilterOption.movie,
      SearchFilterOption.all,
    ],
  );
}
