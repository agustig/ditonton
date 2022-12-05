import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/utils/constants.dart';
import 'package:flutter/material.dart';

class CustomCacheImage extends StatelessWidget {
  final String? imageUrlPath;
  final String secondLocalImage;
  final double? width;
  final double? height;
  final BoxFit? fit;
  const CustomCacheImage({
    super.key,
    required this.imageUrlPath,
    required this.secondLocalImage,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrlPath != null) {
      return CachedNetworkImage(
        width: width,
        height: height,
        fit: fit,
        imageUrl: '$baseImageUrl$imageUrlPath',
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: fit,
            image: AssetImage(
              secondLocalImage,
              package: 'core',
            ),
          ),
        ),
      );
    }
  }
}
