Cocoaout
========

本工具用于代替 Xcode 编译发布应用，简化来回图形界面点击步骤，同时直接打包 DMG。

## 功能

* 代替 Xcode 图形界面编译，省去来回点击许多的配置；
* 固定配置，保证编译环境准确；
* DMG 自动打包，DMG 支持背景图片；

## 环境需求

* XCode 4+
* Mac OS X
* Ruby 2.0 (OS X 10.9 自带)
* RubyGems

## 安装

```bash
gem install cocoaout
```

```bash
cocoaout help
```

## 创建 Cocoaout 配置文件

在你的项目根目录 (.xcworkspace 所在的目录) 执行

```bash
cocoaout init
``` 

将会创建 `Cocoaoutfile` 这个文件，请打开根据需要修改配置

## 发布 App

```bash
# 自动用 Archive 的方式编译项目，同时打包 DMG 文件
cocoaout deploy
```

