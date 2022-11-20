import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/provider/watchlist_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card.dart';
import 'package:ditonton/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist';

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WatchlistNotifier>(context, listen: false)
            .fetchWatchlist());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Provider.of<WatchlistNotifier>(context, listen: false).fetchWatchlist();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WatchlistNotifier>(
      builder: (context, data, child) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                title: Text('Watchlist'),
                bottom: (data.watchlistState == RequestState.loaded)
                    ? TabBar(
                        tabs: [
                          Text('Movies', style: kHeading6),
                          Text('TVs', style: kHeading6),
                        ],
                        indicatorColor: kMikadoYellow,
                      )
                    : null,
              ),
              body: _bodyContent(data)),
        );
      },
    );
  }

  Widget _bodyContent(WatchlistNotifier data) {
    switch (data.watchlistState) {
      case RequestState.loading:
        return Center(child: CircularProgressIndicator());
      case RequestState.empty:
        return Center();
      case RequestState.error:
        return Center(
          key: Key('error_message'),
          child: Text(data.message),
        );
      case RequestState.loaded:
        return TabBarView(
          children: [
            _movieTab(data.watchlistMovies),
            _tvTab(data.watchlistTvs),
          ],
        );
    }
  }

  Widget _movieTab(List<Movie> moviesData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          final movie = moviesData[index];
          return MovieCard(movie);
        },
        itemCount: moviesData.length,
      ),
    );
  }

  Widget _tvTab(List<Tv> tvsData) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemBuilder: (context, index) {
          final tv = tvsData[index];
          return TvCard(tv);
        },
        itemCount: tvsData.length,
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
