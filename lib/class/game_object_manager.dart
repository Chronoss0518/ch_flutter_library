import 'package:flutter/material.dart';

final String _rootName = "__root__game__object__${DateTime.now().toString()}";

mixin GameObjectComponent {

  @protected
  void init() {}

  @protected
  void release() {}

  @protected
  void update() {}

  @protected
  void move() {}

  @protected
  void drawBegin(BuildContext context) {}

  void destroy(){
    var val = _haveObject?._componentList.indexOf(this) ?? -1;
    if(val < 0)return;
    release();
    _haveObject?._childList.removeAt(val);
  }

  GameObject? get looker => _haveObject;
  GameObject? _haveObject;
}

final class GameObject {

  GameObject._internal();

  String get name => _objectName;
  String get tagName => _manager != null ? _manager!._tagMap[_tagNo]! : "";

  void _update() {
    if (!_isEnableFlg) return;

    for (var com in _componentList) {
      com.update();
    }
    for (var child in _childList) {
      child._update();
    }
  }

  void _move() {
    if (!_isEnableFlg) return;

    for (var com in _componentList) {
      com.move();
    }
    for (var child in _childList) {
      child._move();
    }
  }

  void _drawBegin(BuildContext context) {
    if (!_isEnableFlg) return;

    for (var com in _componentList) {
      com.drawBegin(context);
    }
    for (var child in _childList) {
      child._drawBegin(context);
    }
  }

  //Set Functions//

  void setObjectName(String objectName) {
    _objectName = objectName;
  }

  void setTagNo(int tagNo) {
    if (_manager == null) return;
    if (!_manager!._tagMap.containsKey(tagNo)) return;
    _tagNo = tagNo;
  }

  void setTagName(String tagName) {
    if (_manager == null) return;
    if (!_manager!._tagMap.containsValue(tagName)) return;
    for (var no in _manager!._tagMap.keys) {
      if (_manager!._tagMap[no] != tagName) continue;
      _tagNo = no;
      break;
    }
  }

  void setEnableFlg(bool enableFlg) {
    _isEnableFlg = enableFlg;
  }

  //Get Functions//
  GameObject? getParent(){
    return _parent?._objectName == _rootName ? null : _parent!;
  }

  //Add Functions//

  void addComponent(GameObjectComponent component) {
    if (component._haveObject != null) return;
    component._haveObject = this;
    _componentList.add(component);
  }

  Type addComponentFromType<Type extends GameObjectComponent>(Type Function() func)
  {
    var component = func();
    component._haveObject = this;
    _componentList.add(component);
    return component;
  }

  void addChild(GameObject child) {
    if (child._parent == this) return;
    child._parent?._childList.remove(child);
    child._parent = this;
    child._manager = _manager;
    _childList.add(child);
  }

  //Find Functions//
  GameObject? findFromName(String objectName) {
    if (_objectName == objectName) return this;
    GameObject? res;
    for (var child in _childList) {
      if (res != null) break;
      res = child.findFromName(objectName);
    }
    return res;
  }

  List<GameObject> findAllFromName(String objectName) {
    var res = <GameObject>[];
    if (_objectName == objectName) res.add(this);
    for (var child in _childList) {
      res = child._findAllFromName(res, objectName);
    }
    return res;
  }

  List<GameObject> _findAllFromName(List<GameObject> list, String objectName) {
    var res = list;
    if (_objectName == objectName) res.add(this);
    for (var child in _childList) {
      res.addAll(child._findAllFromName(res, objectName));
    }
    return res;
  }

  GameObject? findFromTagNo(int tag) {
    if (_manager == null) return null;
    if (_tagNo == tag) return this;
    GameObject? res;
    for (var child in _childList) {
      if (res != null) break;
      res = child.findFromTagNo(tag);
    }
    return res;
  }

  List<GameObject> findAllFromTagNo(int tag) {
    var res = <GameObject>[];
    if (_manager == null) return res;
    if (_tagNo == tag) res.add(this);
    for (var child in _childList) {
      res = child._findAllFromTagNo(res, tag);
    }
    return res;
  }

  List<GameObject> _findAllFromTagNo(List<GameObject> list, int tag) {
    var res = list;
    if (_manager == null) return res;
    if (_tagNo == tag) res.add(this);
    for (var child in _childList) {
      res.addAll(child._findAllFromTagNo(res, tag));
    }
    return res;
  }

  GameObject? findFromTagName(String tag) {
    if (_manager == null) return null;
    if (_manager!._tagMap[_tagNo] == tag) return this;
    GameObject? res;
    for (var child in _childList) {
      if (res != null) break;
      res = child.findFromTagName(tag);
    }
    return res;
  }

  List<GameObject> findAllFromTagName(String tag) {
    var res = <GameObject>[];
    if (_manager == null) return res;
    if (_manager!._tagMap[_tagNo] == tag) res.add(this);
    for (var child in _childList) {
      res = child._findAllFromTagName(res, tag);
    }
    return res;
  }

  List<GameObject> _findAllFromTagName(List<GameObject> list, String tag) {
    var res = list;
    if (_manager == null) return res;
    if (_manager!._tagMap[_tagNo] == tag) res.add(this);
    for (var child in _childList) {
      res.addAll(child._findAllFromTagName(res, tag));
    }
    return res;
  }

  //Other Functions//

  void destroy()
  {
    for(int i = 0;i < _childList.length;i++)
    {
      _childList[i].destroy();
    }
    _childList.clear();
    for(int i = 0;i < _componentList.length;i++)
    {
      _componentList[i].destroy();
    }
    _componentList.clear();

    var val = _parent?._childList.indexOf(this) ?? -1;
    if(val < 0)return;
    _parent?._childList.removeAt(val);

  }

  String _objectName = "";
  int _tagNo = -1;
  bool _isEnableFlg = true;
  final _componentList = <GameObjectComponent>[];

  GameObject? _parent;
  final _childList = <GameObject>[];
  GameObjectManager? _manager;
}

class GameObjectManager {

  factory GameObjectManager(){
    var res = GameObjectManager._internal();
    res._rootObject._manager = res;
    res._rootObject._objectName = _rootName;
    return res;
  }

  void update()
  {
    for(int i =0 ;i<
    _rootObject._childList.length;i++){
      _rootObject._childList[i]._update();
    }
  }

  void move()
  {
    for(int i =0 ;i<
    _rootObject._childList.length;i++){
      _rootObject._childList[i]._move();
    }
  }

  void drawBegin(BuildContext context)
  {
    for(int i =0 ;i<
    _rootObject._childList.length;i++){
      _rootObject._childList[i]._drawBegin(context);
    }
  }

  GameObject createObject(){
    var obj = GameObject._internal();
    _rootObject.addChild(obj);
    obj._manager = this;
    return obj;
  }

  GameObjectManager._internal();

  final _rootObject = GameObject._internal();
  final _tagMap = <int, String>{};
}
