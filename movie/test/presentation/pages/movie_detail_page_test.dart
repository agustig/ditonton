import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

void main() {
  late MockMovieDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  const tMovieDetail = testMovieDetail;
  final tMovieList = testMovieList;

  testWidgets(
    'Page should display center progress bar when loading',
    (tester) async {
      // arrange
      when(() => mockBloc.state).thenAnswer((_) => MovieDetailLoading());
      // act
      final centerFinder = find.byType(Center);
      final progressBarFinder = find.byType(CircularProgressIndicator);
      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage()));
      // assert
      expect(centerFinder, findsOneWidget);
      expect(progressBarFinder, findsOneWidget);
    },
  );

  group('Movie Detail Loaded', () {
    final tMovieDetailDataState = MovieDetailHasData(
      detail: tMovieDetail,
      movieRecommendations: tMovieList,
      isOnWatchlist: false,
    );

    testWidgets(
      'should display DetailContent when data is loaded',
      (tester) async {
        // arrange
        when(() => mockBloc.state).thenAnswer((_) => tMovieDetailDataState);
        // act
        final detailContentFinder = find.byType(DetailMovieContent);
        final draggableSheetFinder = find.byType(DraggableScrollableSheet);
        final findWatchlistIcon = find.byIcon(Icons.add);
        final recommendationSectionFinder = find.text('Recommendations');
        await tester.pumpWidget(makeTestableWidget(const MovieDetailPage()));
        // assert
        expect(detailContentFinder, findsOneWidget);
        expect(draggableSheetFinder, findsOneWidget);
        expect(findWatchlistIcon, findsOneWidget);
        expect(recommendationSectionFinder, findsOneWidget);
      },
    );

    testWidgets(
      'should display DetailContent with check watchlist icon when movie is added on watchlist',
      (tester) async {
        // arrange
        when(() => mockBloc.state).thenAnswer(
          (_) => tMovieDetailDataState.changeAttr(isOnWatchlist: true),
        );
        // act
        final findWatchlistIcon = find.byIcon(Icons.check);
        await tester.pumpWidget(makeTestableWidget(const MovieDetailPage()));
        // assert
        expect(findWatchlistIcon, findsOneWidget);
      },
    );

    testWidgets(
      'should display watchlist added status when add movie to watchlist is success',
      (tester) async {
        final states = [
          tMovieDetailDataState.changeAttr(
            isOnWatchlist: true,
            watchlistMessage: 'Added to Watchlist',
          ),
        ];
        when(() => mockBloc.state).thenAnswer((_) => tMovieDetailDataState);
        whenListen(mockBloc, Stream.fromIterable(states));

        await tester.pumpWidget(makeTestableWidget(const MovieDetailPage()));
        expect(find.byIcon(Icons.add), findsOneWidget);
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();
        expect(find.byIcon(Icons.check), findsOneWidget);
        expect(find.text('Added to Watchlist'), findsOneWidget);
      },
    );

    testWidgets(
      'should display watchlist removed status when remove movie to watchlist is success',
      (tester) async {
        final states = [
          tMovieDetailDataState.changeAttr(
            isOnWatchlist: false,
            watchlistMessage: 'Removed from Watchlist',
          ),
        ];
        when(() => mockBloc.state).thenAnswer(
            (_) => tMovieDetailDataState.changeAttr(isOnWatchlist: true));
        whenListen(mockBloc, Stream.fromIterable(states));

        await tester.pumpWidget(makeTestableWidget(const MovieDetailPage()));
        expect(find.byIcon(Icons.check), findsOneWidget);
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();
        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.text('Removed from Watchlist'), findsOneWidget);
      },
    );

    testWidgets(
      'should display alertDialog when add movie to watchlist is failed',
      (tester) async {
        final states = [
          tMovieDetailDataState.changeAttr(
            watchlistMessage: 'Database Failure',
          ),
        ];
        when(() => mockBloc.state).thenAnswer((_) => tMovieDetailDataState);
        whenListen(mockBloc, Stream.fromIterable(states));

        await tester.pumpWidget(makeTestableWidget(const MovieDetailPage()));
        expect(find.byIcon(Icons.add), findsOneWidget);
        await tester.pump();
        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.byType(AlertDialog), findsOneWidget);
        expect(find.text('Database Failure'), findsOneWidget);
      },
    );
  });

  testWidgets(
    'Page should display text with message when Error',
    (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(MovieDetailError('Error message'));
      // act
      final keyFinder = find.byKey(const Key('error_message'));
      final textFinder = find.text('Error message');
      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage()));
      // assert
      expect(keyFinder, findsOneWidget);
      expect(textFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Page should display SizedBox with key when state is empty',
    (WidgetTester tester) async {
      // arrange
      when(() => mockBloc.state).thenReturn(MovieDetailEmpty());
      // act
      final keyFinder = find.byKey(const Key('empty_state'));
      final sizedBoxFinder = find.byType(SizedBox);
      await tester.pumpWidget(makeTestableWidget(const MovieDetailPage()));
      // assert
      expect(keyFinder, findsOneWidget);
      expect(sizedBoxFinder, findsOneWidget);
    },
  );
}
