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

  @mustCallSuper
  @protected
  void release() {}

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
  }

  @mustCallSuper
  @protected
  @override
  void dispose() {
    release();
    super.dispose();
  }

  void nextScene(StatefulWidget nextScene, String sceneName,{BuildContext? inContext}) {
    changeEvent();
    release();
    BuildContext tmpContext = inContext ?? context;
    Navigator.of(tmpContext)
        .push(
      MaterialPageRoute<void>(
        builder: (BuildContext tmpContext) {
          return nextScene;
        },
        settings: RouteSettings(name: sceneName),
      ),
    )
        .then((res) {
      initState();
      returnEvent();
    });
  }

  void backScene({BuildContext? inContext}) {
    changeEvent();
    release();
    BuildContext tmpContext = inContext ?? context;
    Navigator.of(tmpContext).pop();
  }

  void backSceneToFirst({BuildContext? inContext}) {
    BuildContext tmpContext = inContext ?? context;
    Navigator.of(tmpContext).popUntil((route) {
      return route.isFirst;
    });
  }

  void backSceneToStateName(String sceneName,{BuildContext? inContext}) {
    BuildContext tmpContext = inContext ?? context;
    Navigator.of(tmpContext).popUntil((route) {
      return route.settings.name == sceneName;
    });
  }
}

/*
このクラスはStateの代わりに利用します
このクラスは次のメソッドをoverrideして利用します。
- init()initState、またはpopにより戻ってきた際に走ります
- update()1フレーム毎に走ります。setFpsにより途中でfps値を変更できます
- release()このStatefulWidgetが破棄されたとき(disposeが走る時)に走ります
- changeEvemt()
*/
abstract class BaseStateEx<T extends StatefulWidget> extends BaseState<T> {
  
  void Function()? update;

  void Function()? move;

  @mustCallSuper
  @protected
  @override
  void release() {
    super.release();
    _timer.cancel();
  }

  @mustCallSuper
  @protected
  @override
  void initState() {
    super.initState();
    init();
    _timerStart();
  }

  void setFps(int fps) {
    if (fps <= 0 || fps >= 1000) return;
    _fps = fps;
    _timer.cancel();
    _timerStart();
  }

  void _timerStart() {
    
    if (_fps <= 0 || _fps >= 1000) return;
    if( update == null &&
    move == null){return;}
    
    _timer =
        Timer.periodic(Duration(milliseconds: (1000.0 / _fps.toDouble()).toInt()), (timer) {
      if(update != null)update!();
      if(move != null)move!();
    });
  }

  late Timer _timer;

  int _fps = 60;
}
