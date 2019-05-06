//
//  NSObject+LYUEventBus.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/5/6.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "NSObject+LYUEventBus.h"
#import <UIKit/UIKit.h>
#import "LYUEventBus.h"
#import "NSString+LYUEvent.h"
#import "NSObject+LYUEventBus_Private.h"


@implementation NSObject (LYUEventBus)

- (LYUEventSubscriberMaker *)subscribeSharedBus:(Class)eventClass
{
    return LYUEventBus.shared.on(eventClass).freeWith(self);
}

- (LYUEventSubscriberMaker<NSString *> *)subscribeName:(NSString *)eventName on:(LYUEventBus *)bus
{
    NSParameterAssert(eventName != nil);
    return [bus on:NSString.class].ofSubType(eventName).freeWith(self);
}

- (LYUEventSubscriberMaker *)subscribe:(Class)eventClass on:(LYUEventBus *)bus
{
    return bus.on(eventClass).freeWith(self);
}

- (LYUEventSubscriberMaker<NSString *> *)subscribeSharedBusOfName:(NSString *)eventName
{
    NSParameterAssert(eventName != nil);
    return [[LYUEventBus shared] on:NSString.class].ofSubType(eventName).freeWith(self);
}
@end
