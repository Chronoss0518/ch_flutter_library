import 'package:ch_flutter_library/widget/custom_scrilling_behevior.dart';
import 'package:flutter/material.dart';

class DragScrollingListView extends ListView
{
  DragScrollingListView({
    super.key,
    super.scrollDirection,
    super.reverse,
    super.controller,
    super.primary,
    super.physics,
    super.shrinkWrap,
    super.padding,
    super.itemExtent,
    super.itemExtentBuilder,
    super.prototypeItem,
    super.addAutomaticKeepAlives = true,
    super.addRepaintBoundaries = true,
    super.addSemanticIndexes = true,
    super.cacheExtent,
    super.children = const <Widget>[],
    super.semanticChildCount,
    super.dragStartBehavior,
    super.keyboardDismissBehavior,
    super.restorationId,
    super.clipBehavior,
    super.hitTestBehavior,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollConfiguration(
      child: super.build(context));
  }
}