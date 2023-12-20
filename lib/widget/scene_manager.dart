import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

abstract class SendBeforeSceneData {}

/*
このクラスはSceneManagerが管理します。
このクラスは次のメソッドをoverrideして利用します。
- init()initState、またはpopにより戻ってきた際に走ります
- update()1フレーム毎に走ります。setFpsにより途中でfps値を変更できます
- move()1フレーム毎に走ります。updateの次に走るメソッドです
- drawBegin(BuildContext context)buildが走るごとにはじめに走ります。
- release()setSceneを行いこのSceneを破棄するとき、またはアプリケーションが終わる際に走ります
*/
abstract class BaseScene extends StatelessWidget {
  @mustCallSuper
  @protected
  void init({SendBeforeSceneData? sendData}) {}

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

  void setSendData(SendBeforeSceneData sendData) {
    _state?._setSendData(sendData);
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

  void _setSendData(SendBeforeSceneData sendData) {
    _sendData = sendData;
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
    _scene?.init(sendData: _sendData);

    _nextScene = null;
    _sendData = null;
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

  @override
  void dispose() {
    super.dispose();
    if (!_isInitFlg) return;
    _scene = null;
    _isInitFlg = false;
    _timer.cancel();
  }

  //Values//
  AppBar? _appBar = null;
  BaseScene? _scene = null;
  BaseScene? _nextScene = null;
  SendBeforeSceneData? _sendData = null;
  BottomNavigationBar? _bottomNavigationBar = null;

  late Timer _timer;
  int _fps = 60;
  bool _isInitFlg = false;
}
