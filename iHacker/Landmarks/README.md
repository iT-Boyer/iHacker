# Completed Project: Creating and Combining Views

Explore the completed project for the [Creating and Combining Views](https://developer.apple.com/tutorials/swiftui/creating-and-combining-views) tutorial.

    // previews 可以返回多个View someview
    // previewLayout 预览视图布局方法。辅助在开发中的多个视图的布局样式。
    // Group容器，可以批量处理多个View的样式。

1. List() 视图 struct init构造器的入参：Identifiable
2. NavigationView：导航条，NavigationLink：点击事件

Make a different choice in Canvas Settings in Xcode’s preferences.
You can specify the device to use in the active scheme, in code, or by previewing directly on your device. No need for a trip to the preferences!

## 把列表中的数据传入详情页展示
1. 地址信息 -- 更新地图
2. 头像信息 -- 更新头像
3. 姓名 -- 更新姓名
...

在View视图中添加接收参数的属性，并更新UI展示。
1. 头像：图片实例
2. 地图：坐标 
https://developer.apple.com/sf-symbols/

## 更新视图的方式
1. 修改@state属性，视图使用$语法监听属性变更，出发视图刷新。响应式UI刷新。

### Which of the following passes data downward in the view hierarchy?

You use this attribute in views that are lower down in the view hierarchy to receive data from views that are higher up.

You apply this modifier so that views further down in the view hierarchy can read data objects passed down through the environment.


### What’s the role of a binding?
绑定的作用是什么？

It’s a value and a way to change that value.
A binding controls the storage for a value, so you can pass data around to different views that need to read or write it.

It’s a way to link a pair of views together to ensure that they receive the same data.

You can use bindings to plumb data throughout your app’s views; bindings aren’t limited to just two views.


It’s a way to freeze a value temporarily so that other views don’t update during state transitions.

A binding doesn’t prevent updates. Instead, it propagates updates to different views in your app.


### Which is the correct way to create state for a view?

@State var showFavoritesOnly = false
Always mark state properties as private because state should be specific to a view and its child views.

@State private var showFavoritesOnly = false
Use the @State property wrapper to mark a value as state, declare the property as private, and give it a default value.
