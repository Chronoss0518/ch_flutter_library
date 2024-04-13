import 'package:flutter/material.dart';

class ImageSomeDrawerController
{
  double _drawLeft = 0;
  double _drawTop = 0;

  void update()
  {
    _vController.jumpTo(_drawTop);
    _hController.jumpTo(_drawLeft);
  }

  double get drawLeft{return _drawLeft;}
  set drawLeft (double value)
  {
    _drawLeft = value;
    double width = _baseWidth - _widgetWidth;
    if(width <= 0)return;
    _drawLeft %= width;
    if(_drawLeft < 0)_drawLeft = width - _drawLeft;
  }

  double get drawTop{return _drawTop;}
  set drawTop (double value)
  {
    _drawTop = value;
    double height = _baseHeight - _widgetHeight;
    if(height <= 0)return;
    _drawTop %= height;
    if(_drawTop < 0)_drawTop = height - _drawTop;
  }

  double get baseWidth {return _baseWidth;}
  double get baseHeight {return _baseHeight;}

  double _widgetWidth = 1;
  double _widgetHeight = 1;
  double _baseWidth = 1;
  double _baseHeight = 1;

  final ScrollController _vController = ScrollController();
  final ScrollController _hController = ScrollController();
}

class ImageSomeDrawer extends StatelessWidget {
  const ImageSomeDrawer(this.imagePath,this.controller,
      {this.width = 0,
      this.height = 0,
      this.imageWidth = 0,
      this.imageHeight = 0,
      this.margin,
      this.padding,
      this.imageColor,
      this.imageColorBlendMode = BlendMode.srcIn,
      super.key});

  final double width;
  final double height;
  final double imageWidth;
  final double imageHeight;

  final ImageSomeDrawerController controller;

  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final String imagePath;
  final Color? imageColor;
  final BlendMode imageColorBlendMode;

  @override
  Widget build(BuildContext context) {
    
    ColorFilter? imageColorFilter = imageColor != null ? ColorFilter.mode(imageColor!,imageColorBlendMode) : null;


    var res =  Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller._vController,
        children:[ 
        SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        controller: controller._hController,
        child: Container(
          width: imageWidth,
          height: imageHeight,
          decoration: BoxDecoration(
            image:DecorationImage(
              colorFilter: imageColorFilter,
              image: AssetImage(imagePath), 
              fit: BoxFit.fill)),
        ),
      ),]),
    );

    controller._baseWidth = imageWidth;
    controller._baseHeight = imageHeight;

    controller._widgetWidth = width;
    controller._widgetHeight = height;
    return res;
  }
}
