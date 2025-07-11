import 'package:ch_flutter_library/widget/custom_scrilling_behevior.dart';
import 'package:flutter/material.dart';

class DragScrollingGridView extends GridView
{
  DragScrollingGridView({
    super.key,
    super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    super.physics,
    super.shrinkWrap,
    super.padding,
    required super.gridDelegate,
    super.addAutomaticKeepAlives = true,
    super.addRepaintBoundaries = true,
    super.addSemanticIndexes = true,
    super.cacheExtent,
    super.children = const <Widget>[],
    super.semanticChildCount,
    super.dragStartBehavior,
    super.clipBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.hitTestBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollConfiguration(
      child: super.build(context));
  }
}