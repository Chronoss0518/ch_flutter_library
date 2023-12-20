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
abstract class BaseScene extends StatelessWidget {
  @mustCallSuper
  @protected
  void init() {}

  @protected
  void update() {}

  @protected
  void move() {}

  @protected
  void drawBegin(BuildContext context) {}

  @mustCallSuper
  @protected
  void release() {}

  //SetFunctions//
  void setAppBar(AppBar? appBar) {
    _state?._setAppBar(appBar);
  }

  void setBottomNavigationBar(BottomNavigationBar? bottomNavigationBar) {
    _state?._setBottomNavigationBar(bottomNavigationBar);
  }

  void setFps(int fps) {
    _state?._setFps(fps);
  }

  //ChangeScene//

  void changeScene(BaseScene scene) {
    _state?._setScene(scene);
  }

//ClearFunctions//

  void clearAppBar() {
    _state?._clearAppBar();
  }

  void clearBottomNavigationBar() {
    _state?._clearBottomNavigationBar();
  }

//OtherFunctions//

  void repaint(void Function() func) {
    _state?._repaint(func);
  }

  SceneManagerState? _state;
  BuildContext? get context => _state?.context;
}

class SceneManager extends StatefulWidget {
  //Constructor Destructor//
  SceneManager(BaseScene startScene, {super.key}) {
    _startScene = startScene;
  }

  SceneManagerState state = SceneManagerState();
  BaseScene? _startScene = null;
  //OverrideFunction//
  @override
  State<SceneManager> createState() => state;
}

class SceneManagerState extends State<SceneManager> {
  //Initialize Release//
  void _init() {
    if (_isInitFlg) return;
    _timerStart();
    _setScene(widget._startScene!);
    widget._startScene = null;
    _isInitFlg = true;
  }

  //SetFunctions//
  void _setAppBar(AppBar? appBar) {
    _appBar = appBar;
  }

  void _setBottomNavigationBar(BottomNavigationBar? bottomNavigationBar) {
    _bottomNavigationBar = bottomNavigationBar;
  }

  void _setScene(BaseScene scene) {
    if (scene._state != null) return;
    _nextScene = scene;
  }

  void _setFps(int fps) {
    if (fps <= 0 || fps >= 1000) return;
    _fps = fps;
    _timer.cancel();
    _timerStart();
  }

//ClearFunctions//

  void _clearAppBar() {
    _appBar = null;
  }

  void _clearBottomNavigationBar() {
    _bottomNavigationBar = null;
  }

//OtherFunctions//

  void _repaint(void Function() func) {
    if (!_isInitFlg) return;
    setState(func);
  }

  void _changeScene() {
    if (_nextScene == null) return;
    BaseScene next = _nextScene!;
    if (next._state != null) {
      _nextScene = null;
      return;
    }
    _scene?.release();
    _scene?._state = null;

    _scene = next;
    _scene?._state = this;
    _scene?.init();

    _nextScene = null;
  }

  void _timerStart() {
    _timer =
        Timer.periodic(Duration(milliseconds: (1000 / _fps).toInt()), (timer) {
      _scene?.update();
      _scene?.move();

      _changeScene();
    });
  }

  //OverrideFunction//
  @override
  Widget build(BuildContext context) {
    _init();
    _scene?.drawBegin(context);
    Widget body = _scene ?? Container();
    return Scaffold(
      appBar: _appBar,
      body: body,
      bottomNavigationBar: _bottomNavigationBar,
    );
  }

  //Values//
  AppBar? _appBar = null;
  BaseScene? _scene = null;
  BaseScene? _nextScene = null;
  BottomNavigationBar? _bottomNavigationBar = null;

  late Timer _timer;
  int _fps = 60;
  bool _isInitFlg = false;
}
