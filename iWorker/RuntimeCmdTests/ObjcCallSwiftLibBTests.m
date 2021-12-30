//
//  ObjcCallSwiftLibBTests.m
//  RuntimeCmdTests
//
//  Created by boyer on 2021/12/30.
//

#import <XCTest/XCTest.h>
#import <objc/message.h>
#import "RuntimeCmdTests-Swift.h"
//#import <SwiftLibB/SwiftLibB-Swift.h>

@interface ObjcCallSwiftLibBTests : XCTestCase

@end

@implementation ObjcCallSwiftLibBTests
{
    Class libBCls;
    id libBObj;
}
- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    // 当swiftLibB不是混编时，libBCls = nil
    // 推论：如果oc要调用swiftlib库中的swift方法，swiftlib库必须是混编模式。
//    SwiftLibB *libB = [SwiftLibB new];
    libBCls = objc_getClass("SwiftLibB.SwiftLibB");
    if (libBCls) {
        //读取类的方法
        [Tools methodAndProList:libBCls];
        libBObj = [libBCls new];
    }
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

/// 验证swiftlibB库中的使用方法
-(void)testSwiftLibB
{
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
