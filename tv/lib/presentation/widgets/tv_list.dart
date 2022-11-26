import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:tv/domain/entities/tv.dart';

class TvList extends StatelessWidget {
  final List<Tv> tvs;
  final double height;

  const TvList(this.tvs, {super.key, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tv = tvs[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  tvDetailRoute,
                  arguments: tv.id,
                );
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
