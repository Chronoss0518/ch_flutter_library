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
    _nextScene = startScene;
  }

  SceneManagerState state = SceneManagerState();
  //Values//
  AppBar? _appBar = null;
  BaseScene? _scene = null;
  BaseScene? _nextScene = null;
  SendBeforeSceneData? _sendData = null;
  BottomNavigationBar? _bottomNavigationBar = null;

  late Timer _timer;
  int _fps = 60;
  bool _isInitFlg = false;
  //OverrideFunction//
  @override
  State<SceneManager> createState() => state;
}

class SceneManagerState extends State<SceneManager> {
  //Initialize Release//
  void _init() {
    if (widget._isInitFlg) return;
    _timerStart();
    _changeScene();
    widget._isInitFlg = true;
  }

  //SetFunctions//
  void _setAppBar(AppBar? appBar) {
    widget._appBar = appBar;
  }

  void _setBottomNavigationBar(BottomNavigationBar? bottomNavigationBar) {
    widget._bottomNavigationBar = bottomNavigationBar;
  }

  void _setScene(BaseScene scene) {
    if (scene._state != null) return;
    widget._nextScene = scene;
  }

  void _setFps(int fps) {
    if (fps <= 0 || fps >= 1000) return;
    widget._fps = fps;
    widget._timer.cancel();
    _timerStart();
  }

  void _setSendData(SendBeforeSceneData sendData) {
    widget._sendData = sendData;
  }

//ClearFunctions//

  void _clearAppBar() {
    widget._appBar = null;
  }

  void _clearBottomNavigationBar() {
    widget._bottomNavigationBar = null;
  }

//OtherFunctions//

  void _repaint(void Function() func) {
    if (!widget._isInitFlg) return;
    setState(func);
  }

  void _changeScene() {
    if (widget._nextScene == null) return;
    BaseScene next = widget._nextScene!;
    if (next._state != null) {
      widget._nextScene = null;
      return;
    }
    widget._scene?.release();
    widget._scene?._state = null;

    widget._scene = next;
    widget._scene?._state = this;
    widget._scene?.init(sendData: widget._sendData);

    widget._nextScene = null;
    widget._sendData = null;
  }

  void _timerStart() {
    widget._timer = Timer.periodic(
        Duration(milliseconds: (1000 / widget._fps).toInt()), (timer) {
      widget._scene?.update();
      widget._scene?.move();

      _changeScene();
    });
  }

  //OverrideFunction//
  @override
  Widget build(BuildContext context) {
    _init();
    widget._scene?.drawBegin(context);
    Widget body = widget._scene ?? Container();
    return Scaffold(
      appBar: widget._appBar,
      body: body,
      bottomNavigationBar: widget._bottomNavigationBar,
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (!widget._isInitFlg) return;
    widget._scene = null;
    widget._isInitFlg = false;
    widget._timer.cancel();
  }
}
