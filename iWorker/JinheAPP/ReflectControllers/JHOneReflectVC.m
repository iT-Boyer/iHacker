//
//  JHOneReflectVC.m
//  JinheAPP
//
//  Created by boyer on 2021/12/29.
//

#import "JHOneReflectVC.h"
#import <objc/message.h>
#import <SwiftLibB/SwiftLibB-Swift.h>
@interface JHOneReflectVC ()

@end

@implementation JHOneReflectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/// 获取swift库中的类方法
-(void)swiftRuntimeT
{
    id cls;
    //方式1 cls = nil
    cls = objc_getClass("SwiftRuntimeT");
    //方式2 获取swiftLib库中的类时，需要带module名
    cls = objc_getClass("SwiftLibB.SwiftRuntimeT");
    //方式3
    cls = NSClassFromString(@"SwiftRuntimeT");
    if (cls) {
        //打印
        ((void(*)(id, SEL))objc_msgSend)(cls, @selector(sharedT));
    }
}

@end
