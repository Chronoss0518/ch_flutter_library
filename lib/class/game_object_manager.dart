import 'package:flutter/material.dart';

abstract class GameObjectComponent {
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

  GameObject? get looker => _haveObject;
  GameObject? _haveObject = null;
}

final class GameObject {
  //Base Functions//
  void _init() {
    if (!_isEnableFlg) return;
    if (_isInitFlg) return;

    for (var com in _componentList) {
      com.init();
    }
    for (var child in _childList) {
      child._init();
    }
    _isInitFlg = true;
  }

  void _release() {
    if (!_isEnableFlg) return;
    if (!_isInitFlg) return;

    for (var com in _componentList) {
      com.release();
    }
    for (var child in _childList) {
      child._release();
    }
  }

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
  String getObjectName() {
    return _objectName;
  }

  int getTagNo() {
    if (_manager == null) return -1;
    if (_manager!._tagMap.containsKey(_tagNo)) return -1;
    return _tagNo;
  }

  String getTagName() {
    if (_manager == null) return "";
    if (_manager!._tagMap.containsKey(_tagNo)) return "";
    return _manager!._tagMap[_tagNo]!;
  }

  //Add Functions//

  void addComponent(GameObjectComponent component) {
    if (component._haveObject != null) return;
    component._haveObject = this;
    _componentList.add(component);
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
    GameObject? res = null;
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
    GameObject? res = null;
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
    GameObject? res = null;
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

  String _objectName = "";
  int _tagNo = -1;
  bool _isEnableFlg = true;
  bool _isInitFlg = false;
  var _componentList = <GameObjectComponent>[];

  GameObject? _parent = null;
  var _childList = <GameObject>[];
  GameObjectManager? _manager = null;
}

class GameObjectManager {
  GameObject rootGameObject = GameObject();

  var _tagMap = <int, String>{};
}
