//
//  RuntimeOCTests.m
//  RuntimeCmdTests
//
//  Created by boyer on 2021/12/30.
//

#import <XCTest/XCTest.h>
#import <objc/message.h>
//#import "RuntimeCmdTests-Swift.h"

@interface RuntimeOCTests : XCTestCase

@end

@implementation RuntimeOCTests
{
    Class personclass;
    id personObj;
}

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    //方式1 cls = nil
    personclass = objc_getClass("Person");
    //方式2 获取swiftLib库中的类时，需要带module名
    personclass = objc_getClass("RuntimeCmdTests.Person");
    //方式3
    personclass = NSClassFromString(@"RuntimeCmdTests.Person");
    [self enumerateMethodsInClass:personclass usingBlock:^(__unsafe_unretained Class cls, SEL sel) {
        //class转NSString Selector转NSString
        NSLog(@"swift类名：%@，方法：%@",NSStringFromClass(cls), NSStringFromSelector(sel));
    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
//    APIHeader *api = [APIHeader new];
//    Person *leader = [api leader];
//    NSLog(@"当前领导：%@",leader.name);
}

//oc调用swift类方法,初始化实例
-(void)testObjCallSwiftClsMethod
{
    //shared：swift类方法初始化实例personObj
    personObj =  ((id(*)(id, SEL))objc_msgSend)(personclass, @selector(shared));
    //setName: swift实例方法，设置姓名
    ((void(*)(id, SEL,NSString *))objc_msgSend)(personObj, @selector(setName:), @"张三");
    //like: swift实例方法，获取用户喜好
    NSString *like = ((NSString *(*)(id, SEL,NSString *))objc_msgSend)(personObj, @selector(like:), @"萨斯奇");
    //打印
    NSLog(@"%@", like);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

/// 获取类在运行时，可用的方法清单
- (void)enumerateMethodsInClass:(Class)aClass usingBlock:(void (^)(Class cls, SEL sel))aBlock
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
