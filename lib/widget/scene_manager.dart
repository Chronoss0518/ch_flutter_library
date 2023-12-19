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

  @mustCallSuper
  @protected
  void release() {}

  //SetFunctions//
  void setAppBar(AppBar? appBar) {
    _state?.setAppBar(appBar);
  }

  void setBottomNavigationBar(BottomNavigationBar? bottomNavigationBar) {
    _state?.setBottomNavigationBar(bottomNavigationBar);
  }

  void setFps(int fps) {
    _state?.setFps(fps);
  }

  //ChangeScene//

  void changeScene(BaseScene scene) {
    _state?.setScene(scene);
  }

//ClearFunctions//

  void clearAppBar() {
    _state?.clearAppBar();
  }

  void clearBottomNavigationBar() {
    _state?.clearBottomNavigationBar();
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
  //SetFunctions//
  void setAppBar(AppBar? appBar) {
    _appBar = appBar;
    if (!_isInitFlg) return;
    setState(() {});
  }

  void setBottomNavigationBar(BottomNavigationBar? bottomNavigationBar) {
    _bottomNavigationBar = bottomNavigationBar;
    if (!_isInitFlg) return;
    setState(() {});
  }

  void setScene(BaseScene scene) {
    if (scene._state != null) return;
    _scene?.release();
    _scene?._state = null;

    _scene = scene;
    _scene?._state = this;
    scene.init();

    if (!_isInitFlg) return;
    setState(() {});
  }

  void setFps(int fps) {
    if (fps <= 0 || fps >= 1000) return;
    _fps = fps;
    _timer.cancel();
    _timerStart();
  }

//ClearFunctions//

  void clearAppBar() {
    _appBar = null;
    if (!_isInitFlg) return;
    setState(() {});
  }

  void clearBottomNavigationBar() {
    _bottomNavigationBar = null;
    if (!_isInitFlg) return;
    setState(() {});
  }

//PrivateFunctions//

  void _timerStart() {
    _timer =
        Timer.periodic(Duration(milliseconds: (1000 / _fps).toInt()), (timer) {
      _scene?.update();
    });
  }

  //OverrideFunction//

  @override
  void initState() {
    super.initState();
    _timerStart();
    setScene(widget._startScene!);
    widget._startScene = null;
    _isInitFlg = true;
  }

  @override
  Widget build(BuildContext context) {
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
  BottomNavigationBar? _bottomNavigationBar = null;

  late Timer _timer;
  int _fps = 60;
  bool _isInitFlg = false;
}
