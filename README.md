GTMRefresh
===================

# Introduction
`GTMRefresh` 用Swift重写的MJRefresh


##特点
- 支持各种效果的自定义，自定义比较方便
- 代码简介，总代码量不超过1000行


# Demo
直接下载代码，里面Demo里面有各种效果的自定义效果（因为时间比较紧，demo代码可能不够漂亮）

![alt tag](https://github.com/GTMYang/GTMRefresh//master/Demo效果.gif)

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

Add `GTMRefresh` in your `Podfile`.

```ruby
use_frameworks!

pod 'GTMRefresh'
```

Then, run the following command.

```bash
$ pod install
```


## Manual

Copy `GTMRefresh` folder to your project. That's it.

_**Note:** Make sure that all files in `GTMRefresh` included in Compile Sources in Build Phases._

# Migration

## Vesrion 1.0

This version requires Xcode 8.0 and Swift 3.

# Usage

Firstly, import `GTMRefresh`.

```swift
import GTMRefresh
```

## Initialization

Then, there are two ways you can create GTMRefresh:


- By code, using initializer. All parameters other than `frame` are optional and `GTMRefresh.DEFAULT_*` are used as default values.

```swift
GTMRefresh(frame: frame, type: type, color: color, padding: padding)
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

There are global defaults for all `GTMRefresh` instances.

- Default animation type.

```swift
默认动画 NVActivityIndicatorAnimationBallSpinFadeLoader
```

- Default color of activity indicator view.

```swift
GTMRefresh.DEFAULT_COLOR = UIColor.whiteColor()
```

- Default padding of activity indicator view.

```swift
GTMRefresh.DEFAULT_PADDING = CGFloat(0)
```

- Default size of activity indicator view used in UI blocker.

```swift
GTMRefresh.DEFAULT_BLOCKER_SIZE = CGSizeMake(60, 60)
```

- Default display time threshold.

> Default time that has to be elapsed (between calls of `startAnimating()` and `stopAnimating()`) in order to actually display UI blocker. It should be set thinking about what the minimum duration of an activity is to be worth showing it to the user. If the activity ends before this time threshold, then it will not be displayed at all.

```swift
GTMRefresh.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD = 0 // in milliseconds
```

- Default minimum display time.

> Default minimum display time of UI blocker. Its main purpose is to avoid flashes showing and hiding it so fast. For instance, setting it to 200ms will force UI blocker to be shown for at least this time (regardless of calling `stopAnimating()` ealier).

```swift
GTMRefresh.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME = 0 // in milliseconds
```

- Default message displayed in UI blocker.

```swift
GTMRefresh.DEFAULT_BLOCKER_MESSAGE: String? = nil
```

- Default font of message displayed in UI blocker.

```swift
GTMRefresh.DEFAULT_BLOCKER_MESSAGE_FONT = UIFont.boldSystemFont(ofSize: 20)
```


