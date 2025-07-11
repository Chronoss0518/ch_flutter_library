import 'dart:ui';

import 'package:flutter/material.dart';

class _Behavior extends MaterialScrollBehavior
{
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

class CustomScrollConfiguration extends StatelessWidget
{
  const CustomScrollConfiguration({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: _Behavior(),
      child:child);
  }
}