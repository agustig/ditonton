import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';
import 'package:watchlist/presentation/cubit/watchlist_cubit.dart';
import 'package:watchlist/presentation/pages/watchlist_page.dart';

class MockWatchlistCubit extends MockCubit<WatchlistState>
    implements WatchlistCubit {}

void main() {
  late MockWatchlistCubit mockCubit;

  setUp(() {
    mockCubit = MockWatchlistCubit();
  });

  const testMovie = Movie(
    id: 557,
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    title: 'Spider-Man',
  );

  const testTv = Tv(
    id: 31586,
    name: 'La Reina del Sur',
    overview:
        "After years of blood, sweat and tears, a woman of humble origin ends up becoming a drug trafficking legend, with all that that means...",
    posterPath: "/p11t8ckTC6EiuVw5FGFKdc2Z7GH.jpg",
  );

  final testMovieList = [testMovie];
  final testTvList = [testTv];

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistCubit>.value(
      value: mockCubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'should display Loading indicator widget data when state is loading',
    (tester) async {
      when(() => mockCubit.state).thenAnswer((_) => WatchlistLoading());
      await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'should display movie and tv list data when state has data with list',
    (tester) async {
      when(() => mockCubit.state).thenAnswer(
        (_) => WatchlistHasData(movies: testMovieList, tvs: testTvList),
      );
      await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));
      expect(find.text('Movies'), findsOneWidget);
      expect(find.text('TVs'), findsOneWidget);
      expect(find.byType(TabBarView), findsOneWidget);
      final controller = DefaultTabController.of(
        tester.element(find.text('Movies')),
      ) as TabController;
      expect(controller, isNotNull);
      expect(controller.index, 0);
      expect(find.byType(MovieCard), findsWidgets);

      await tester.tap(find.text('TVs'));
      await tester.pump();
      expect(controller.indexIsChanging, true);
      await tester.pump(const Duration(milliseconds: 100));
      expect(controller.index, 1);
      expect(controller.previousIndex, 0);
      expect(find.byType(MovieCard), findsWidgets);
    },
  );

  testWidgets(
    'should display movie or tv empty message when state has data with empty list',
    (tester) async {
      when(() => mockCubit.state).thenAnswer(
        (_) => WatchlistHasData(movies: const [], tvs: const []),
      );
      await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));
      expect(find.text('Movies'), findsOneWidget);
      expect(find.text('TVs'), findsOneWidget);
      expect(find.byType(TabBarView), findsOneWidget);
      final controller = DefaultTabController.of(
        tester.element(find.text('Movies')),
      ) as TabController;
      expect(controller, isNotNull);
      expect(controller.index, 0);
      expect(find.text('Movie watchlist is empty'), findsWidgets);
      expect(find.text('Try to add some Movie to watchlist'), findsWidgets);

      await tester.tap(find.text('TVs'));
      await tester.pump();
      expect(controller.indexIsChanging, true);
      await tester.pump(const Duration(milliseconds: 100));
      expect(controller.index, 1);
      expect(controller.previousIndex, 0);
      expect(find.text('TV watchlist is empty'), findsWidgets);
      expect(find.text('Try to add some TV to watchlist'), findsWidgets);
    },
  );

  testWidgets(
    'should display error message when state has error',
    (tester) async {
      when(() => mockCubit.state)
          .thenAnswer((_) => WatchlistError('Error when get data'));
      await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));
      expect(find.byKey(const Key('error_message')), findsOneWidget);
      expect(find.text('Error when get data'), findsOneWidget);
    },
  );

  testWidgets(
    'should display empty sizedBox with empty key when state is empty',
    (tester) async {
      when(() => mockCubit.state).thenAnswer((_) => WatchlistEmpty());
      await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));
      expect(find.byKey(const Key('empty_state')), findsOneWidget);
    },
  );
}
