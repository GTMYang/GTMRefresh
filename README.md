GTMActivityIndicatorView
===================

# Introduction
`GTMActivityIndicatorView` 是一个Loadding动画库

本库是在 [NVActivityIndicatorView](https://github.com/gontovnik/DGActivityIndicatorView), 的基础上做了一些方便使用的改进


##改进了什么？

###1. Animations代码不放到库里面（无用代码太多），用户可以通过实现NVActivityIndicatorAnimation定义任意的动画，原来已定义好的动画组件都在demo项目里面，用户可以根据自己的需求挑选想要的动画使用
- 去掉了枚举enum NVActivityIndicatorType
- 将protocol NVActivityIndicatorAnimationDelegate改成protocol NVActivityIndicatorAnimation

###2. UIViewController 不需要写实现 NVActivityIndicatorViewable的代码
- 去掉了NVActivityIndicatorViewable协议
- 将原来针对实现NVActivityIndicatorViewable的UIViewController的扩展改成针对UIViewController的扩展

# 申明
如果[NVActivityIndicatorView](https://github.com/gontovnik/DGActivityIndicatorView)项目也作了类似本类库的调整，建议大家用回原库，尊重原创，我这里只做了一点点的工作

# Demo
直接下载代码，代码里面包含Demo

![alt tag](https://raw.githubusercontent.com/ninjaprox/NVActivityIndicatorView/master/Demo.gif)

For first-hand experience, just open the project and run it.

# Animation types

| Type | Type | Type | Type |
|---|---|---|---|
1. BallPulse | 2. BallGridPulse | 3. BallClipRotate | 4. SquareSpin
5. BallClipRotatePulse | 6. BallClipRotateMultiple | 7. BallPulseRise | 8. BallRotate
9. CubeTransition | 10. BallZigZag | 11. BallZigZagDeflect | 12. BallTrianglePath
13. BallScale | 14. LineScale | 15. LineScaleParty | 16. BallScaleMultiple
17. BallPulseSync | 18. BallBeat | 19. LineScalePulseOut | 20. LineScalePulseOutRapid
21. BallScaleRipple | 22. BallScaleRippleMultiple | 23. BallSpinFadeLoader | 24. LineSpinFadeLoader
25. TriangleSkewSpin | 26. Pacman | 27. BallGridBeat | 28. SemiCircleSpin
29. BallRotateChase | 30. Orbit | 31. AudioEqualizer

# Installation

## Cocoapods

Install Cocoapods if need be.

```bash
$ gem install cocoapods
```

Add `GTMActivityIndicatorView` in your `Podfile`.

```ruby
use_frameworks!

pod 'GTMActivityIndicatorView'
```

Then, run the following command.

```bash
$ pod install
```


## Manual

Copy `GTMActivityIndicatorView` folder to your project. That's it.

_**Note:** Make sure that all files in `GTMActivityIndicatorView` included in Compile Sources in Build Phases._

# Migration

## Vesrion 1.0

This version requires Xcode 8.0 and Swift 3.

# Usage

Firstly, import `GTMActivityIndicatorView`.

```swift
import GTMActivityIndicatorView
```

## Initialization

Then, there are two ways you can create GTMActivityIndicatorView:


- By code, using initializer. All parameters other than `frame` are optional and `GTMActivityIndicatorView.DEFAULT_*` are used as default values.

```swift
GTMActivityIndicatorView(frame: frame, type: type, color: color, padding: padding)
```

_**Note:** Check [DEFAULTS](#defaults) for default values._

## Control

Start animating.

```swift
activityIndicatorView.startAnimating()
```

Stop animating.

```swift
activityIndicatorView.stopAnimating()
```

Determine if it is animating.

```swift
animating = activityIndicatorView.animating
```


Start animating.

```swift
showLoadding(size, message) // plus other parameters as in initializer.
```

Stop animating.

```swift
hideLoadding()
```

Or you can use `NVActivityIndicatorPresenter` to display UI blocker anywhere.

Start animating.

```swift
let activityData = ActivityData()

NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
```

_**Note:** Check documentation for detail of `ActivityData`._

Stop animating.

```swift
NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
```

## DEFAULTS

There are global defaults for all `GTMActivityIndicatorView` instances.

- Default animation type.

```swift
默认动画 NVActivityIndicatorAnimationBallSpinFadeLoader
```

- Default color of activity indicator view.

```swift
GTMActivityIndicatorView.DEFAULT_COLOR = UIColor.whiteColor()
```

- Default padding of activity indicator view.

```swift
GTMActivityIndicatorView.DEFAULT_PADDING = CGFloat(0)
```

- Default size of activity indicator view used in UI blocker.

```swift
GTMActivityIndicatorView.DEFAULT_BLOCKER_SIZE = CGSizeMake(60, 60)
```

- Default display time threshold.

> Default time that has to be elapsed (between calls of `startAnimating()` and `stopAnimating()`) in order to actually display UI blocker. It should be set thinking about what the minimum duration of an activity is to be worth showing it to the user. If the activity ends before this time threshold, then it will not be displayed at all.

```swift
GTMActivityIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = 0 // in milliseconds
```

- Default minimum display time.

> Default minimum display time of UI blocker. Its main purpose is to avoid flashes showing and hiding it so fast. For instance, setting it to 200ms will force UI blocker to be shown for at least this time (regardless of calling `stopAnimating()` ealier).

```swift
GTMActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 0 // in milliseconds
```

- Default message displayed in UI blocker.

```swift
GTMActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE: String? = nil
```

- Default font of message displayed in UI blocker.

```swift
GTMActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE_FONT = UIFont.boldSystemFont(ofSize: 20)
```


