import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/domain/usecase/search_movies.dart';
import 'package:search/domain/usecase/search_tvs.dart';
import 'package:search/presentation/bloc/search_bloc.dart';

import '../../dummy_data/dummy_objects.dart';

class MockSearchMovies extends Mock implements SearchMovies {}

class MockSearchTvs extends Mock implements SearchTvs {}

void main() {
  late SearchBloc searchBloc;
  late MockSearchMovies mockSearchMovies;
  late MockSearchTvs mockSearchTvs;

  setUp(() {
    mockSearchMovies = MockSearchMovies();
    mockSearchTvs = MockSearchTvs();
    searchBloc = SearchBloc(
      searchMovies: mockSearchMovies,
      searchTvs: mockSearchTvs,
    );
  });

  test('initial state should be empty', () {
    expect(searchBloc.state, SearchEmpty());
  });

  blocTest(
    'should state is empty when SearchStart call',
    build: () => searchBloc,
    act: (bloc) => bloc.add(SearchStart()),
    expect: () => [SearchEmpty()],
  );

  blocTest<SearchBloc, SearchState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(() => mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      when(() => mockSearchTvs.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(QueryChange(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      SearchHasData(movies: tMovieList, tvs: tTvList),
    ],
    verify: (bloc) {
      verify(() => mockSearchMovies.execute(tQuery));
      verify(() => mockSearchTvs.execute(tQuery));
    },
  );

  blocTest<SearchBloc, SearchState>(
    'Should emit [Loading, Error] when data search is unsuccessfully',
    build: () {
      when(() => mockSearchMovies.execute(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      when(() => mockSearchTvs.execute(tQuery))
          .thenAnswer((_) async => Right(tTvList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(QueryChange(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [SearchLoading(), SearchError('Server Failure')],
    verify: (bloc) {
      verify(() => mockSearchMovies.execute(tQuery));
      verify(() => mockSearchTvs.execute(tQuery));
    },
  );

  blocTest<SearchBloc, SearchState>(
    'Should emit [Loading, Empty] when query is empty',
    build: () => searchBloc,
    act: (bloc) => bloc.add(QueryChange('')),
    wait: const Duration(milliseconds: 500),
    expect: () => [SearchLoading(), SearchEmpty()],
  );
}
