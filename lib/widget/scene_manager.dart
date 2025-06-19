import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/*
Sceneを跨ぐ際に利用する保持したい情報をも損するためのクラス
*/
abstract class SaveData {}

/*
このクラスはSceneManagerが管理します。
このクラスは次のメソッドをoverrideして利用します。
- init()initState、またはpopにより戻ってきた際に走ります
- update()1フレーム毎に走ります。setFpsにより途中でfps値を変更できます
- move()1フレーム毎に走ります。updateの次に走るメソッドです
- drawBegin(BuildContext context)buildが走るごとにはじめに走ります。
- release()setSceneを行いこのSceneを破棄するとき、またはアプリケーションが終わる際に走ります
*/
abstract class BaseScene {
  @mustCallSuper
  @protected
  void init({SaveData? sendData}) {}

  void Function()? update;

  void Function()? move;

  void Function(BuildContext context)? drawBegin;

  @mustCallSuper
  @protected
  void release() {}

  @protected
  Widget build(BuildContext context);

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

  void setSendData(SaveData sendData) {
    _state?._setSendData(sendData);
  }

  void setSaveData(SaveData saveData) {
    _state?._setSaveData(saveData);
  }

  void setState(void Function() func)
  {
    _state?._setState(func);
  }


//GetFunctions//

  type? getSaveData<type extends SaveData>() {
    return _state?._getSaveData<type>();
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

  _SceneManagerState? _state;
  BuildContext? get context => _state?.context;
}

class SceneManager extends StatefulWidget {
  //Constructor Destructor//
  SceneManager(BaseScene startScene, {super.key}) {
    _state._nextScene = startScene;
  }

  _SceneManagerState _state = _SceneManagerState();
  //OverrideFunction//
  @override
  State<SceneManager> createState() => _state;
}

class _SceneManagerState extends State<SceneManager> {
  //Initialize Release//
  void _init() {
    if (_isInitFlg) return;
    _timerStart();
    _changeScene();
    _isInitFlg = true;
  }

  //SetFunctions//
  void _setAppBar(AppBar? appBar) {
    setState((){_appBar = appBar;});
  }

  void _setBottomNavigationBar(BottomNavigationBar? bottomNavigationBar) {
    setState((){_bottomNavigationBar = bottomNavigationBar;});
  }

  void _setScene(BaseScene scene) {
    if (scene._state != null) return;
    _nextScene = scene;
  }

  void _setFps(int fps) {
    if (fps <= 0 || fps >= 1000) return;
    _fps = fps;
    _timerStart();
  }

  void _setSendData(SaveData sendData) {
    _sendData = sendData;
  }

  void _setSaveData(SaveData saveData) {
    _saveData = saveData;
  }
  
  void _setState(void Function() func)
  {
    setState(func);
  }

//GetFunctions//

  type? _getSaveData<type extends SaveData>() {
    return _saveData as type?;
  }

//ClearFunctions//

  void _clearAppBar() {
    setState((){_appBar = null;});
  }

  void _clearBottomNavigationBar() {
    setState((){_bottomNavigationBar = null;});
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
    setState((){
    _scene?.release();
    _scene?._state = null;

    _scene = next;
    _scene?._state = this;
    _scene?.init(sendData: _sendData);

    _nextScene = null;
    _sendData = null;
    });
  }

  void _timerStart() {
    if( _scene?.update == null &&
    _scene?.move == null){
      _timeStop();
      return;
    }
    if (_fps <= 0 || _fps >= 1000) return;
    
    _timer = Timer.periodic(
        Duration(milliseconds: (1000 / _fps).toInt()), (timer) {
      if( _scene?.update != null)_scene?.update!();
      if( _scene?.move != null)_scene?.move!();
    });
  }

  //OverrideFunction//
  @override
  Widget build(BuildContext context) {
    _init();
    if(_scene?.drawBegin != null)_scene?.drawBegin!(context);
    return Scaffold(
      appBar: _appBar,
      body: _scene?.build(context) ?? Container(),
      bottomNavigationBar: _bottomNavigationBar,
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (!_isInitFlg) return;
    _scene = null;
    _isInitFlg = false;
    _timeStop();
  }

  void _timeStop()
  {
    if(_timer == null)return;
    _timer?.cancel();
    _timer = null;
  }

  //Values//
  Timer? _timer;
  int _fps = 60;
  bool _isInitFlg = false;

  AppBar? _appBar;
  BaseScene? _scene;
  BaseScene? _nextScene;
  SaveData? _sendData;
  SaveData? _saveData;
  BottomNavigationBar? _bottomNavigationBar;

}
