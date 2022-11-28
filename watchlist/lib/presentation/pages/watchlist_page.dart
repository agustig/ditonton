import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';
import 'package:watchlist/presentation/cubit/watchlist_cubit.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() => context.read<WatchlistCubit>().fetch();

  @override
  Widget build(BuildContext context) {
    final watchlistCubit = context.watch<WatchlistCubit>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Watchlist'),
          bottom: (watchlistCubit.state is WatchlistHasData)
              ? TabBar(
                  tabs: [
                    Text('Movies', style: kHeading6),
                    Text('TVs', style: kHeading6),
                  ],
                  indicatorColor: kMikadoYellow,
                )
              : null,
        ),
        body: _bodyContent(watchlistCubit.state),
      ),
    );
  }

  Widget _bodyContent(WatchlistState state) {
    if (state is WatchlistLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is WatchlistError) {
      return Center(
        key: const Key('error_message'),
        child: Text(state.message),
      );
    } else if (state is WatchlistHasData) {
      return TabBarView(
        children: [
          _movieTab(state.movies),
          _tvTab(state.tvs),
        ],
      );
    } else {
      return const SizedBox(key: Key('empty_state'));
    }
  }

  Widget _movieTab(List<Movie> moviesData) {
    if (moviesData.isEmpty) {
      return _emptyWatchlist('Movie');
    } else {
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
  }

  Widget _tvTab(List<Tv> tvsData) {
    if (tvsData.isEmpty) {
      return _emptyWatchlist('TV');
    } else {
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
  }

  Widget _emptyWatchlist(String label) {
    return Center(
      child: Column(
        children: [
          Text(
            '$label watchlist is empty',
            style: kHeading5,
          ),
          Text('Try to add some $label to watchlist')
        ],
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
