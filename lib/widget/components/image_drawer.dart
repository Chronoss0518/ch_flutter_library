import 'dart:ffi';

import 'package:flutter/material.dart';

class ImageDrawer extends StatelessWidget {
  const ImageDrawer(this.imagePath,
      {this.width = 0,
      this.height = 0,
      this.margin,
      this.padding,
      this.imageColor,
      this.imageColorBlendMode = BlendMode.srcIn,
      super.key});

  final double width;
  final double height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final String imagePath;
  final Color? imageColor;
  final BlendMode imageColorBlendMode;

  @override
  Widget build(BuildContext context) {
    
    ColorFilter? imageColorFilter = imageColor != null ? ColorFilter.mode(imageColor!,imageColorBlendMode) : null;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        image:DecorationImage(
          colorFilter: imageColorFilter,
          image: AssetImage(imagePath), 
          fit: BoxFit.fill)),
      padding: padding,
      margin: margin,
    );
  }
}
