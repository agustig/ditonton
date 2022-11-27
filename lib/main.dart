import 'package:about/about.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';
import 'package:movie/movie.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:search/search.dart';
import 'package:tv/tv.dart';
import 'package:watchlist/watchlist.dart';

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<PopularMoviesCubit>()),
        BlocProvider(create: (_) => di.locator<TopRatedMoviesCubit>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<OnTheAirTvsCubit>()),
        BlocProvider(create: (_) => di.locator<PopularTvsCubit>()),
        BlocProvider(create: (_) => di.locator<TopRatedTvsCubit>()),
        BlocProvider(create: (_) => di.locator<TvDetailBloc>()),
        BlocProvider(create: (_) => di.locator<SearchBloc>()),
        BlocProvider(create: (_) => di.locator<SearchFilterCubit>()),
        BlocProvider(create: (_) => di.locator<WatchlistCubit>()),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => di.locator<MovieListNotifier>(),
          ),
          ChangeNotifierProvider(
            create: (_) => di.locator<TvListNotifier>(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData.dark().copyWith(
            colorScheme: kColorScheme,
            primaryColor: kRichBlack,
            scaffoldBackgroundColor: kRichBlack,
            textTheme: kTextTheme,
          ),
          home: HomePage(),
          navigatorObservers: [routeObserver],
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/home':
                return MaterialPageRoute(builder: (_) => HomePage());
              case popularMoviesRoute:
                return CupertinoPageRoute(builder: (context) {
                  context.read<PopularMoviesCubit>().fetch();
                  return PopularMoviesPage();
                });
              case topRatedMoviesRoute:
                return CupertinoPageRoute(builder: (context) {
                  context.read<TopRatedMoviesCubit>().fetch();
                  return TopRatedMoviesPage();
                });
              case movieDetailRoute:
                final id = settings.arguments as int;
                return MaterialPageRoute(
                  builder: (context) {
                    context.read<MovieDetailBloc>().add(FetchMovieDetail(id));
                    return MovieDetailPage();
                  },
                  settings: settings,
                );
              case onTheAirTvsRoute:
                return CupertinoPageRoute(builder: (context) {
                  context.read<OnTheAirTvsCubit>().fetch();
                  return OnTheAirTvsPage();
                });
              case popularTvsRoute:
                return CupertinoPageRoute(builder: (context) {
                  context.read<PopularTvsCubit>().fetch();
                  return PopularTvsPage();
                });
              case topRatedTvsRoute:
                return CupertinoPageRoute(builder: (context) {
                  context.read<TopRatedTvsCubit>().fetch();
                  return TopRatedTvsPage();
                });
              case tvDetailRoute:
                final id = settings.arguments as int;
                return MaterialPageRoute(
                  builder: (context) {
                    context.read<TvDetailBloc>().add(FetchTvDetail(id));
                    return TvDetailPage();
                  },
                  settings: settings,
                );
              case searchRoute:
                return CupertinoPageRoute(builder: (_) => SearchPage());
              case watchlistRoute:
                return MaterialPageRoute(builder: (_) => WatchlistPage());
              case aboutRoute:
                return MaterialPageRoute(builder: (_) => AboutPage());
              default:
                return MaterialPageRoute(
                  builder: (_) {
                    return Scaffold(
                      body: Center(
                        child: Text('Page not found :('),
                      ),
                    );
                  },
                );
            }
          },
        ),
      ),
    );
  }
}
