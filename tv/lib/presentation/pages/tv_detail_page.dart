import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tv/presentation/widgets/season_tile.dart';
import 'package:tv/tv.dart';

class TvDetailPage extends StatelessWidget {
  final int id;
  const TvDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    context.read<TvDetailBloc>().add(FetchDetail(id));
    return Scaffold(
      body: BlocConsumer<TvDetailBloc, TvDetailState>(
        listener: (context, state) {
          if (state is TvDetailHasData && state.watchlistMessage.isNotEmpty) {
            final message = state.watchlistMessage;
            if (message == watchlistAddSuccessMessage ||
                message == watchlistRemoveSuccessMessage) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message)),
              );
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(message),
                  );
                },
              );
            }
          }
        },
        builder: (context, state) {
          if (state is TvDetailLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvDetailHasData) {
            return SafeArea(
              child: DetailTvContent(state),
            );
          } else if (state is TvDetailError) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.message),
            );
          } else {
            return const SizedBox(key: Key('empty_state'));
          }
        },
      ),
    );
  }
}

class DetailTvContent extends StatelessWidget {
  final TvDetailHasData tvDataState;

  const DetailTvContent(this.tvDataState, {super.key});

  @override
  Widget build(BuildContext context) {
    final tv = tvDataState.detail;
    final expandedSeason = tvDataState.expandedSeason;
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CustomCacheImage(
          imageUrlPath: tv.posterPath,
          secondLocalImage: 'assets/no-image-vertical.jpg',
          width: screenWidth,
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tv.name,
                              style: kHeading5,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final tvDetailBloc =
                                    context.read<TvDetailBloc>();
                                if (!tvDataState.isAddedToWatchlist) {
                                  tvDetailBloc.add(AddToWatchlist());
                                } else {
                                  tvDetailBloc.add(RemoveFromWatchlist());
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  tvDataState.isAddedToWatchlist
                                      ? const Icon(Icons.check)
                                      : const Icon(Icons.add),
                                  const Text('Watchlist'),
                                ],
                              ),
                            ),
                            Text(_showGenres(tv.genres)),
                            Text(
                              '${tv.numberOfEpisodes} episodes in ${tv.seasons.length} seasons',
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: tv.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${tv.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              tv.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Seasons',
                              style: kHeading6,
                            ),
                            Flex(
                              key: Key(
                                'Selected: ${(expandedSeason != null) ? expandedSeason.id : -1}',
                              ),
                              direction: Axis.vertical,
                              children: tv.seasons
                                  .map(
                                    (season) => SeasonTile(
                                      season: season,
                                      expandedSeason: expandedSeason,
                                    ),
                                  )
                                  .toList(),
                            ),
                            ...tvDataState.tvRecommendations.isNotEmpty
                                ? [
                                    Text(
                                      'Recommendations',
                                      style: kHeading6,
                                    ),
                                    TvList(
                                      tvDataState.tvRecommendations,
                                      height: 150,
                                    )
                                  ]
                                : [
                                    const SizedBox(
                                      key: Key('Recommendation is empty'),
                                    )
                                  ]
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  // Widget _recommendationSection(List<Tv> recommendations) {
  //   return SizedBox(
  //     height: 150,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemBuilder: (context, index) {
  //         final tv = recommendations[index];
  //         return Padding(
  //           padding: const EdgeInsets.all(4.0),
  //           child: InkWell(
  //             onTap: () {
  //               Navigator.pushReplacementNamed(
  //                 context,
  //                 tvDetailRoute,
  //                 arguments: tv.id,
  //               );
  //             },
  //             child: ClipRRect(
  //               borderRadius: const BorderRadius.all(
  //                 Radius.circular(8),
  //               ),
  //               child: CachedNetworkImage(
  //                 imageUrl: 'https://image.tmdb.org/t/p/w500${tv.posterPath}',
  //                 placeholder: (context, url) => const Center(
  //                   child: CircularProgressIndicator(),
  //                 ),
  //                 errorWidget: (context, url, error) => const Icon(Icons.error),
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //       itemCount: recommendations.length,
  //     ),
  //   );
  // }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }
}
