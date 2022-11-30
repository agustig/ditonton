import 'package:ditonton/injection.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home/home.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ditonton/main.dart' as app;
import 'package:movie/movie.dart';
import 'package:search/search.dart';
import 'package:tv/tv.dart';
import 'package:watchlist/watchlist.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('End to end test', () {
    final seeMoreButtonFinder = find.text('See More');
    final movieCardFinder = find.byType(MovieCard);
    final tvCardFinder = find.byType(TvCard);
    final tvTabBarFinder = find.text('TVs');
    final movieListItemFinder = find.byKey(Key('movie-list-item0'));
    final tvListItemFinder = find.byKey(Key('tv-list-item2'));
    final homePageFinder = find.byType(HomePage);
    final detailScrollable = find.byType(SingleChildScrollView);
    final movieDetailPageFinder = find.byType(MovieDetailPage);
    final tvDetailPageFinder = find.byType(TvDetailPage);

    group('Navigate between main pages', () {
      testWidgets(
        'should HomePage as first page load',
        (tester) async {
          await tester.pumpApp();
          expect(homePageFinder, findsOneWidget);

          await tester.closeApp();
        },
      );

      testWidgets(
        'should navigate to PopularMoviesPage then MovieDetailPage then back to HomePage',
        (tester) async {
          await tester.pumpApp();
          await tester.tap(seeMoreButtonFinder.first);
          await tester.pumpAndSettle();
          expect(find.byType(PopularMoviesPage), findsOneWidget);

          await tester.tap(movieCardFinder.first);
          await tester.pumpAndSettle();
          expect(movieDetailPageFinder, findsOneWidget);

          await tester.detailPageBack();
          await tester.pageBack();
          await tester.pumpAndSettle();
          expect(homePageFinder, findsOneWidget);

          await tester.closeApp();
        },
      );

      testWidgets(
        'should navigate to TopRatedMoviesPage then MovieDetailPage then back to HomePage',
        (tester) async {
          await tester.pumpApp();
          await tester.tap(seeMoreButtonFinder.at(1));
          await tester.pumpAndSettle();
          expect(find.byType(TopRatedMoviesPage), findsOneWidget);

          await tester.tap(movieCardFinder.first);
          await tester.pumpAndSettle();
          expect(movieDetailPageFinder, findsOneWidget);

          await tester.detailPageBack();
          await tester.pageBack();
          await tester.pumpAndSettle();
          expect(homePageFinder, findsOneWidget);

          await tester.closeApp();
        },
      );

      testWidgets(
        'should navigate to OnTheAirTvsPage then TvDetailPage then back to HomePage',
        (tester) async {
          await tester.pumpApp();
          await tester.tap(tvTabBarFinder.first);
          await tester.pumpAndSettle();
          await tester.tap(seeMoreButtonFinder.first);
          await tester.pumpAndSettle();
          expect(find.byType(OnTheAirTvsPage), findsOneWidget);

          await tester.tap(tvCardFinder.first);
          await tester.pumpAndSettle();
          expect(tvDetailPageFinder, findsOneWidget);

          await tester.detailPageBack();
          await tester.pageBack();
          await tester.pumpAndSettle();
          expect(homePageFinder, findsOneWidget);

          await tester.closeApp();
        },
      );

      testWidgets(
        'should navigate to PopularTvsPage then TvDetailPage then back to HomePage',
        (tester) async {
          await tester.pumpApp();
          await tester.tap(tvTabBarFinder.first);
          await tester.pumpAndSettle();
          await tester.tap(seeMoreButtonFinder.at(1));
          await tester.pumpAndSettle();
          expect(find.byType(PopularTvsPage), findsOneWidget);

          await tester.tap(tvCardFinder.first);
          await tester.pumpAndSettle();
          expect(tvDetailPageFinder, findsOneWidget);

          await tester.detailPageBack();
          await tester.pageBack();
          await tester.pumpAndSettle();
          expect(homePageFinder, findsOneWidget);

          await tester.closeApp();
        },
      );

      testWidgets(
        'should navigate to TopRatedTvsPage then TvDetailPage then back to HomePage',
        (tester) async {
          await tester.pumpApp();
          await tester.tap(tvTabBarFinder.first);
          await tester.pumpAndSettle();
          await tester.tap(seeMoreButtonFinder.at(2));
          await tester.pumpAndSettle();
          expect(find.byType(TopRatedTvsPage), findsOneWidget);

          await tester.tap(tvCardFinder.first);
          await tester.pumpAndSettle();
          expect(tvDetailPageFinder, findsOneWidget);

          await tester.detailPageBack();
          await tester.pageBack();
          await tester.pumpAndSettle();
          expect(homePageFinder, findsOneWidget);

          await tester.closeApp();
        },
      );

      testWidgets(
        'should navigate MovieDetailPage then MovieDetailPage on Recommendation then back to HomePage',
        (tester) async {
          await tester.pumpApp();
          await tester.tap(movieListItemFinder.at(1));
          await tester.pumpAndSettle();
          expect(movieDetailPageFinder, findsOneWidget);

          await tester.dragUntilVisible(
            find.byType(MovieList),
            detailScrollable,
            const Offset(0, 500),
          );
          await tester.tap(movieListItemFinder);
          await tester.pumpAndSettle();
          expect(movieDetailPageFinder, findsOneWidget);

          await tester.detailPageBack();
          expect(homePageFinder, findsOneWidget);

          await tester.closeApp();
        },
      );

      testWidgets(
        'should navigate TvDetailPage then TvDetailPage on Recommendation then back to HomePage',
        (tester) async {
          await tester.pumpApp();
          await tester.tap(tvTabBarFinder.first);
          await tester.pumpAndSettle();
          await tester.tap(tvListItemFinder.at(0));
          await tester.pumpAndSettle();
          expect(tvDetailPageFinder, findsOneWidget);

          await tester.dragUntilVisible(
            find.byType(SeasonTile).first,
            detailScrollable,
            const Offset(0, 500),
          );
          expect(find.byType(SeasonTile), findsWidgets);

          await tester.tap(find.byType(SeasonTile).first);
          await tester.pumpAndSettle();
          expect(find.byType(TvEpisodeListTile), findsWidgets);

          await tester.dragUntilVisible(
            find.byType(TvList).last,
            detailScrollable,
            const Offset(0, 500),
          );
          await tester.tap(tvListItemFinder);
          await tester.pumpAndSettle();
          expect(tvDetailPageFinder, findsOneWidget);

          await tester.detailPageBack();
          expect(homePageFinder, findsOneWidget);

          await tester.closeApp();
        },
      );
    });

    group('Search movie & tv', () {
      final searchIconFinder = find.byIcon(Icons.search);

      testWidgets(
        "should return movie and tv list when search query returns result",
        (tester) async {
          await tester.pumpApp();
          await tester.tap(searchIconFinder);
          await tester.pumpAndSettle();
          expect(find.byType(SearchPage), findsOneWidget);
          expect(find.text('Search Movie or TV Show by title'), findsOneWidget);

          await tester.enterText(find.byType(TextField), 'doraemon');
          await tester.testTextInput.receiveAction(TextInputAction.done);
          await Future.delayed(const Duration(milliseconds: 500));
          await tester.pumpAndSettle();
          expect(movieCardFinder, findsWidgets);

          final Offset point = tester.getCenter(movieCardFinder.at(2));
          await tester.dragFrom(point, Offset(0.0, -500.0));
          await tester.pump();
          expect(tvCardFinder, findsWidgets);

          await tester.tap(find.byKey(Key('search-filter-dropdown')));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Movie').last);
          await tester.pumpAndSettle();
          expect(movieCardFinder, findsWidgets);
          expect(tvCardFinder, findsNothing);

          await tester.tap(movieCardFinder.first);
          await tester.pumpAndSettle();
          expect(movieDetailPageFinder, findsOneWidget);

          await tester.detailPageBack();

          await tester.tap(find.byKey(Key('search-filter-dropdown')));
          await tester.pumpAndSettle();
          await tester.tap(find.text('TV').last);
          await tester.pumpAndSettle();
          expect(tvCardFinder, findsWidgets);
          expect(movieCardFinder, findsNothing);

          await tester.tap(tvCardFinder.first);
          await tester.pumpAndSettle();
          expect(tvDetailPageFinder, findsOneWidget);

          await tester.detailPageBack();
          await tester.pageBack();
          await tester.closeApp();
        },
      );
    });

    group('Watchlist', () {
      final addIconFinder = find.byIcon(Icons.add);
      final checkIconFinder = find.byIcon(Icons.check);
      final watchlistAddedMessage = find.text('Added to Watchlist');
      final watchlistRemovedMessage = find.text('Removed from Watchlist');
      final drawerIconFinder = find.byIcon(Icons.menu);
      final watchlistIconFinder = find.byIcon(Icons.save_alt);

      testWidgets(
        'should return snackbar when add or remove watchlist movie',
        (tester) async {
          await tester.pumpApp();
          await tester.tap(movieListItemFinder.at(2));
          await tester.pumpAndSettle();
          await tester.tap(addIconFinder);
          await tester.pumpAndSettle();
          expect(watchlistAddedMessage, findsOneWidget);
          expect(checkIconFinder, findsOneWidget);

          await Future.delayed(Duration(seconds: 4));
          await tester.dragUntilVisible(
            find.byType(MovieList),
            detailScrollable,
            const Offset(0, 500),
          );
          await tester.tap(movieListItemFinder);
          await tester.pumpAndSettle();
          await tester.tap(addIconFinder);
          await tester.pumpAndSettle();
          expect(watchlistAddedMessage, findsOneWidget);
          expect(checkIconFinder, findsOneWidget);

          await Future.delayed(Duration(seconds: 4));
          await tester.detailPageBack();
          await tester.tap(drawerIconFinder);
          await tester.pumpAndSettle();
          await tester.tap(watchlistIconFinder);
          await tester.pumpAndSettle();
          expect(find.byType(WatchlistPage), findsOneWidget);
          expect(movieCardFinder, findsWidgets);

          await tester.tap(movieCardFinder.first);
          await tester.pumpAndSettle();
          await tester.tap(checkIconFinder);
          await tester.pumpAndSettle();
          expect(watchlistRemovedMessage, findsOneWidget);
          expect(addIconFinder, findsOneWidget);

          await Future.delayed(Duration(seconds: 4));
          await tester.detailPageBack();
          await tester.tap(movieCardFinder.first);
          await tester.pumpAndSettle();
          await tester.tap(checkIconFinder);
          await tester.pumpAndSettle();
          expect(watchlistRemovedMessage, findsOneWidget);
          expect(addIconFinder, findsOneWidget);

          await Future.delayed(Duration(seconds: 4));
          await tester.detailPageBack();
          expect(find.text('Movie watchlist is empty'), findsOneWidget);

          await tester.pageBack();
          await tester.closeApp();
        },
      );

      testWidgets(
        'should return snackbar when add or remove watchlist tv',
        (tester) async {
          await tester.pumpApp();
          await tester.tap(tvTabBarFinder.first);
          await tester.pumpAndSettle();
          await tester.tap(tvListItemFinder.at(0));
          await tester.pumpAndSettle();
          await tester.tap(addIconFinder);
          await tester.pumpAndSettle();
          expect(watchlistAddedMessage, findsOneWidget);
          expect(checkIconFinder, findsOneWidget);

          await Future.delayed(Duration(seconds: 4));
          await tester.dragUntilVisible(
            find.byType(TvList),
            detailScrollable,
            const Offset(0, 500),
          );
          await tester.tap(tvListItemFinder);
          await tester.pumpAndSettle();
          await tester.tap(addIconFinder);
          await tester.pumpAndSettle();
          expect(watchlistAddedMessage, findsOneWidget);
          expect(checkIconFinder, findsOneWidget);

          await Future.delayed(Duration(seconds: 4));
          await tester.detailPageBack();
          await tester.tap(drawerIconFinder);
          await tester.pumpAndSettle();
          await tester.tap(watchlistIconFinder);
          await tester.pumpAndSettle();
          expect(find.byType(WatchlistPage), findsOneWidget);

          await tester.tap(tvTabBarFinder.first);
          await tester.pumpAndSettle();
          expect(tvCardFinder, findsWidgets);

          await tester.tap(tvCardFinder.first);
          await tester.pumpAndSettle();
          await tester.tap(checkIconFinder);
          await tester.pumpAndSettle();
          expect(watchlistRemovedMessage, findsOneWidget);
          expect(addIconFinder, findsOneWidget);

          await Future.delayed(Duration(seconds: 4));
          await tester.detailPageBack();
          await tester.tap(tvCardFinder.first);
          await tester.pumpAndSettle();
          await tester.tap(checkIconFinder);
          await tester.pumpAndSettle();
          expect(watchlistRemovedMessage, findsOneWidget);
          expect(addIconFinder, findsOneWidget);

          await Future.delayed(Duration(seconds: 4));
          await tester.detailPageBack();
          expect(find.text('TV watchlist is empty'), findsOneWidget);

          await tester.pageBack();
          await tester.closeApp();
        },
      );
    });
  });
}

extension on WidgetTester {
  Future<void> pumpApp() async {
    app.main();
    await pumpAndSettle();
  }

  Future<void> detailPageBack() async {
    await tap(find.byIcon(Icons.arrow_back).first);
    await pumpAndSettle();
  }

  Future<void> closeApp() async {
    await di.locator.reset(dispose: true);
    await pumpAndSettle();
  }
}
