此文章主要介绍怎么使用Flutter的Cupertino风格控件，写一个iOS风格的通讯录，还有在此过程中遇到的问题及解决办法。

大家在用Flutter写App的时候，一般都会使用material风格的控件，因为material风格的控件比较丰富，但是，他在iOS上就会显得Android气息比较重，不太适合，所以本文章将通过用仿写iOS通讯录，系统地介绍Cupertino控件，及系统的一些底层控件和怎么自己定义优美的适合自己的控件。

由于使用的联系人三方包的限制，有些功能未能实现，我会持续关注这个联系人插件的更新，及时加上新功能。

### 首页

![首页截图](https://oscimg.oschina.net/oscnet/up-ce739da060a0f63e7d3f8e1b76a7d7d7248.png)

#### 主要用到的控件及问题

##### CupertinoPageScaffold

一个iOS风格Scaffold，可以添加NavigationBar。

##### NestedScrollView

实现浮动的NavigationBar和SearchBar。

NestedScrollView我用的自己重写过的，主要是因为源码中的有两个问题。

1、当列表滑动到底部，然后继续滑动，然后停止，松手，这时候可列表会重新滚动到底部，但是源码没有处理当速度等于0的时候的情况，所以当松手的时候，列表会回弹回去，回弹距离小于`maxScrollExtent`。

#### 源码如下：

```dart
@protected
ScrollActivity createInnerBallisticScrollActivity(_NestedScrollPosition position, double velocity) {
  return position.createBallisticScrollActivity(
    position.physics.createBallisticSimulation(
      velocity == 0 ? position as ScrollMetrics : _getMetrics(position, velocity),
      velocity,
    ),
    mode: _NestedBallisticScrollActivityMode.inner,
  );
}
```

这里当`velocity == 0`的时候，直接把innerPosition赋值给了`createBallisticSimulation`方法的`position`参数，我们继续往下看。

```dart
ScrollActivity createBallisticScrollActivity(
  Simulation simulation, {
  @required _NestedBallisticScrollActivityMode mode,
  _NestedScrollMetrics metrics,
}) {
  if (simulation == null) return IdleScrollActivity(this);
    assert(mode != null);
    switch (mode) {
      case _NestedBallisticScrollActivityMode.outer:
        assert(metrics != null);
        if (metrics.minRange == metrics.maxRange) return IdleScrollActivity(this);
        return _NestedOuterBallisticScrollActivity(
          coordinator,
          this,
          metrics,
          simulation,
          context.vsync,
        );
      case _NestedBallisticScrollActivityMode.inner:
        return _NestedInnerBallisticScrollActivity(
          coordinator,
          this,
          simulation,
          context.vsync,
        );
      case _NestedBallisticScrollActivityMode.independent:
        return BallisticScrollActivity(this, simulation, context.vsync);
  }
  return null;
}
```

这里`velocity == 0`的时候，执行的是

```
case _NestedBallisticScrollActivityMode.inner:
  return _NestedInnerBallisticScrollActivity(
    coordinator,
    this,
    simulation,
     context.vsync,
  );
```

这时候的`simulation`就是上面通过innerPosition得到的，然后传给了`_NestedInnerBallisticScrollActivity`，我们在继续往下看，

```dart
class _NestedInnerBallisticScrollActivity extends BallisticScrollActivity {
  _NestedInnerBallisticScrollActivity(
    this.coordinator,
    _NestedScrollPosition position,
    Simulation simulation,
    TickerProvider vsync,
  ) : super(position, simulation, vsync);

  final _NestedScrollCoordinator coordinator;

  @override
  _NestedScrollPosition get delegate => super.delegate as _NestedScrollPosition;

  @override
  void resetActivity() {
    delegate.beginActivity(coordinator.createInnerBallisticScrollActivity(
      delegate,
      velocity,
    ));
  }

  @override
  void applyNewDimensions() {
    delegate.beginActivity(coordinator.createInnerBallisticScrollActivity(
      delegate,
      velocity,
    ));
  }

  @override
  bool applyMoveTo(double value) {
    return super.applyMoveTo(coordinator.nestOffset(value, delegate));
  }
}
```

我们发现这里执行的操作并不是我们想要的，当`velocity == 0`，滑动距离大于`maxScrollExtent`的时候，我们只想滚动到列表的最底部，所以我们改一下这里的实现。此处有两种实现方式：

##### 第一种方式：改`_getMetrics`方法

```
// This handles going forward (fling up) and inner list is
// underscrolled, OR, going backward (fling down) and inner list is
// scrolled past zero. We want to skip the pixels we don't need to grow
// or shrink over.
if (velocity > 0.0) {
  // shrinking
  extra = _outerPosition.minScrollExtent - _outerPosition.pixels;
} else if (velocity < 0.0) {
  // growing
  extra = _outerPosition.pixels - (_outerPosition.maxScrollExtent - _outerPosition.minScrollExtent);
} else {
  extra = 0.0;
}
assert(extra <= 0.0);
minRange = _outerPosition.minScrollExtent;
maxRange = _outerPosition.maxScrollExtent + extra;
assert(minRange <= maxRange);
correctionOffset = 0.0;
```

这里加上`velocity == 0`的判断。

##### 第二种方式：修改`createInnerBallisticScrollActivity`方法，加上`velocity == 0`的判断。

```dart
@protected
ScrollActivity createInnerBallisticScrollActivity(_NestedScrollPosition position, double velocity) {
  return position.createBallisticScrollActivity(
    position.physics.createBallisticSimulation(
      velocity == 0 ? position as ScrollMetrics : _getMetrics(position, velocity),
      velocity,
    ),
    mode: velocity == 0 ? _NestedBallisticScrollActivityMode.independent : _NestedBallisticScrollActivityMode.inner,
  );
}
```

2、当我们手动调用`position.moveTo`方法滚动到最底部的时候，获取到的`maxScrollExtent`并不是实际`innerPosition`的`maxScrollExtent`，而应该是`maxScrollExtent - outerPosition.maxScrollExtent + outerPosition.pixels`。

接下来我们分析源码看看哪里出了问题。
首先，我们看看与之有直接关联的maxScrollExtent方法。

```dart
@override
double get maxScrollExtent => _maxScrollExtent;
```

我们看到只是单纯的返`_maxScrollExtent`，那我们看看`_maxScrollExtent`是在哪里赋值的，经过查看源码得知，`_maxScrollExtent`赋值的地方主要在下面这个方法里：

```dart
@override
bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
  assert(minScrollExtent != null);
  assert(maxScrollExtent != null);
  if (!nearEqual(_minScrollExtent, minScrollExtent, Tolerance.defaultTolerance.distance) ||
    !nearEqual(_maxScrollExtent, maxScrollExtent, Tolerance.defaultTolerance.distance) ||
    _didChangeViewportDimensionOrReceiveCorrection) {
    assert(minScrollExtent != null);
    assert(maxScrollExtent != null);
    assert(minScrollExtent <= maxScrollExtent);
    _minScrollExtent = minScrollExtent;
    _maxScrollExtent = maxScrollExtent;
    _haveDimensions = true;
    applyNewDimensions();
    _didChangeViewportDimensionOrReceiveCorrection = false;
  }
  return true;
}
```

所以我们重写这个方法，修改如下：

```dart
@override
bool applyContentDimensions(double minScrollExtent, double maxScrollExtent) {
  assert(minScrollExtent != null);
  assert(maxScrollExtent != null);
  var outerPosition = coordinator._outerPosition;
  var outerMaxScrollExtent = outerPosition.maxScrollExtent;
  var outerPixels = outerPosition.pixels;
  if (outerMaxScrollExtent != null && outerPixels != null) {
    maxScrollExtent -= outerMaxScrollExtent - outerPixels;
    maxScrollExtent = math.max(minScrollExtent, maxScrollExtent);
  }
  return super.applyContentDimensions(minScrollExtent, maxScrollExtent);
}
```

这样我们成功解决了上面提到的两个问题。

##### CustomScrollView

实现浮动的Index。

##### SliverPersistentHeader

实现Index固定在头部。

##### CupertinoSliverRefreshIndicator

实现下拉刷新。

### 群组

![群组](https://oscimg.oschina.net/oscnet/up-9267f68cd3c28c591975f88fbdb6baa0ee1.png)

### 新建联系人页面

![新建联系人](https://oscimg.oschina.net/oscnet/up-641afd320f1c9f2322672b15d08e0339524.png)

![点击取消时](https://oscimg.oschina.net/oscnet/up-8c15cd589dac1efd0247b94bc9eabdbc869.png)

### 编辑头像

![编辑头像](https://oscimg.oschina.net/oscnet/up-472d97f13cb197498e5ddc7df0bb12aa255.png)

![移动和缩放](https://oscimg.oschina.net/oscnet/up-c06c3af37d40fb2d737fb31862669662c5b.png)

![选择滤镜](https://oscimg.oschina.net/oscnet/up-2eee28ce4e51f3496444470f87e03ba3319.png)

![选择后，再次编辑](https://oscimg.oschina.net/oscnet/up-abb8d45063c1bd0953a669d9362606e929f.png)

### 联系人详情

![联系人详情](https://oscimg.oschina.net/oscnet/up-b96db5972b9b297e13ca73b58c993aba6c2.png)

![长按复制](https://oscimg.oschina.net/oscnet/up-64db0c69ab7526f4a5ce833d865dcb9fdd6.png)

### 选择标签

![选择标签](https://oscimg.oschina.net/oscnet/up-ea31833b3dcfc8a7b8221d8cd5192acb5ba.png)

至此，基本完成。