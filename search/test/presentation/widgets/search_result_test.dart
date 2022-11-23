import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart' show MovieCard;
import 'package:search/presentation/cubit/search_filter_cubit.dart';
import 'package:search/presentation/widgets/search_result.dart';
import 'package:tv/tv.dart' show TvCard;

import '../../dummy_data/dummy_objects.dart';

class MockSearchFilterCubit extends MockCubit<SearchFilterOption>
    implements SearchFilterCubit {}

void main() {
  late MockSearchFilterCubit mockSearchFilterCubit;

  setUp(() {
    mockSearchFilterCubit = MockSearchFilterCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchFilterCubit>.value(
      value: mockSearchFilterCubit,
      child: MaterialApp(
        home: Scaffold(
          body: body,
        ),
      ),
    );
  }

  final widget = SearchResult(movieResults: tMovieList, tvResults: tTvList);

  testWidgets(
    'Should show Tv and Movie results when state is all',
    (tester) async {
      when(() => mockSearchFilterCubit.state)
          .thenAnswer((_) => SearchFilterOption.all);

      final movieCardFinder = find.byType(MovieCard);
      final movieTextFinder = find.text('Spider-Man');
      final tvCardFinder = find.byType(TvCard);
      final tvTextFinder = find.text('La Reina del Sur');

      await tester.pumpWidget(makeTestableWidget(widget));

      expect(movieCardFinder, findsOneWidget);
      expect(movieTextFinder, findsOneWidget);
      expect(tvCardFinder, findsOneWidget);
      expect(tvTextFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Should show Movie results only when state is movie',
    (tester) async {
      when(() => mockSearchFilterCubit.state)
          .thenAnswer((_) => SearchFilterOption.movie);

      final movieCardFinder = find.byType(MovieCard);
      final movieTextFinder = find.text('Spider-Man');

      await tester.pumpWidget(makeTestableWidget(widget));

      expect(movieCardFinder, findsOneWidget);
      expect(movieTextFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Should show Tv results only when state is tv',
    (tester) async {
      when(() => mockSearchFilterCubit.state)
          .thenAnswer((_) => SearchFilterOption.tv);

      final tvCardFinder = find.byType(TvCard);
      final tvTextFinder = find.text('La Reina del Sur');

      await tester.pumpWidget(makeTestableWidget(widget));

      expect(tvCardFinder, findsOneWidget);
      expect(tvTextFinder, findsOneWidget);
    },
  );
}
