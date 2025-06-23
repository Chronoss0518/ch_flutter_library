import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformManager
{
  TargetPlatform get type => _platformType;
  bool get isWeb => _web;
  
  factory PlatformManager(BuildContext context)
  {
    final res = PlatformManager._internal();

    res._web = kIsWeb;
    res._platformType = Theme.of(context).platform;
    
    return res;
  }

  TargetPlatform _platformType = TargetPlatform.windows;
  bool _web = false;

  PlatformManager._internal();

}