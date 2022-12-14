import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:tv/domain/entities/tv_episode.dart';

class TvEpisodeListTile extends StatelessWidget {
  const TvEpisodeListTile({
    Key? key,
    required this.episode,
  }) : super(key: key);

  final TvEpisode episode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: Stack(
              children: [
                CustomCacheImage(
                  imageUrlPath: episode.stillPath,
                  secondLocalImage: 'assets/no-image.png',
                  height: 100,
                  width: 150,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: kRichBlack,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Text(_showDuration(episode.runtime)),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _showEpisodeName(episode.episodeNumber, episode.name),
                  style: kHeading6.copyWith(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  episode.overview,
                  overflow: TextOverflow.ellipsis,
                  style: kHeading6.copyWith(fontSize: 12),
                  softWrap: true,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _showEpisodeName(int number, String name) {
    String episodeName;
    if (name.contains('Episode')) {
      episodeName = name;
    } else {
      episodeName = '$number $name';
    }
    return episodeName;
  }

  String _showDuration(int? runtime) {
    if (runtime == null) {
      return '';
    }

    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
