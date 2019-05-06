//
//  NSNotification+LYUEvent.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/5/6.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "NSNotification+LYUEvent.h"

@implementation NSNotification (LYUEvent)

+ (Class)eventClass{
    return [NSNotification class];
}

- (NSString *)eventSubType{
    return self.name;
}

@end
