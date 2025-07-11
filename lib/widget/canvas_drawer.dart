import 'package:ch_flutter_library/class/vector.dart';
import 'package:flutter/material.dart';

mixin _CanvasDrawerObjectBase
{
  final Vector2 pos = Vector2();

  double get x => pos.x;
  double get y => pos.y;

  set x(double val) {
    pos.x = val;
  }

  set y(double val) {
    pos.y = val;
  }
  
  void paint(Canvas canvas, Size size);

  bool isOnDisplay();

}

class SquareDrawer with _CanvasDrawerObjectBase
{
  final Vector2 _size = Vector2();
  
  Vector2 get size => _size;

  double get w => _size.w;
  double get h => _size.h;

  set size(Vector2 val) {
    if(val.w <= 0.0)return;
    if(val.h <= 0.0)return;

    _size.w = val.w;
    _size.h = val.h;
  }

  set w(double val) {
    if(val <= 0.0)return;
    _size.w = val;
  }

  set h(double val) {
    if(val <= 0.0)return;
    _size.h = val;
  }

  @override
  void paint(Canvas canvas, Size size) {
    
  }

  @override
  bool isOnDisplay() {
    return true;
  }
}

class CircleDrawer with _CanvasDrawerObjectBase
{
  double size = 0.0;
  
  @override
  void paint(Canvas canvas, Size size) {
    
  }
  
  @override
  bool isOnDisplay() {
    return true;
  }
}

class TriDrawer with _CanvasDrawerObjectBase
{
  double height = 0.0;
  double size = 0.0;
  
  @override
  void paint(Canvas canvas, Size size) {
    
  }
  
  @override
  bool isOnDisplay() {
    return true;
  }
}

class CanvasDrawer extends CustomPainter
{
  @override
  void paint(Canvas canvas, Size size) {
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
    
  }
}