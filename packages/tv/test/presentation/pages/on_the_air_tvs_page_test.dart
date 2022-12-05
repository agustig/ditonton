import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/tv.dart';

import '../../dummy_data/dummy_tv_objects.dart';

class MockOnTheAirTvsCubit extends MockCubit<OnTheAirTvsState>
    implements OnTheAirTvsCubit {}

void main() {
  late MockOnTheAirTvsCubit mockCubit;

  setUp(() {
    mockCubit = MockOnTheAirTvsCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<OnTheAirTvsCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Page should display center progress bar when loading',
    (WidgetTester tester) async {
      // arrange
      when(() => mockCubit.state).thenAnswer((_) => OnTheAirTvsLoading());
      // act
      final progressBarFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);
      await tester.pumpWidget(makeTestableWidget(const OnTheAirTvsPage()));
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
          .thenAnswer((_) => OnTheAirTvsHasData(testTvList));
      // act
      final listViewFinder = find.byType(ListView);
      final tvCardFinder = find.byType(TvCard);
      await tester.pumpWidget(makeTestableWidget(const OnTheAirTvsPage()));
      // assert
      expect(listViewFinder, findsOneWidget);
      expect(tvCardFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display text with message when Error',
    (WidgetTester tester) async {
      // arrange
      when(() => mockCubit.state).thenReturn(OnTheAirTvsError('Error message'));
      // act
      final keyFinder = find.byKey(const Key('error_message'));
      final textFinder = find.text('Error message');
      await tester.pumpWidget(makeTestableWidget(const OnTheAirTvsPage()));
      // assert
      expect(keyFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display SizedBox when state is Empty',
    (WidgetTester tester) async {
      // arrange
      when(() => mockCubit.state).thenReturn(OnTheAirTvsEmpty());
      // act
      final keyFinder = find.byKey(const Key('empty_state'));
      final sizedBoxFinder = find.byType(SizedBox);
      await tester.pumpWidget(makeTestableWidget(const OnTheAirTvsPage()));
      // assert
      expect(keyFinder, findsOneWidget);
      expect(sizedBoxFinder, findsOneWidget);
    },
  );
}
