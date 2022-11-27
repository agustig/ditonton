import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:movie/domain/entities/movie.dart';

class MovieList extends StatelessWidget {
  final List<Movie> movies;
  final double? height;

  final bool replaceOnPush;

  const MovieList(
    this.movies, {
    super.key,
    this.height = 200,
    this.replaceOnPush = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                if (replaceOnPush) {
                  Navigator.pushReplacementNamed(
                    context,
                    movieDetailRoute,
                    arguments: movie.id,
                  );
                } else {
                  Navigator.pushNamed(
                    context,
                    movieDetailRoute,
                    arguments: movie.id,
                  );
                }
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CustomCacheImage(
                  imageUrlPath: movie.posterPath,
                  secondLocalImage: 'assets/no-image-vertical.jpg',
                ),
              ),
            ),
          );
        },
        itemCount: movies.length,
      ),
    );
  }
}
