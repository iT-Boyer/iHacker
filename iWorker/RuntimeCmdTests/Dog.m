//
//  Dog.m
//  RuntimeCmdTests
//
//  Created by boyer on 2021/12/29.
//

#import "Dog.h"
#import <objc/message.h>


@implementation Dog

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        self.name = @"哈士奇";
    }
    return self;
}

-(NSString *)owner
{
    return @"张三";
    
}

-(NSString *)call
{
    NSLog(@"汪汪.....");
    return @"旺旺";
}

+(NSString *)callCls
{
    NSLog(@"汪汪.....类方法");
    return @"旺旺";
}
@end
