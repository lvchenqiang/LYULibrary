//
//  NSString+LYUEvent.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/5/6.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "NSString+LYUEvent.h"

@implementation NSString (LYUEvent)

- (NSString *)eventSubType{
    return [self copy];
}

+ (Class)eventClass{
    return [NSString class];
}

@end
