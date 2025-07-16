import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AImage extends StatelessWidget {
  const AImage({
    super.key,
    required this.imgPath,
    this.height,
    this.width,
    this.color,
    this.fit,
  });
  final String imgPath;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Color? color;

  @override
  Widget build(BuildContext context) => (imgPath.contains('.svg'))
      ? SvgPicture.asset(
          imgPath,
          width: width,
          height: height,
          fit: fit ?? BoxFit.scaleDown,
          colorFilter: color == null
              ? null
              : ColorFilter.mode(color!, BlendMode.srcIn),
        )
      : Image.asset(
          imgPath,
          width: width,
          height: height,
          fit: fit ?? BoxFit.cover,
          color: color,
        );
}
