import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card.dart';
import 'package:ditonton/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) {
                Provider.of<MovieSearchNotifier>(context, listen: false)
                    .fetchMovieSearch(query);
                Provider.of<TvSearchNotifier>(context, listen: false)
                    .fetchTvSearch(query);
              },
              decoration: InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            Consumer<TvSearchNotifier>(builder: (context, tvData, _) {
              return Consumer<MovieSearchNotifier>(
                builder: (context, movieData, _) {
                  if (movieData.state == RequestState.loading ||
                      tvData.state == RequestState.loading) {
                    return Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (movieData.state == RequestState.loaded &&
                      tvData.state == RequestState.loaded) {
                    final movieResults = movieData.searchResult;
                    final tvResults = tvData.searchResult;
                    return Expanded(
                      child: SearchResult(
                        movieResults: movieResults,
                        tvResults: tvResults,
                      ),
                    );
                  } else {
                    return Expanded(
                      child: Container(),
                    );
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

enum _FilterMenu { all, movie, tv }

class SearchResult extends StatefulWidget {
  const SearchResult({
    Key? key,
    required this.movieResults,
    required this.tvResults,
  }) : super(key: key);

  final List<Movie> movieResults;
  final List<Tv> tvResults;

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  _FilterMenu _filterMenu = _FilterMenu.all;
  @override
  Widget build(BuildContext context) {
    final movieResults = widget.movieResults;
    final tvResults = widget.tvResults;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Search Result',
                style: kHeading6,
              ),
              DropdownButton<_FilterMenu>(
                value: _filterMenu,
                onChanged: (value) {
                  setState(() {
                    _filterMenu = value ?? _filterMenu;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: _FilterMenu.all,
                    child: Text('All'),
                  ),
                  DropdownMenuItem(
                    value: _FilterMenu.movie,
                    child: Text('Movie'),
                  ),
                  DropdownMenuItem(
                    value: _FilterMenu.tv,
                    child: Text('TV'),
                  ),
                ],
              ),
            ],
          ),
          Builder(builder: (context) {
            switch (_filterMenu) {
              case _FilterMenu.movie:
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final movie = movieResults[index];
                      return MovieCard(movie);
                    },
                    itemCount: movieResults.length,
                  ),
                );
              case _FilterMenu.tv:
                return Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final tv = tvResults[index];
                      return TvCard(tv);
                    },
                    itemCount: tvResults.length,
                  ),
                );
              case _FilterMenu.all:
                final moviesShorted = movieResults.take(5);
                final tvsShorted = tvResults.take(5);
                return Flexible(
                  child: ListView(
                    children: [
                      Text('Movie', style: kHeading5),
                      const SizedBox(height: 8),
                      ...moviesShorted
                          .map((movie) => MovieCard(movie))
                          .toList(),
                      const SizedBox(height: 12),
                      Text('TV', style: kHeading5),
                      const SizedBox(height: 8),
                      ...tvsShorted.map((tv) => TvCard(tv)).toList(),
                    ],
                  ),
                );
            }
          }),
        ],
      ),
    );
  }
}
