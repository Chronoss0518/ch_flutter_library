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
    _manager?.setAppBar(appBar);
  }

  void setBottomNavigationBar(BottomNavigationBar? bottomNavigationBar) {
    _manager?.setBottomNavigationBar(bottomNavigationBar);
  }

  void setFps(int fps) {
    _manager?.setFps(fps);
  }

  //ChangeScene//

  void changeScene(BaseScene scene) {
    _manager?.setScene(scene);
  }

//ClearFunctions//

  void clearAppBar() {
    _manager?.clearAppBar();
  }

  void clearBottomNavigationBar() {
    _manager?.clearBottomNavigationBar();
  }

  SceneManager? _manager = null;
}

class SceneManager extends StatefulWidget {
  //Constructor Destructor//
  SceneManager(BaseScene startScene, {super.key}) {
    setScene(startScene);
    _timerStart();
  }

  //SetFunctions//
  void setAppBar(AppBar? appBar) {
    _appBar = appBar;
  }

  void setBottomNavigationBar(BottomNavigationBar? bottomNavigationBar) {
    _bottomNavigationBar = bottomNavigationBar;
  }

  void setScene(BaseScene scene) {
    if (scene._manager != null) return;
    _scene?.release();
    scene.init();
    _scene = scene;
    _scene?._manager = this;
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
  }

  void clearBottomNavigationBar() {
    _bottomNavigationBar = null;
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
  State<SceneManager> createState() => SceneManagerState();
}

class SceneManagerState extends State<SceneManager> {
  @override
  Widget build(BuildContext context) {
    Widget body = widget._scene ?? Container();
    return Scaffold(
      appBar: widget._appBar,
      body: body,
      bottomNavigationBar: widget._bottomNavigationBar,
    );
  }
}
