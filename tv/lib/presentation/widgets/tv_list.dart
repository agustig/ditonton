import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:tv/domain/entities/tv.dart';

class TvList extends StatelessWidget {
  final List<Tv> tvs;
  final double height;
  final bool isReplaceOnPush;

  const TvList(
    this.tvs, {
    super.key,
    this.height = 200,
    this.isReplaceOnPush = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            key: Key('tv-list-item$index'),
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                if (isReplaceOnPush) {
                  Navigator.pushReplacementNamed(
                    context,
                    tvDetailRoute,
                    arguments: tv.id,
                  );
                } else {
                  Navigator.pushNamed(
                    context,
                    tvDetailRoute,
                    arguments: tv.id,
                  );
                }
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CustomCacheImage(
                  imageUrlPath: tv.posterPath,
                  secondLocalImage: 'assets/no-image-vertical.jpg',
                ),
              ),
            ),
          );
        },
        itemCount: tvs.length,
      ),
    );
  }
}
