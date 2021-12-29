//
//  JHOneReflectVC.m
//  JinheAPP
//
//  Created by boyer on 2021/12/29.
//

#import "JHOneReflectVC.h"
#import <objc/message.h>
#import <SwiftLibB/SwiftLibB-Swift.h>
#import "JinheAPP-Swift.h"


#import <objc/runtime.h>

@interface JHOneReflectVC ()

@end

@implementation JHOneReflectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/// 获取swift库中的类方法
-(void)swiftMethod
{
//    SwiftRuntimeT *rt = [SwiftRuntimeT new];
//    [rt sharedT];
    id cls;
    //方式1 cls = nil
    cls = objc_getClass("SwiftLibB.SwiftRuntimeT");
    //方式2 获取swiftLib库中的类时，需要带module名
    cls = objc_getClass("SwiftLibB.SwiftRuntimeT");
    //方式3
    cls = NSClassFromString(@"SwiftLibB.SwiftRuntimeT");
    
    [JHOneReflectVC enumerateMethodsInClass:cls usingBlock:^(__unsafe_unretained Class cls, SEL sel) {
        NSLog(@"swift类名：%@，方法：%@",NSStringFromClass(cls), NSStringFromSelector(sel));
    }];
    if (cls) {
        //打印
        id obj = [cls new];
        if ([obj respondsToSelector:@selector(sharedT)]) {
            [obj performSelector:@selector(sharedT)];
        }
     
        //runtime
        ((void(*)(id, SEL))objc_msgSend)(cls, @selector(sharedT));
    }
}

// 获取OC类中的方法，并通过runtime执行
-(void)OCMethod
{
    //方式1 cls = nil
    id cls = objc_getClass("ViewController");
    [JHOneReflectVC enumerateMethodsInClass:cls usingBlock:^(__unsafe_unretained Class cls, SEL sel) {
        NSLog(@"OC类名：%@，方法：%@",NSStringFromClass(cls), NSStringFromSelector(sel));
    }];
    if (cls) {
        //打印
        ((void(*)(id, SEL))objc_msgSend)(cls, @selector(classmethod));
    }
}

-(void)swiftConfig
{
    id cls;
    //方式1 cls = nil
    cls = objc_getClass("JinheAPP.SwiftConfig");
    //方式3
    cls = NSClassFromString(@"JinheAPP.SwiftConfig");
//    showClsRuntime(cls);
    [JHOneReflectVC enumerateMethodsInClass:cls usingBlock:^(__unsafe_unretained Class cls, SEL sel) {
        NSLog(@"swift类名：%@，方法：%@",NSStringFromClass(cls), NSStringFromSelector(sel));
    }];
    if (cls) {
//        //打印
//        id obj = [cls new];
//        if ([obj respondsToSelector:@selector(testRuntimeT)]) {
//            [obj performSelector:@selector(testRuntimeT)];
//        }
     
        //runtime
        ((void(*)(id, SEL))objc_msgSend)(cls, @selector(testRuntimeT));
    }
}

/// 获取类在运行时，可用的方法清单
+ (void)enumerateMethodsInClass:(Class)aClass usingBlock:(void (^)(Class cls, SEL sel))aBlock
{
    Method *methodList = class_copyMethodList(aClass, NULL);

    for(Method *mPtr = methodList; *mPtr != NULL; mPtr++)
    {
        SEL sel = method_getName(*mPtr);
        aBlock(aClass, sel);
    }
    free(methodList);
}

@end
