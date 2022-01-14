//
//  ObjcCallSwiftLibBTests.m
//  RuntimeCmdTests
//
//  Created by boyer on 2021/12/30.
//

#import <XCTest/XCTest.h>
#import <objc/message.h>
#import "RuntimeCmdTests-Swift.h"
#import <SwiftLibB/SwiftLibB-Swift.h>

@interface ObjcCallSwiftLibBTests : XCTestCase

@end

@implementation ObjcCallSwiftLibBTests
{
    Class libBCls;
    id libBObj;
    Class secondCls;
}
- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // 当swiftLibB不是混编时，libBCls = nil
    // 推论1：如果oc要调用swiftlib库中的swift方法，swiftlib库必须是混编模式。
    //类1
    libBCls = objc_getClass("SwiftLibB.SwiftLibB");
    if (libBCls) {
        //读取类的方法
//        [Tools showClsRuntimeWithCls:libBCls];
        libBObj = [libBCls new];
    }
    //类2
    secondCls = objc_getClass("SwiftLibB.SecondB");
    if (secondCls) {
        //读取类的方法
        [Tools showClsRuntimeWithCls:secondCls];
    }
}

/// 结论:当oc库中的任一swift/.m文件中出现引用swift库中的类时，objc_getClass才可以拿到相应类。
-(void)testSwiftLibBObj
{
    [SwiftLibB shared];
//    [SecondB shared];
}

/// 验证oc调用swiftlibB库中的类方法
-(void)testSwiftLibB
{
    ((void(*)(id, SEL))objc_msgSend)(libBCls, @selector(shared));
}

/// 验证oc调用swiftlibB库中单利
-(void)testSwiftLibBa
{
    ((void(*)(id, SEL))objc_msgSend)(secondCls, @selector(shareda));
}

-(void)testSwiftLibCallme
{
    ((void(*)(id, SEL,NSString*))objc_msgSend)(libBObj, @selector(callMe:),@"大神");
    ((void(*)(id, SEL,NSString*))objc_msgSend)(libBObj, @selector(callMeinEx:),@"大神");
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
