//
//  Dog.h
//  RuntimeCmdTests
//
//  Created by boyer on 2021/12/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Dog : NSObject

@property (strong, nonatomic) NSString *name;
///铲屎官
-(NSString *)owner;
///叫声
-(NSString *)call;

+(NSString *)callCls;
@end

NS_ASSUME_NONNULL_END
