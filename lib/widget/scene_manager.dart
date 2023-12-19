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
  //Constructor Destructor//
  SceneManagerState() {
    _timerStart();
  }

  //SetFunctions//
  void setAppBar(AppBar? appBar) {
    setState(() {
      _appBar = appBar;
    });
  }

  void setBottomNavigationBar(BottomNavigationBar? bottomNavigationBar) {
    setState(() {
      _bottomNavigationBar = bottomNavigationBar;
    });
  }

  void setScene(BaseScene scene) {
    if (scene._state != null) return;
    setState(() {
      _scene?.release();
      _scene?._state = null;

      scene.init();
      _scene = scene;
      _scene?._state = this;
    });
  }

  void setFps(int fps) {
    if (fps <= 0 || fps >= 1000) return;
    _fps = fps;
    _timer.cancel();
    _timerStart();
  }

//ClearFunctions//

  void clearAppBar() {
    setState(() {
      _appBar = null;
    });
  }

  void clearBottomNavigationBar() {
    setState(() {
      _bottomNavigationBar = null;
    });
  }

//PrivateFunctions//

  void _timerStart() {
    _timer =
        Timer.periodic(Duration(milliseconds: (1000 / _fps).toInt()), (timer) {
      _scene?.update();
    });
  }

  //Values//
  AppBar? _appBar = null;
  BaseScene? _scene = null;
  BottomNavigationBar? _bottomNavigationBar = null;

  late Timer _timer;
  int _fps = 60;

  //OverrideFunction//

  @override
  void initState() {
    super.initState();
    setScene(widget._startScene!);
    widget._startScene = null;
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
}
