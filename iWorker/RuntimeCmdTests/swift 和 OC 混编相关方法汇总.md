#  swift 和 OC 混编相关方法汇总

## 金和主工程反射类调用组件内swift接口（代替组件内OC封装swift和JHBaseNavVC继承冲突）

swift混编库在集成后，可以在反射类文件中实现通过oc运行时（objc_getClass）拿到Class，实例化调用组件库中的Swift相关类的方法

前提：swift接口类需要集成NSObject 或 @objc 修饰。

1. OC runtime调用swift类方法
```objc
//方式1
UIViewController *morn = ((UIViewController * (*)(id, SEL))objc_msgSend)(mornCls,NSSelectorFromString(@"shared"));
//方式2
UIViewController *morn = [mornCls performSelector:NSSelectorFromString(@"shared")];
```

2. OC runtime调用swift实例方法

可行方式： 通过`objc_getClass`拿到Class，使用new方法实例化对象。
```objc
UIViewController *morn = [mornCls new];
//调用实例方法
((void(*)(id, SEL,NSString*))objc_msgSend)(morn, @selector(testOC:), @"OK");
[morn performSelector:@selector(testOC:) withObject:@"hhah"];
```

## Swift使用runtime调用OC方法（解藕JHBase组件集成大组件登录模块）

前提：OC的头文件不需要添加在桥接文件

1. 在swift中使用runtime调用oc实例方法
```swift
// 1. 获取类
let cls:AnyClass = objc_getClass("LoginAndRegister") as! AnyClass
// 2. 创建对象 
let login:NSObject = class_createInstance(cls, 0) as! NSObject
// 3. 初始化实例方法
let codemethod = Selector("getBase64CodedHttpAuthenticationHeaderWithOrg")
// 4. 判断实例是否支持实例方法
if login.responds(to: codemethod) {
    // 5. 调用实例方法，拿到返回值
    let context = login.perform(codemethod).retain().takeRetainedValue()
    // 6. 使用
    headers = ["ApplicationContext":"\(context)"]
}
```
2. 在swift中使用runtime 调用OC类方法
```swift
// 类方法调用
let cls:AnyClass = objc_getClass("Dog") as! AnyClass
let sel = #selector(Dog.callCls)
if let myClass = cls as? NSObjectProtocol {
    let result = myClass.perform(sel).retain().takeRetainedValue()
    print(result)
}
```

问题2: perform 返回值 `nmanaged<AnyObject>!` 解析
```swift
    login.perform(codemethod).retain().takeRetainedValue()
```

## swift组件独立编译（金和依赖库的特殊性）

金和库使用一个JHThirdPackage库，来统一管理第三方库，在组件中只需要依赖这个库即可。

这样导致 `JHThirdPackage` 无法导出完整的 `swiftmodule` 头文件，对于想独立编译一个组件是不可能的。

这样组件就无法通过依赖 `swiftmodule` 实现独立编译，只能通过两种方式实现：

1.  不要配置PackageDependencies, 要将组件拖到正在联调的项目，利用现有的Package环境，实现编译
2.  想实现独立编译，必须配置Project 的 Package Dependencies, 依赖JHThird 和 JHBase

[混编在模块化:组件化项目中的实践](https://github.com/ShannonChenCHN/ASwiftTour/tree/master/Presentation/ObjC-Swift%20%E6%B7%B7%E7%BC%96%E5%9C%A8%E6%A8%A1%E5%9D%97%E5%8C%96:%E7%BB%84%E4%BB%B6%E5%8C%96%E9%A1%B9%E7%9B%AE%E4%B8%AD%E7%9A%84%E5%AE%9E%E8%B7%B5#module-stability)


https://blog.csdn.net/loveqcx123/article/details/76976053
https://stackoverflow.com/questions/25984827/get-value-as-swift-type-from-unmanagedanyobject-for-example-abrecordref

Swift runtime https://www.jianshu.com/p/c9997eb7306d  
Swift 方法（函数）调度 https://www.jianshu.com/p/a20b7042b748  
Runtime 消息传递、转发机制(OC&Swift ) https://www.jianshu.com/p/4954ff0ce999 

Swift Runtime分析：还像OC Runtime一样吗？
https://runningyoung.github.io/2016/05/01/2016-05-01-Swift-Read2/
