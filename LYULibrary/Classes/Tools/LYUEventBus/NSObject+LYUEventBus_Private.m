//
//  NSObject+LYUEventBus_Private.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/5/6.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "NSObject+LYUEventBus_Private.h"
#import <objc/runtime.h>

static const char event_bus_disposeContext;

@implementation NSObject (LYUEventBus_Private)
- (LYUDisposeBag *)eb_disposeBag{
    LYUDisposeBag * bag = objc_getAssociatedObject(self, &event_bus_disposeContext);
    if (!bag) {
        bag = [[LYUDisposeBag alloc] init];
        objc_setAssociatedObject(self, &event_bus_disposeContext, bag, OBJC_ASSOCIATION_RETAIN);
    }
    return bag;
}
@end
