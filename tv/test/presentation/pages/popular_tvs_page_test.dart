import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/cubit/popular_tvs_cubit.dart';
import 'package:tv/presentation/pages/popular_tvs_page.dart';
import 'package:tv/presentation/widgets/tv_card.dart';

import '../../dummy_data/dummy_tv_objects.dart';

class MockPopularTvsCubit extends MockCubit<PopularTvsState>
    implements PopularTvsCubit {}

void main() {
  late MockPopularTvsCubit mockCubit;

  setUp(() {
    mockCubit = MockPopularTvsCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvsCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Page should display center progress bar when loading',
    (WidgetTester tester) async {
      // arrange
      when(() => mockCubit.state).thenAnswer((_) => PopularTvsLoading());
      // act
      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);
      await tester.pumpWidget(makeTestableWidget(const PopularTvsPage()));
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
          .thenAnswer((_) => PopularTvsHasData(testTvList));
      // act
      final listViewFinder = find.byType(ListView);
      final tvCardFinder = find.byType(TvCard);
      await tester.pumpWidget(makeTestableWidget(const PopularTvsPage()));
      // assert
      expect(listViewFinder, findsOneWidget);
      expect(tvCardFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display text with message when Error',
    (WidgetTester tester) async {
      // arrange
      when(() => mockCubit.state).thenReturn(PopularTvsError('Error message'));
      // act
      final keyFinder = find.byKey(const Key('error_message'));
      final textFinder = find.text('Error message');
      await tester.pumpWidget(makeTestableWidget(const PopularTvsPage()));
      // assert
      expect(keyFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display SizedBox when state is Empty',
    (WidgetTester tester) async {
      // arrange
      when(() => mockCubit.state).thenReturn(PopularTvsEmpty());
      // act
      final keyFinder = find.byKey(const Key('empty_state'));
      final sizedBoxFinder = find.byType(SizedBox);
      await tester.pumpWidget(makeTestableWidget(const PopularTvsPage()));
      // assert
      expect(keyFinder, findsOneWidget);
      expect(sizedBoxFinder, findsOneWidget);
    },
  );
}
