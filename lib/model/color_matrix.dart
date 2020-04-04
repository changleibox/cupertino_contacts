/*
 * Copyright (c) 2020 CHANGLEI. All rights reserved.
 */
import 'dart:typed_data';
import 'dart:math' as math;

import 'package:vector_math/hash.dart' as quiver;

class ColorMatrix {
  final Float64List _m5storage;

  Float64List get storage => _m5storage;

  ColorMatrix.zero() : _m5storage = Float64List(20);

  factory ColorMatrix.identity() => ColorMatrix.zero()..setIdentity();

  factory ColorMatrix.invert() => ColorMatrix.zero()..setInvert();

  factory ColorMatrix.sepia() => ColorMatrix.zero()..setSepia();

  factory ColorMatrix.greyscale() => ColorMatrix.zero()..setGreyscale();

  factory ColorMatrix.luminosity(double luminosity) => ColorMatrix.zero()..setLuminosity(luminosity);

  factory ColorMatrix.saturation(double saturation) => ColorMatrix.zero()..setSaturation(saturation);

  factory ColorMatrix.contrast(double contrast) => ColorMatrix.zero()..setContrast(contrast);

  factory ColorMatrix.threshold(double threshold) => ColorMatrix.zero()..setThreshold(threshold);

  factory ColorMatrix.copy(ColorMatrix other) => ColorMatrix.zero()..setFrom(other);

  int index(int row, int col) => (row * 5) + col;

  /// Value at [row], [col].
  double entry(int row, int col) {
    assert((row >= 0) && (row < 4));
    assert((col >= 0) && (col < 5));

    return _m5storage[index(row, col)];
  }

  void setEntry(int row, int col, double v) {
    assert((row >= 0) && (row < 4));
    assert((col >= 0) && (col < 5));

    _m5storage[index(row, col)] = v;
  }

  factory ColorMatrix(
    double arg0,
    double arg1,
    double arg2,
    double arg3,
    double arg4,
    double arg5,
    double arg6,
    double arg7,
    double arg8,
    double arg9,
    double arg10,
    double arg11,
    double arg12,
    double arg13,
    double arg14,
    double arg15,
    double arg16,
    double arg17,
    double arg18,
    double arg19,
  ) {
    return ColorMatrix.zero()
      ..setValues(
        arg0,
        arg1,
        arg2,
        arg3,
        arg4,
        arg5,
        arg6,
        arg7,
        arg8,
        arg9,
        arg10,
        arg11,
        arg12,
        arg13,
        arg14,
        arg15,
        arg16,
        arg17,
        arg18,
        arg19,
      );
  }

  factory ColorMatrix.fromList(List<double> values) {
    return ColorMatrix.zero()
      ..setValues(
        values[0],
        values[1],
        values[2],
        values[3],
        values[4],
        values[5],
        values[6],
        values[7],
        values[8],
        values[9],
        values[10],
        values[11],
        values[12],
        values[13],
        values[14],
        values[15],
        values[16],
        values[17],
        values[18],
        values[19],
      );
  }

  /// Constructs Matrix4 with given [Float64List] as [storage].
  ColorMatrix.fromFloat64List(this._m5storage);

  /// Constructs Matrix4 with a [storage] that views given [buffer] starting at
  /// [offset]. [offset] has to be multiple of [Float64List.bytesPerElement].
  ColorMatrix.fromBuffer(ByteBuffer buffer, int offset) : _m5storage = Float64List.view(buffer, offset, 20);

  /// Constructs a new mat4 from columns.
  factory ColorMatrix.columns(Vector5 arg0, Vector5 arg1, Vector5 arg2, Vector5 arg3, Vector5 arg4) =>
      ColorMatrix.zero()..setColumns(arg0, arg1, arg2, arg3, arg4);

  /// Sets the diagonal to [arg].
  void splatDiagonal(double arg) {
    _m5storage[0] = arg;
    _m5storage[6] = arg;
    _m5storage[12] = arg;
    _m5storage[18] = arg;
  }

  void setValues(
    double arg0,
    double arg1,
    double arg2,
    double arg3,
    double arg4,
    double arg5,
    double arg6,
    double arg7,
    double arg8,
    double arg9,
    double arg10,
    double arg11,
    double arg12,
    double arg13,
    double arg14,
    double arg15,
    double arg16,
    double arg17,
    double arg18,
    double arg19,
  ) {
    _m5storage[19] = arg19;
    _m5storage[18] = arg18;
    _m5storage[17] = arg17;
    _m5storage[16] = arg16;
    _m5storage[15] = arg15;
    _m5storage[14] = arg14;
    _m5storage[13] = arg13;
    _m5storage[12] = arg12;
    _m5storage[11] = arg11;
    _m5storage[10] = arg10;
    _m5storage[9] = arg9;
    _m5storage[8] = arg8;
    _m5storage[7] = arg7;
    _m5storage[6] = arg6;
    _m5storage[5] = arg5;
    _m5storage[4] = arg4;
    _m5storage[3] = arg3;
    _m5storage[2] = arg2;
    _m5storage[1] = arg1;
    _m5storage[0] = arg0;
  }

  /// Sets the entire matrix to the column values.
  void setColumns(
    Vector5 arg0,
    Vector5 arg1,
    Vector5 arg2,
    Vector5 arg3,
    Vector5 arg4,
  ) {
    _m5storage[0] = arg0._v5storage[0];
    _m5storage[1] = arg0._v5storage[1];
    _m5storage[2] = arg0._v5storage[2];
    _m5storage[3] = arg0._v5storage[3];
    _m5storage[4] = arg1._v5storage[0];
    _m5storage[5] = arg1._v5storage[1];
    _m5storage[6] = arg1._v5storage[2];
    _m5storage[7] = arg1._v5storage[3];
    _m5storage[8] = arg2._v5storage[0];
    _m5storage[9] = arg2._v5storage[1];
    _m5storage[10] = arg2._v5storage[2];
    _m5storage[11] = arg2._v5storage[3];
    _m5storage[12] = arg3._v5storage[0];
    _m5storage[13] = arg3._v5storage[1];
    _m5storage[14] = arg3._v5storage[2];
    _m5storage[15] = arg3._v5storage[3];
    _m5storage[16] = arg4._v5storage[0];
    _m5storage[17] = arg4._v5storage[1];
    _m5storage[18] = arg4._v5storage[2];
    _m5storage[19] = arg4._v5storage[3];
  }

  void setFrom(ColorMatrix arg) {
    final Float64List argStorage = arg._m5storage;
    _m5storage[19] = argStorage[19];
    _m5storage[18] = argStorage[18];
    _m5storage[17] = argStorage[17];
    _m5storage[16] = argStorage[16];
    _m5storage[15] = argStorage[15];
    _m5storage[14] = argStorage[14];
    _m5storage[13] = argStorage[13];
    _m5storage[12] = argStorage[12];
    _m5storage[11] = argStorage[11];
    _m5storage[10] = argStorage[10];
    _m5storage[9] = argStorage[9];
    _m5storage[8] = argStorage[8];
    _m5storage[7] = argStorage[7];
    _m5storage[6] = argStorage[6];
    _m5storage[5] = argStorage[5];
    _m5storage[4] = argStorage[4];
    _m5storage[3] = argStorage[3];
    _m5storage[2] = argStorage[2];
    _m5storage[1] = argStorage[1];
    _m5storage[0] = argStorage[0];
  }

  double operator [](int i) => _m5storage[i];

  void operator []=(int i, double v) {
    _m5storage[i] = v;
  }

  void setIdentity() {
    _m5storage[0] = 1.0;
    _m5storage[1] = 0.0;
    _m5storage[2] = 0.0;
    _m5storage[3] = 0.0;
    _m5storage[4] = 0.0;
    _m5storage[5] = 0.0;
    _m5storage[6] = 1.0;
    _m5storage[7] = 0.0;
    _m5storage[8] = 0.0;
    _m5storage[9] = 0.0;
    _m5storage[10] = 0.0;
    _m5storage[11] = 0.0;
    _m5storage[12] = 1.0;
    _m5storage[13] = 0.0;
    _m5storage[14] = 0.0;
    _m5storage[15] = 0.0;
    _m5storage[16] = 0.0;
    _m5storage[17] = 0.0;
    _m5storage[18] = 1.0;
    _m5storage[19] = 0.0;
  }

  void setInvert() {
    _m5storage[0] = -1.0;
    _m5storage[1] = 0.0;
    _m5storage[2] = 0.0;
    _m5storage[3] = 0.0;
    _m5storage[4] = 255.0;
    _m5storage[5] = 0.0;
    _m5storage[6] = -1.0;
    _m5storage[7] = 0.0;
    _m5storage[8] = 0.0;
    _m5storage[9] = 255.0;
    _m5storage[10] = 0.0;
    _m5storage[11] = 0.0;
    _m5storage[12] = -1.0;
    _m5storage[13] = 0.0;
    _m5storage[14] = 255.0;
    _m5storage[15] = 0.0;
    _m5storage[16] = 0.0;
    _m5storage[17] = 0.0;
    _m5storage[18] = 1.0;
    _m5storage[19] = 0.0;
  }

  void setSepia() {
    _m5storage[0] = 0.393;
    _m5storage[1] = 0.769;
    _m5storage[2] = 0.189;
    _m5storage[3] = 0.0;
    _m5storage[4] = 0;
    _m5storage[5] = 0.349;
    _m5storage[6] = 0.686;
    _m5storage[7] = 0.168;
    _m5storage[8] = 0.0;
    _m5storage[9] = 0.0;
    _m5storage[10] = 0.272;
    _m5storage[11] = 0.534;
    _m5storage[12] = 0.131;
    _m5storage[13] = 0.0;
    _m5storage[14] = 0.0;
    _m5storage[15] = 0.0;
    _m5storage[16] = 0.0;
    _m5storage[17] = 0.0;
    _m5storage[18] = 1.0;
    _m5storage[19] = 0.0;
  }

  void setGreyscale() {
    _m5storage[0] = 0.2126;
    _m5storage[1] = 0.7152;
    _m5storage[2] = 0.0722;
    _m5storage[3] = 0.0;
    _m5storage[4] = 0.0;
    _m5storage[5] = 0.2126;
    _m5storage[6] = 0.7152;
    _m5storage[7] = 0.0722;
    _m5storage[8] = 0.0;
    _m5storage[9] = 0.0;
    _m5storage[10] = 0.2126;
    _m5storage[11] = 0.7152;
    _m5storage[12] = 0.0722;
    _m5storage[13] = 0.0;
    _m5storage[14] = 0.0;
    _m5storage[15] = 0.0;
    _m5storage[16] = 0.0;
    _m5storage[17] = 0.0;
    _m5storage[18] = 1.0;
    _m5storage[19] = 0.0;
  }

  void setLuminosity(double luminosity) {
    assert(luminosity != null && luminosity.abs() <= 255);
    _m5storage[0] = 1.0;
    _m5storage[1] = 0.0;
    _m5storage[2] = 0.0;
    _m5storage[3] = 0.0;
    _m5storage[4] = luminosity;
    _m5storage[5] = 0.0;
    _m5storage[6] = 1.0;
    _m5storage[7] = 0.0;
    _m5storage[8] = 0.0;
    _m5storage[9] = luminosity;
    _m5storage[10] = 0.0;
    _m5storage[11] = 0.0;
    _m5storage[12] = 1.0;
    _m5storage[13] = 0.0;
    _m5storage[14] = luminosity;
    _m5storage[15] = 0.0;
    _m5storage[16] = 0.0;
    _m5storage[17] = 0.0;
    _m5storage[18] = 1.0;
    _m5storage[19] = 0.0;
  }

  void setSaturation(double saturation) {
    assert(saturation != null && saturation >= 0);
    _m5storage[0] = 0.2126 * (1 - saturation) + saturation;
    _m5storage[1] = 0.7152 * (1 - saturation);
    _m5storage[2] = 0.0722 * (1 - saturation);
    _m5storage[3] = 0.0;
    _m5storage[4] = 0.0;
    _m5storage[5] = 0.2126 * (1 - saturation);
    _m5storage[6] = 0.7152 * (1 - saturation) + saturation;
    _m5storage[7] = 0.0722 * (1 - saturation);
    _m5storage[8] = 0.0;
    _m5storage[9] = 0.0;
    _m5storage[10] = 0.2126 * (1 - saturation);
    _m5storage[11] = 0.7152 * (1 - saturation);
    _m5storage[12] = 0.0722 * (1 - saturation) + saturation;
    _m5storage[13] = 0.0;
    _m5storage[14] = 0.0;
    _m5storage[15] = 0.0;
    _m5storage[16] = 0.0;
    _m5storage[17] = 0.0;
    _m5storage[18] = 1.0;
    _m5storage[19] = 0.0;
  }

  void setContrast(double contrast) {
    assert(contrast != null && contrast >= 0 && contrast <= 10);
    _m5storage[0] = contrast;
    _m5storage[1] = 0.0;
    _m5storage[2] = 0.0;
    _m5storage[3] = 0.0;
    _m5storage[4] = 128 * (1 - contrast);
    _m5storage[5] = 0.0;
    _m5storage[6] = contrast;
    _m5storage[7] = 0.0;
    _m5storage[8] = 0.0;
    _m5storage[9] = 128 * (1 - contrast);
    _m5storage[10] = 0.0;
    _m5storage[11] = 0.0;
    _m5storage[12] = contrast;
    _m5storage[13] = 0.0;
    _m5storage[14] = 128 * (1 - contrast);
    _m5storage[15] = 0.0;
    _m5storage[16] = 0.0;
    _m5storage[17] = 0.0;
    _m5storage[18] = 1.0;
    _m5storage[19] = 0.0;
  }

  void setThreshold(double threshold) {
    assert(threshold != null && threshold >= 0 && threshold <= 255);
    _m5storage[0] = 0.2126 * 256;
    _m5storage[1] = 0.7152 * 256;
    _m5storage[2] = 0.0722 * 256;
    _m5storage[3] = 0.0;
    _m5storage[4] = -256 * threshold;
    _m5storage[5] = 0.2126 * 256;
    _m5storage[6] = 0.7152 * 256;
    _m5storage[7] = 0.0722 * 256;
    _m5storage[8] = 0.0;
    _m5storage[9] = -256 * threshold;
    _m5storage[10] = 0.2126 * 256;
    _m5storage[11] = 0.7152 * 256;
    _m5storage[12] = 0.0722 * 256;
    _m5storage[13] = 0.0;
    _m5storage[14] = -256 * threshold;
    _m5storage[15] = 0.0;
    _m5storage[16] = 0.0;
    _m5storage[17] = 0.0;
    _m5storage[18] = 1.0;
    _m5storage[19] = 0.0;
  }

  @override
  bool operator ==(Object other) {
    return (other is ColorMatrix) &&
        (_m5storage[0] == other._m5storage[0]) &&
        (_m5storage[1] == other._m5storage[1]) &&
        (_m5storage[2] == other._m5storage[2]) &&
        (_m5storage[3] == other._m5storage[3]) &&
        (_m5storage[4] == other._m5storage[4]) &&
        (_m5storage[5] == other._m5storage[5]) &&
        (_m5storage[6] == other._m5storage[6]) &&
        (_m5storage[7] == other._m5storage[7]) &&
        (_m5storage[8] == other._m5storage[8]) &&
        (_m5storage[9] == other._m5storage[9]) &&
        (_m5storage[10] == other._m5storage[10]) &&
        (_m5storage[11] == other._m5storage[11]) &&
        (_m5storage[12] == other._m5storage[12]) &&
        (_m5storage[13] == other._m5storage[13]) &&
        (_m5storage[14] == other._m5storage[14]) &&
        (_m5storage[15] == other._m5storage[15]) &&
        (_m5storage[16] == other._m5storage[16]) &&
        (_m5storage[17] == other._m5storage[17]) &&
        (_m5storage[18] == other._m5storage[18]) &&
        (_m5storage[19] == other._m5storage[19]);
  }

  @override
  int get hashCode => quiver.hashObjects(_m5storage);
}

class Vector5 {
  final Float64List _v5storage;

  Vector5.zero() : _v5storage = new Float64List(5);

  factory Vector5(double x, double y, double z, double w, double v) => Vector5.zero()..setValues(x, y, z, w, v);

  factory Vector5.identity() => Vector5.zero()..setIdentity();

  /// Splat [value] into all lanes of the vector.
  factory Vector5.all(double value) => new Vector5.zero()..splat(value);

  /// Copy of [other].
  factory Vector5.copy(Vector5 other) => new Vector5.zero()..setFrom(other);

  /// Constructs Vector4 with given Float64List as [storage].
  Vector5.fromFloat64List(this._v5storage);

  /// Constructs Vector4 with a [storage] that views given [buffer] starting at
  /// [offset]. [offset] has to be multiple of [Float64List.bytesPerElement].
  Vector5.fromBuffer(ByteBuffer buffer, int offset) : _v5storage = Float64List.view(buffer, offset, 5);

  /// Generate random vector in the range (0, 0, 0, 0) to (1, 1, 1, 1). You can
  /// optionally pass your own random number generator.
  factory Vector5.random([math.Random rng]) {
    rng ??= math.Random();
    return Vector5(rng.nextDouble(), rng.nextDouble(), rng.nextDouble(), rng.nextDouble(), rng.nextDouble());
  }

  List<double> get storage => _v5storage;

  /// Set the values of the vector.
  void setValues(double x, double y, double z, double w, double v) {
    _v5storage[4] = v;
    _v5storage[3] = w;
    _v5storage[2] = z;
    _v5storage[1] = y;
    _v5storage[0] = x;
  }

  /// Zero the vector.
  void setZero() {
    _v5storage[0] = 0.0;
    _v5storage[1] = 0.0;
    _v5storage[2] = 0.0;
    _v5storage[3] = 0.0;
    _v5storage[4] = 0.0;
  }

  /// Set to the identity vector.
  void setIdentity() {
    _v5storage[0] = 0.0;
    _v5storage[1] = 0.0;
    _v5storage[2] = 0.0;
    _v5storage[3] = 0.0;
    _v5storage[4] = 1.0;
  }

  /// Create a copy of [this].
  Vector5 clone() => Vector5.copy(this);

  /// Copy [this]
  Vector5 copyInto(Vector5 arg) {
    final Float64List argStorage = arg._v5storage;
    argStorage[0] = _v5storage[0];
    argStorage[1] = _v5storage[1];
    argStorage[2] = _v5storage[2];
    argStorage[3] = _v5storage[3];
    argStorage[4] = _v5storage[4];
    return arg;
  }

  /// Copies [this] into [array] starting at [offset].
  void copyIntoArray(List<double> array, [int offset = 0]) {
    array[offset + 0] = _v5storage[0];
    array[offset + 1] = _v5storage[1];
    array[offset + 2] = _v5storage[2];
    array[offset + 3] = _v5storage[3];
    array[offset + 4] = _v5storage[4];
  }

  /// Copies elements from [array] into [this] starting at [offset].
  void copyFromArray(List<double> array, [int offset = 0]) {
    _v5storage[0] = array[offset + 0];
    _v5storage[1] = array[offset + 1];
    _v5storage[2] = array[offset + 2];
    _v5storage[3] = array[offset + 3];
    _v5storage[4] = array[offset + 4];
  }

  /// Set the values by copying them from [other].
  void setFrom(Vector5 other) {
    final Float64List otherStorage = other._v5storage;
    _v5storage[4] = otherStorage[4];
    _v5storage[3] = otherStorage[3];
    _v5storage[2] = otherStorage[2];
    _v5storage[1] = otherStorage[1];
    _v5storage[0] = otherStorage[0];
  }

  /// Splat [arg] into all lanes of the vector.
  void splat(double arg) {
    _v5storage[4] = arg;
    _v5storage[3] = arg;
    _v5storage[2] = arg;
    _v5storage[1] = arg;
    _v5storage[0] = arg;
  }

  /// Returns a printable string
  @override
  String toString() => '${_v5storage[0]},${_v5storage[1]},'
      '${_v5storage[2]},${_v5storage[3]},${_v5storage[4]}';

  /// Check if two vectors are the same.
  @override
  bool operator ==(Object other) =>
      (other is Vector5) &&
      (_v5storage[0] == other._v5storage[0]) &&
      (_v5storage[1] == other._v5storage[1]) &&
      (_v5storage[2] == other._v5storage[2]) &&
      (_v5storage[3] == other._v5storage[3]) &&
      (_v5storage[4] == other._v5storage[4]);

  @override
  int get hashCode => quiver.hashObjects(_v5storage);

  /// Negate.
  Vector5 operator -() => clone()..negate();

  /// Subtract two vectors.
  Vector5 operator -(Vector5 other) => clone()..sub(other);

  /// Add two vectors.
  Vector5 operator +(Vector5 other) => clone()..add(other);

  /// Scale.
  Vector5 operator /(double scale) => clone()..scale(1.0 / scale);

  /// Scale.
  Vector5 operator *(double scale) => clone()..scale(scale);

  /// Access the component of the vector at the index [i].
  double operator [](int i) => _v5storage[i];

  /// Set the component of the vector at the index [i].
  void operator []=(int i, double v) {
    _v5storage[i] = v;
  }

  /// Negate [this].
  void negate() {
    _v5storage[0] = -_v5storage[0];
    _v5storage[1] = -_v5storage[1];
    _v5storage[2] = -_v5storage[2];
    _v5storage[3] = -_v5storage[3];
    _v5storage[4] = -_v5storage[4];
  }

  /// Scale [this] by [arg].
  void scale(double arg) {
    _v5storage[0] = _v5storage[0] * arg;
    _v5storage[1] = _v5storage[1] * arg;
    _v5storage[2] = _v5storage[2] * arg;
    _v5storage[3] = _v5storage[3] * arg;
    _v5storage[4] = _v5storage[4] * arg;
  }

  void add(Vector5 arg) {
    final Float64List argStorage = arg._v5storage;
    _v5storage[0] = _v5storage[0] + argStorage[0];
    _v5storage[1] = _v5storage[1] + argStorage[1];
    _v5storage[2] = _v5storage[2] + argStorage[2];
    _v5storage[3] = _v5storage[3] + argStorage[3];
    _v5storage[4] = _v5storage[4] + argStorage[4];
  }

  /// Subtract [arg] from [this].
  void sub(Vector5 arg) {
    final Float64List argStorage = arg._v5storage;
    _v5storage[0] = _v5storage[0] - argStorage[0];
    _v5storage[1] = _v5storage[1] - argStorage[1];
    _v5storage[2] = _v5storage[2] - argStorage[2];
    _v5storage[3] = _v5storage[3] - argStorage[3];
    _v5storage[4] = _v5storage[4] - argStorage[4];
  }
}
