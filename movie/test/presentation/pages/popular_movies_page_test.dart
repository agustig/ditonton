import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/cubit/popular_movies_cubit.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/widgets/movie_card.dart';

import '../../dummy_data/dummy_objects.dart';

class MockPopularMoviesCubit extends MockCubit<PopularMoviesState>
    implements PopularMoviesCubit {}

void main() {
  late MockPopularMoviesCubit mockCubit;

  setUp(() {
    mockCubit = MockPopularMoviesCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Page should display center progress bar when loading',
    (WidgetTester tester) async {
      // arrange
      when(() => mockCubit.state).thenAnswer((_) => PopularMoviesLoading());
      // act
      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);
      await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));
      // assert
      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display ListView when data is loaded',
    (WidgetTester tester) async {
      // arrange
      when(() => mockCubit.state)
          .thenAnswer((_) => PopularMoviesHasData(testMovieList));
      // act
      final listViewFinder = find.byType(ListView);
      final movieCardFinder = find.byType(MovieCard);
      await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));
      // assert
      expect(listViewFinder, findsOneWidget);
      expect(movieCardFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display text with message when Error',
    (WidgetTester tester) async {
      // arrange
      when(() => mockCubit.state)
          .thenReturn(PopularMoviesError('Error message'));
      // act
      final keyFinder = find.byKey(const Key('error_message'));
      final textFinder = find.text('Error message');
      await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));
      // assert
      expect(keyFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display SizedBox when state is Empty',
    (WidgetTester tester) async {
      // arrange
      when(() => mockCubit.state).thenReturn(PopularMoviesEmpty());
      // act
      final keyFinder = find.byKey(const Key('empty_state'));
      final sizedBoxFinder = find.byType(SizedBox);
      await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));
      // assert
      expect(keyFinder, findsOneWidget);
      expect(sizedBoxFinder, findsOneWidget);
    },
  );
}
