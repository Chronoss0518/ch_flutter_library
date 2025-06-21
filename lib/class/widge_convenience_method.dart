import 'package:flutter/widgets.dart';

mixin WidgeConvenienceMethod
{
  Size getDisplaySizeFromContext(BuildContext context)
  {
    return MediaQuery.of(context).size;
  }

  
}