//
//  SwiftRuntimeTests.m
//  JinheAPPTests
//
//  Created by boyer on 2021/12/29.
//

#import <XCTest/XCTest.h>
#import "JHOneReflectVC.h"
@interface SwiftRuntimeTests : XCTestCase

@end

@implementation SwiftRuntimeTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testSwiftRuntime {
    JHOneReflectVC *oc = [JHOneReflectVC new];
    [oc swiftMethod];
}

-(void)testOCRuntime
{
    JHOneReflectVC *oc = [JHOneReflectVC new];
    [oc OCMethod];
}

-(void)testSwiftConfig
{
    JHOneReflectVC *oc = [JHOneReflectVC new];
    [oc swiftConfig];
}
@end
