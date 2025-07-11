import 'dart:math' as math;

class _VectorBase {
  _VectorBase(int array) {
    _val.length = array;
    setFromValue(0);
  }

  static _VectorBase _fromValue(List<double> val) {
    final res = _VectorBase(val.length);
    res.setFromArray(val);
    return res;
  }

  void set(_VectorBase vec) {
    if (this == vec) return;

    for (int i = 0; i < _getMinArray(this, vec); i++) {
      _val[i] = vec._val[i];
    }
  }

  void setFromValue(double val) {
    for (int i = 0; i < getArray(); i++) {
      _val[i] = val;
    }
  }

  void setFromArray(List<double> val) {
    if (val == _val) return;

    final tmp = _VectorBase(val.length);

    for (int i = 0; i < _getMinArray(this, tmp); i++) {
      _val[i] = val[i];
    }
  }

  void add(_VectorBase vec) {
    if (this == vec) return;

    for (int i = 0; i < _getMinArray(this, vec); i++) {
      _val[i] += vec._val[i];
    }
  }

  void addFromValue(double val) {
    for (int i = 0; i < getArray(); i++) {
      _val[i] += val;
    }
  }

  void sub(_VectorBase vec) {
    for (int i = 0; i < _getMinArray(this, vec); i++) {
      _val[i] -= vec._val[i];
    }
  }

  void subFromValue(double val) {
    for (int i = 0; i < getArray(); i++) {
      _val[i] -= val;
    }
  }

  void mul(_VectorBase vec) {
    for (int i = 0; i < _getMinArray(this, vec); i++) {
      _val[i] *= vec._val[i];
    }
  }

  void mulFromValue(double val) {
    for (int i = 0; i < getArray(); i++) {
      _val[i] *= val;
    }
  }

  void div(_VectorBase vec) {
    for (int i = 0; i < _getMinArray(this, vec); i++) {
      _val[i] /= (vec._val[i] != 0.0 ? vec._val[i] : 1.0);
    }
  }

  void divFromValue(double val) {
    for (int i = 0; i < getArray(); i++) {
      _val[i] /= (val != 0.0 ? val : 1.0);
    }
  }

  void setLen(double _len) {
    if (getLen() == 0.0) return;

    normalize();

    double tmp = _len * _len;

    double add = 0.0;

    for (int i = 0; i < 2; i++) {
      add += _val[i] * _val[i];
    }

    tmp = tmp / add;

    mulFromValue(tmp);
  }

  int getArray() {
    return _val.length;
  }

  //ベクトルの要素の大きさを得る//
  double getElementsLen() {
    double out = 0.0;
    for (int i = 0; i < _val.length; i++) {
      out += _val[i] >= 0.0 ? _val[i] : -_val[i];
    }

    return out;
  }

  //ベクトルの大きさを得る//
  double getLen() {
    double len = 0.0;

    for (int i = 0; i < _val.length; i++) {
      len += _val[i] * _val[i];
    }

    return math.sqrt(len);
  }

  double getCos(_VectorBase vec) {
    _VectorBase tmp1 = this, tmp2 = vec;

    double len1 = tmp1.getLen();
    double len2 = tmp2.getLen();

    if (len1 <= 0.0 || len2 <= 0.0) return 0.0;

    double testVal = 1.0;

    for (int i = 0; i < _val.length; i++) {
      tmp1._val[i] = len1 == testVal ? tmp1._val[i] : tmp1._val[i] / len1;
      tmp2._val[i] = len2 == testVal ? tmp2._val[i] : tmp2._val[i] / len1;
    }

    return tmp1.getDot(tmp2);
  }

  double getRadian(_VectorBase vec) {
    double tmp = getCos(vec);

    return math.acos(tmp);
  }

  double getDot(_VectorBase vec) {
    double tmpLen = 0.0;

    for (int i = 0; i < _val.length; i++) {
      tmpLen += _val[i] * vec._val[i];
    }

    return tmpLen;
  }

  double getVal(int num) {
    return _val[num];
  }

  static List<double> _getCross(List<double> vec1, List<double> vec2) {
    final v1 = _VectorBase._fromValue(vec1);
    final v2 = _VectorBase._fromValue(vec2);

    final res = _VectorBase(0);

    final arraySize = _getMinArray(v1, v2);

    for (int i = 0; i < arraySize; i++) {
      res._val.add((vec1[(i + 1) % arraySize] * vec2[(i + 2) % arraySize]) -
          (vec1[(i + 2) % arraySize] * vec2[(i + 1) % arraySize]));
    }

    res.normalize();

    return res._val;
  }

  static List<double> _getLerp(
      List<double> start, List<double> end, double pow) {
    final res = _VectorBase(0);
    if (start.length != end.length) return res._val;

    final tmpStart = _VectorBase._fromValue(start);
    final tmpend = _VectorBase._fromValue(end);
    if (pow <= 0.0) return tmpStart._val;
    if (pow >= 1.0) return tmpend._val;

    tmpStart.mulFromValue(1.0 - pow);
    tmpend.mulFromValue(pow);

    res.add(tmpStart);
    res.add(tmpend);

    return res._val;
  }

  static List<double> _getSLerp(
      List<double> start, List<double> end, double pow) {
    final res = _VectorBase(0);
    if (start.length != end.length) return res._val;

    if (pow <= 0.0) return start;
    if (pow >= 1.0) return end;
    final tmpStart = _VectorBase._fromValue(start);
    final tmpend = _VectorBase._fromValue(end);

    tmpStart.mulFromValue(1.0 - pow);
    tmpend.mulFromValue(pow);

    double rad = tmpStart.getDot(tmpend);
    rad = math.acos(rad);
    if (rad == 0.0) return start;

    double baseSin = math.sin(rad);

    if (baseSin == 0.0) return start;

    tmpStart.mulFromValue(math.sin((1.0 - pow) * rad) / baseSin);
    tmpend.mulFromValue(math.sin(pow * rad) / baseSin);
    res.add(tmpStart);
    res.add(tmpend);

    return res._val;
  }

  void abs() {
    for (int i = 0; i < getArray(); i++) {
      _val[i] = _val[i] > 0 ? _val[i] : -_val[i];
    }
  }

  void identity() {
    for (int i = 0; i < getArray(); i++) {
      _val[i] = (i % 4) + 1 != 4 ? 0.0 : 1.0;
    }
  }

  //ベクトルの長さを1にする//
  bool normalize() {
    double len = getLen();

    if (len == 1.0) return true;
    if (len == 0.0) return false;

    divFromValue(len);

    return true;
  }

  //ベクトルの要素の合計を1にする//
  bool elementsNormalize() {
    double len = getElementsLen();

    if (len == 1.0) return true;
    if (len == 0.0) return false;

    divFromValue(len);

    return true;
  }

  static int _getMinArray(_VectorBase vec1, _VectorBase vec2) {
    return vec1.getArray() < vec2.getArray()
        ? vec1.getArray()
        : vec2.getArray();
  }

  final List<double> _val = <double>[];
}

class Vector2 extends _VectorBase {
  Vector2() : super(2);

  static Vector2 fromPos(double x, double y) {
    return _fromValue(x, y);
  }

  static Vector2 fromSize(double w, double h) {
    return _fromValue(w, h);
  }
  
  static Vector2 getCross(Vector2 vec1, Vector2 vec2) {
	final res = Vector2();
	res.setFromArray(_VectorBase._getCross(vec1._val,vec2._val));
	return res;
  }

  static Vector2  getLerp(
      Vector2 start, Vector2 end, double pow) {
	final res = Vector2();
	res.setFromArray(_VectorBase._getLerp(start._val,end._val,pow));
	return res;
  }

  static Vector2  getSLerp(
      Vector2 start, Vector2 end, double pow) {
	final res = Vector2();
	res.setFromArray(_VectorBase._getSLerp(start._val,end._val,pow));
	return res;
  }

  void cross(Vector2 vec1, Vector2 vec2) {
	setFromArray(_VectorBase._getCross(vec1._val,vec2._val));
  }

  void lerp(
      Vector2 start, Vector2 end, double pow) {
	setFromArray(_VectorBase._getLerp(start._val,end._val,pow));
  }

  void sLerp(
      Vector2 start, Vector2 end, double pow) {
	setFromArray(_VectorBase._getSLerp(start._val,end._val,pow));
  }


  double get x => _val[0];
  double get y => _val[1];

  set x(double val) {
    _val[0] = val;
  }

  set y(double val) {
    _val[1] = val;
  }

  double get w => _val[0];
  double get h => _val[1];

  set w(double val) {
    _val[0] = val;
  }

  set h(double val) {
    _val[1] = val;
  }

  static Vector2 _fromValue(double val1, double val2) {
    final res = Vector2();
    res._val[0] = val1;
    res._val[1] = val2;
    return res;
  }
}
