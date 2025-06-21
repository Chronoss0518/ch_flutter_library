import 'package:ch_flutter_library/widget/object_function_base.dart';
import 'package:flutter/material.dart';

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
abstract class BaseScene with ObjectFunctionBase {
  @mustCallSuper
  @protected
  void init({SaveData? sendData}) {}

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

  void setState(void Function() func){
    _state?._repaint(func);
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

  void timerStart(){
    _state?._timerStart();
  }

  void timerStop(){
    _state?._timerStart();
  }

  _SceneManagerState? _state;
  BuildContext? get context => _state?.context;
}

class SceneManager extends StatefulWidget {
  //Constructor Destructor//
  SceneManager(BaseScene startScene, {super.key}) {
    _state._nextScene = startScene;
  }

  final _SceneManagerState _state = _SceneManagerState();
  //OverrideFunction//
  @override
  State<SceneManager> createState() => _state;
}

class _SceneManagerState extends State<SceneManager> with ObjectFunctionRunnerBase {
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
    if(_scene != null)setFps(fps,_scene!);
  }

  void _setSendData(SaveData sendData) {
    _sendData = sendData;
  }

  void _setSaveData(SaveData saveData) {
    _saveData = saveData;
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
    if(_scene != null)timerStart(_scene!);
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
    _timerStop();
  }

  void _timerStop(){
    timerStop();
  }

  //Values//
  bool _isInitFlg = false;

  AppBar? _appBar;
  BaseScene? _scene;
  BaseScene? _nextScene;
  SaveData? _sendData;
  SaveData? _saveData;
  BottomNavigationBar? _bottomNavigationBar;

}
