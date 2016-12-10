GTMRefresh
===================

# Introduction
`GTMRefresh` 用Swift重写的MJRefresh


##特点
- 自定义方便, Demo里面有国内主流App的下拉效果的模仿
- 代码简洁，总代码量不超过1000行
- 支持国际化


# Demo
直接下载代码，里面Demo里面有各种效果的自定义效果（因为时间比较紧，demo代码可能不够漂亮）

![alt tag](https://raw.githubusercontent.com/GTMYang/GTMRefresh/master/Demo.gif)

# Demo模仿的下拉效果

- YahooWeather
- Curve Mask
- Youku
- TaoBao
- QQ Video
- DianPing

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

## Vesrion 0.0.1

This version requires Xcode 8.0 and Swift 3.

# 使用帮助

Firstly, import `GTMRefresh`.

```swift
import GTMRefresh
```

## 使用默认的下拉和上拉效果


## 自定义下拉刷新效果

### 约定
- 必须继承 GTMRefreshHeader
- 必须实现 SubGTMRefreshHeaderProtocol

### SubGTMRefreshHeaderProtocol

```
public protocol SubGTMRefreshHeaderProtocol {
/// 状态变成.idle
func toNormalState()
/// 状态变成.refreshing
func toRefreshingState()
/// 状态变成.pulling
func toPullingState()
/// 状态变成.willRefresh
func toWillRefreshState()
/// 下拉高度／触发高度 值改变
func changePullingPercent(percent: CGFloat)
/// 开始结束动画前执行
func willBeginEndRefershing(isSuccess: Bool)
/// 结束动画完成后执行
func willCompleteEndRefershing()

/// 控件的高度
///
/// - Returns: 控件的高度
func contentHeight() -> CGFloat
}

```

### 特殊效果的实现


## 自定义上拉加载效果




