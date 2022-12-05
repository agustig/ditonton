import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/movie.dart';
import 'package:search/presentation/cubit/search_filter_cubit.dart';
import 'package:tv/tv.dart';

class SearchResult extends StatelessWidget {
  const SearchResult({
    super.key,
    required this.movieResults,
    required this.tvResults,
  });

  final List<Movie> movieResults;
  final List<Tv> tvResults;

  @override
  Widget build(BuildContext context) {
    final searchFilter = context.watch<SearchFilterCubit>().state;
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
              DropdownButton<SearchFilterOption>(
                key: const Key('search-filter-dropdown'),
                value: searchFilter,
                onChanged: (value) {
                  context.read<SearchFilterCubit>().filterBy(value);
                },
                items: const [
                  DropdownMenuItem(
                    value: SearchFilterOption.all,
                    child: Text('All'),
                  ),
                  DropdownMenuItem(
                    value: SearchFilterOption.movie,
                    child: Text('Movie'),
                  ),
                  DropdownMenuItem(
                    value: SearchFilterOption.tv,
                    child: Text('TV'),
                  ),
                ],
              ),
            ],
          ),
          Builder(builder: (context) {
            switch (searchFilter) {
              case SearchFilterOption.movie:
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
              case SearchFilterOption.tv:
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
              case SearchFilterOption.all:
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
