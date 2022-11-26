import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/domain/entities/tv_season.dart';
import 'package:tv/presentation/bloc/tv_detail_bloc.dart';
import 'package:tv/presentation/widgets/tv_episode_list_tile.dart';

class SeasonTile extends StatelessWidget {
  final TvSeason season;
  final TvSeason? expandedSeason;

  const SeasonTile({
    super.key,
    required this.season,
    required this.expandedSeason,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = List<Widget>.from(
        season.episodes.map((episode) => TvEpisodeListTile(episode: episode)));

    if (children.isNotEmpty) {
      children.insert(
        0,
        Text(
          'Episodes:',
          style: kHeading6.copyWith(fontSize: 17),
        ),
      );
    } else {
      children.insert(
        0,
        const Text(
          "We don't have episode data for now, try later",
          style: TextStyle(color: kMikadoYellow),
        ),
      );
    }

    return ExpansionTile(
      key: Key(season.id.toString()),
      leading: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        child: CustomCacheImage(
          imageUrlPath: season.posterPath,
          secondLocalImage: 'assets/no-image-vertical.jpg',
          width: 40,
          fit: BoxFit.cover,
        ),
      ),
      title: Card(
        color: kRichBlack,
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
      subtitle: Text(
        season.overview,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      tilePadding: EdgeInsets.zero,
      initiallyExpanded: expandedSeason == season,
      onExpansionChanged: (isOpen) => context
          .read<TvDetailBloc>()
          .add(isOpen ? ExpandSeason(season) : CollapseSeason()),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      children: children,
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
