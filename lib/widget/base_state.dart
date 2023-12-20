import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/*
このクラスはStateの代わりに利用します
このクラスは次のメソッドをoverrideして利用します。
- init()initState、またはpopにより戻ってきた際に走ります
- update()1フレーム毎に走ります。setFpsにより途中でfps値を変更できます
- release()このStatefulWidgetが破棄されたとき(disposeが走る時)に走ります
- changeEvemt()
*/
abstract class BaseState<T extends StatefulWidget> extends State<T> {
  @protected
  void init() {}

  @protected
  void update() {}

  @protected
  void move() {}

  @mustCallSuper
  @protected
  void release() {
    _timer.cancel();
  }

  @protected
  void changeEvent() {}

  @protected
  void returnEvent() {}

  @mustCallSuper
  @protected
  @override
  void initState() {
    super.initState();
    init();
    _timerStart();
  }

  @mustCallSuper
  @protected
  @override
  void dispose() {
    release();
    super.dispose();
  }

  void setFps(int fps) {
    if (fps <= 0 || fps >= 1000) return;

    _timer.cancel();
    _timerStart();
  }

  void nextScene(StatefulWidget _nextScene, String sceneName) {
    changeEvent();
    release();

    Navigator.of(context)
        .push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return _nextScene;
        },
        settings: RouteSettings(name: sceneName),
      ),
    )
        .then((res) {
      initState();
      returnEvent();
    });
  }

  void backScene() {
    changeEvent();
    release();
    Navigator.of(context).pop();
  }

  void backSceneToFirst() {
    Navigator.of(context).popUntil((route) {
      return route.isFirst;
    });
  }

  void backSceneToStateName(String sceneName) {
    Navigator.of(context).popUntil((route) {
      return route.settings.name == sceneName;
    });
  }

  void _timerStart() {
    _timer =
        Timer.periodic(Duration(milliseconds: (1000 / _fps).toInt()), (timer) {
      update();
      move();
    });
  }

  late Timer _timer;

  int _fps = 60;
}
