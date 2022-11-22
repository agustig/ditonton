import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:tv/domain/entities/tv_season.dart';
import 'package:tv/presentation/provider/tv_detail_notifier.dart';
import 'package:tv/presentation/widgets/tv_episode_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeasonAccordion extends StatelessWidget {
  final TvSeason season;
  const SeasonAccordion(this.season, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kRichBlack,
      child: Flex(
        direction: Axis.vertical,
        children: [
          Row(
            children: [
              season.posterPath != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: '$baseImageUrl${season.posterPath}',
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                        height: 150,
                        width: 100,
                      ),
                    )
                  : Container(
                      height: 150,
                      width: 100,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/no-image-vertical.jpg',
                            package: 'core',
                          ),
                        ),
                      ),
                    ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                season.name,
                                style: kHeading6.copyWith(fontSize: 17),
                              ),
                              Text(
                                '${_showAiringYear(season.airDate)}${season.episodes.length} episodes',
                                style: kSubtitle.copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Consumer<TvDetailNotifier>(
                          builder: (context, data, _) {
                            return IconButton(
                              onPressed: () {
                                data.isSeasonExpanded(season)
                                    ? Provider.of<TvDetailNotifier>(context,
                                            listen: false)
                                        .closeExpandedSeason()
                                    : Provider.of<TvDetailNotifier>(context,
                                            listen: false)
                                        .expandSeason(season);
                              },
                              icon: Icon(
                                data.isSeasonExpanded(season)
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    Text(
                      season.overview,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 6,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Consumer<TvDetailNotifier>(
            builder: (context, data, child) {
              return data.isSeasonExpanded(season)
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Episodes:',
                          style: kHeading6.copyWith(fontSize: 17),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: season.episodes.length,
                          itemBuilder: (context, index) {
                            final episode = season.episodes[index];
                            return TvEpisodeListTile(episode: episode);
                          },
                        ),
                      ],
                    )
                  : const SizedBox();
            },
          )
        ],
      ),
    );
  }

  String _showAiringYear(String? date) {
    if (date != null) {
      final dateTime = DateTime.parse(date);
      return '${dateTime.year} | ';
    } else {
      return '';
    }
  }
}
