import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              const UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/circle-g.png',
                    package: 'core',
                  ),
                ),
                accountName: Text('Ditonton'),
                accountEmail: Text('ditonton@dicoding.com'),
              ),
              ListTile(
                leading: const Icon(Icons.movie),
                title: const Text('Movies / TVs'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.save_alt),
                title: const Text('Watchlist'),
                onTap: () {
                  Navigator.pushNamed(context, watchlistRoute);
                },
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, aboutRoute);
                },
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('Ditonton'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, searchRoute);
              },
              icon: const Icon(Icons.search),
            )
          ],
          bottom: (context.watch<HomeCubit>().state is HomeHasData)
              ? TabBar(
                  tabs: _tabBar,
                  indicatorColor: kMikadoYellow,
                )
              : null,
        ),
        body: _bodyContent(context),
      ),
    );
  }

  Widget _bodyContent(BuildContext context) {
    final homeState = context.watch<HomeCubit>().state;
    if (homeState is HomeLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (homeState is HomeHasData) {
      return TabBarView(children: [
        _movieTab(context, homeState),
        _tvTab(context, homeState),
      ]);
    } else if (homeState is HomeError) {
      return Center(
        key: const Key('error_message'),
        child: Text(homeState.message),
      );
    } else {
      return const SizedBox(key: Key('empty_state'));
    }
  }

  final _tabBar = [
    Text('Movies', style: kHeading6),
    Text('TVs', style: kHeading6),
  ];

  Padding _movieTab(BuildContext context, HomeHasData dataState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Now Playing',
              style: kHeading6,
            ),
            MovieList(dataState.nowPlayingMovies),
            _buildSubHeading(
              title: 'Popular',
              onTap: () => Navigator.pushNamed(context, popularMoviesRoute),
            ),
            MovieList(dataState.popularMovies),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () => Navigator.pushNamed(context, topRatedMoviesRoute),
            ),
            MovieList(dataState.topRatedMovies),
          ],
        ),
      ),
    );
  }

  Padding _tvTab(BuildContext context, HomeHasData dataState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubHeading(
              title: 'Airing TV Shows',
              onTap: () => Navigator.pushNamed(context, onTheAirTvsRoute),
            ),
            TvList(dataState.onTheAirTvs),
            _buildSubHeading(
              title: 'Popular',
              onTap: () => Navigator.pushNamed(context, popularTvsRoute),
            ),
            TvList(dataState.popularTvs),
            _buildSubHeading(
              title: 'Top Rated',
              onTap: () => Navigator.pushNamed(context, topRatedTvsRoute),
            ),
            TvList(dataState.topRatedTvs),
          ],
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}
