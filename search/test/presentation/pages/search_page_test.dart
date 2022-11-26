import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:search/presentation/cubit/search_filter_cubit.dart';
import 'package:search/presentation/pages/search_page.dart';
import 'package:search/presentation/widgets/search_result.dart';

import '../../dummy_data/dummy_objects.dart';

class MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

void main() {
  late MockSearchBloc mockSearchBloc;
  late SearchFilterCubit searchFilterCubit;

  setUp(() {
    mockSearchBloc = MockSearchBloc();
    searchFilterCubit = SearchFilterCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchBloc>(
          create: (context) => mockSearchBloc..add(SearchEvent(tQuery)),
        ),
        BlocProvider<SearchFilterCubit>(
          create: (context) => searchFilterCubit,
        ),
      ],
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Should shown Progress bar when search is loading',
      (tester) async {
    when(() => mockSearchBloc.state).thenAnswer((_) => SearchLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Should shown SearchResult when search is successful',
      (tester) async {
    when(() => mockSearchBloc.state).thenAnswer(
      (_) => SearchHasData(movies: tMovieList, tvs: tTvList),
    );

    final searchResultFinder = find.byType(SearchResult);

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    expect(searchResultFinder, findsOneWidget);
  });

  testWidgets('Should shown Error message when search is error',
      (tester) async {
    when(() => mockSearchBloc.state).thenAnswer(
      (_) => SearchError('Server Error'),
    );

    final textFinder = find.text('Server Error');

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    expect(textFinder, findsOneWidget);
  });
}
