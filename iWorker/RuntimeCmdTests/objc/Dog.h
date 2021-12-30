//
//  Dog.h
//  RuntimeCmdTests
//
//  Created by boyer on 2021/12/29.
//

#import <Foundation/Foundation.h>
#import "RuntimeCmdTests-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface Dog : NSObject

///铲屎官
//-(Person *)owner;
-(NSString *)owner;
///叫声
-(NSString *)call;

@end

NS_ASSUME_NONNULL_END
