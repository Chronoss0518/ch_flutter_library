import 'package:flutter/material.dart';

abstract class GameObject {
  @protected
  void init() {}

  @protected
  void release() {}

  @protected
  void update() {}

  @protected
  void move() {}

  @protected
  void drawBegin(BuildContext context) {}

  void _init() {
    if (!_isEnableFlg) return;
    if (_isInitFlg) return;
    init();
    for (var child in _childList) {
      child._init();
    }
    _isInitFlg = true;
  }

  void _release() {
    if (!_isEnableFlg) return;
    if (!_isInitFlg) return;
    release();
    for (var child in _childList) {
      child._release();
    }
  }

  String objectName = "";
  int tagNo = -1;
  bool _isEnableFlg = true;
  bool _isInitFlg = false;
  var _childList = <GameObject>[];
}
