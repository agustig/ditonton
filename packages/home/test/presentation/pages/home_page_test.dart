import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';
import 'package:home/presentation/cubit/home_cubit.dart';
import 'package:home/presentation/pages/home_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

void main() {
  late MockHomeCubit mockCubit;

  setUp(() {
    mockCubit = MockHomeCubit();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<HomeCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'should display Loading indicator widget data when state is loading',
    (tester) async {
      when(() => mockCubit.state).thenAnswer((_) => HomeLoading());
      await tester.pumpWidget(makeTestableWidget(HomePage()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'should display movie and tv list data when state has data',
    (tester) async {
      when(() => mockCubit.state).thenAnswer(
        (_) => HomeHasData(
          nowPlayingMovies: testMovieList,
          popularMovies: testMovieList,
          topRatedMovies: testMovieList,
          onTheAirTvs: testTvList,
          popularTvs: testTvList,
          topRatedTvs: testTvList,
        ),
      );
      await tester.pumpWidget(makeTestableWidget(HomePage()));
      expect(find.text('Movies'), findsOneWidget);
      expect(find.text('TVs'), findsOneWidget);
      expect(find.byType(TabBarView), findsOneWidget);
      final controller = DefaultTabController.of(
        tester.element(find.text('Movies')),
      ) as TabController;
      expect(controller, isNotNull);
      expect(controller.index, 0);
      expect(find.text('Now Playing'), findsOneWidget);
      expect(find.byType(MovieList), findsWidgets);

      await tester.tap(find.text('TVs'));
      await tester.pump();
      expect(controller.indexIsChanging, true);
      await tester.pump(const Duration(milliseconds: 100));
      expect(controller.index, 1);
      expect(controller.previousIndex, 0);
      expect(find.text('Airing TV Shows'), findsOneWidget);
      expect(find.byType(TvList), findsWidgets);
    },
  );

  testWidgets(
    'should display error message when state has error',
    (tester) async {
      when(() => mockCubit.state)
          .thenAnswer((_) => HomeError('Error when get data'));
      await tester.pumpWidget(makeTestableWidget(HomePage()));
      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text('Error when get data'), findsOneWidget);
    },
  );

  testWidgets(
    'should display empty sizedBox with empty key when state is empty',
    (tester) async {
      when(() => mockCubit.state).thenAnswer((_) => HomeEmpty());
      await tester.pumpWidget(makeTestableWidget(HomePage()));
      expect(find.byKey(const Key('empty_state')), findsOneWidget);
    },
  );
}
