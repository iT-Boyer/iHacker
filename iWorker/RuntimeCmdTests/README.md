#  说明

Swift 方法（函数）调度
https://www.jianshu.com/p/a20b7042b748
Swift runtime
https://www.jianshu.com/p/c9997eb7306d

Swift Runtime分析：还像OC Runtime一样吗？
https://runningyoung.github.io/2016/05/01/2016-05-01-Swift-Read2/


## 金和主工程反射类问题

swift混编库在集成后，可以在反射类文件中实现通过oc运行时（objc_getClass）拿到Class，实例化调用组件库中的Swift相关类的方法

问题1: 无法调用Swift库中的类方法，会提示类中无此方法
```
+[JHMornInspecterController shared]: unrecognized selector sent to class 0x10a23d7a8
```
runtime调用类方法调用实现如下
```objc
//方式1
UIViewController *morn = ((UIViewController * (*)(id, SEL))objc_msgSend)(mornCls,NSSelectorFromString(@"shared"));
//方式2
UIViewController *morn = [mornCls performSelector:NSSelectorFromString(@"shared")];
```
解决方法：支持实例方法的调用
可行方式： 通过`objc_getClass`拿到Class，使用new方法实例化对象。
```objc
UIViewController *morn = [mornCls new];
//调用实例方法
((void(*)(id, SEL,NSString*))objc_msgSend)(morn, @selector(testOC:), @"OK");
[morn performSelector:@selector(testOC:) withObject:@"hhah"];
```

## Swift使用runtime调用OC方法
1. 在swift中使用runtime调用oc方法
验证通过：
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
问题1: 没有找到runtime 调用类方法的方案
Swift runtime https://www.jianshu.com/p/c9997eb7306d
Swift 方法（函数）调度 https://www.jianshu.com/p/a20b7042b748
Runtime 消息传递、转发机制(OC&Swift ) https://www.jianshu.com/p/4954ff0ce999


问题2: perform 返回值 `nmanaged<AnyObject>!` 解析
```swift
    login.perform(codemethod).retain().takeRetainedValue()
```
https://blog.csdn.net/loveqcx123/article/details/76976053
https://stackoverflow.com/questions/25984827/get-value-as-swift-type-from-unmanagedanyobject-for-example-abrecordref

2. 在OC中使用runtime，混淆swift方法实现
