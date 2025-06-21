import 'dart:async';

mixin ObjectFunctionBase
{
  void Function()? update;

  void Function()? move;
}

mixin ObjectFunctionRunnerBase
{
  void setFps(int fps,ObjectFunctionBase obj) {
    if (fps <= 0 || fps >= 1000) return;
    _fps = fps;
    timerStart(obj);
  }

  void timerStart(ObjectFunctionBase obj) {
    if(!_isUseFuncs(obj)){return;}
    if (_fps <= 0 || _fps >= 1000) return;
    
    _timer = Timer.periodic(
        Duration(milliseconds: (1000 / _fps).toInt()), (timer) {
        _isRunFunc(obj.update);
        _isRunFunc(obj.move);
        if(!_isUseFuncs(obj)){timerStop();}
    });
  }

  void timerStop()
  {
    if(_timer == null)return;
    _timer?.cancel();
    _timer = null;
  }

  bool _isUseFuncs(ObjectFunctionBase scene){return scene.update != null || scene.move != null;}

  void _isRunFunc(void Function()? func){if(func != null)func();}

  Timer? _timer;
  int _fps = 60;
}