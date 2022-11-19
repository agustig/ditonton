import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/pages/popular_tvs_page.dart';
import 'package:ditonton/presentation/provider/popular_tvs_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockWatchlistMovieNotifier mockWatchlistMovieNotifier;
  late MockWatchlistTvNotifier mockWatchlistTvNotifier;

  setUp(() {
    mockWatchlistMovieNotifier = MockWatchlistMovieNotifier();
    mockWatchlistTvNotifier = MockWatchlistTvNotifier();
  });

  Widget _makeTestableWidget(Widget body) {
    return ChangeNotifierProvider<MockWatchlistMovieNotifier>.value(
      value: mockWatchlistMovieNotifier,
      child: ChangeNotifierProvider<MockWatchlistTvNotifier>.value(
        value: mockWatchlistTvNotifier,
        child: MaterialApp(
          home: body,
        ),
      ),
    );
  }

  // testWidgets('Page should display center progress bar when loading',
  //     (WidgetTester tester) async {
  //   when(mockNotifier.state).thenReturn(RequestState.Loading);

  //   final progressBarFinder = find.byType(CircularProgressIndicator);
  //   final centerFinder = find.byType(Center);

  //   await tester.pumpWidget(_makeTestableWidget(PopularTvsPage()));

  //   expect(centerFinder, findsOneWidget);
  //   expect(progressBarFinder, findsOneWidget);
  // });

  // testWidgets('Page should display ListView when data is loaded',
  //     (WidgetTester tester) async {
  //   when(mockNotifier.state).thenReturn(RequestState.Loaded);
  //   when(mockNotifier.tvList).thenReturn(<Tv>[]);

  //   final listViewFinder = find.byType(ListView);

  //   await tester.pumpWidget(_makeTestableWidget(PopularTvsPage()));

  //   expect(listViewFinder, findsOneWidget);
  // });

  // testWidgets('Page should display text with message when Error',
  //     (WidgetTester tester) async {
  //   when(mockNotifier.state).thenReturn(RequestState.Error);
  //   when(mockNotifier.message).thenReturn('Error message');

  //   final textFinder = find.byKey(Key('error_message'));

  //   await tester.pumpWidget(_makeTestableWidget(PopularTvsPage()));

  //   expect(textFinder, findsOneWidget);
  // });
}
