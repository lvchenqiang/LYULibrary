//
//  LYUOSUnfairLock.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/3/30.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "LYUOSUnfairLock.h"
#import <os/lock.h>

@interface LYUOSUnfairLock ()
// Low-level lock
// ll lock
// lll
// Low-level lock的特点等不到锁就休眠
@property (assign, nonatomic) os_unfair_lock unfairLock;

@end

@implementation LYUOSUnfairLock

- (instancetype)init
{
    if (self = [super init]) {
        self.unfairLock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

- (void)lock
{
    os_unfair_lock_lock(&_unfairLock);
}

- (void)unlock
{
    os_unfair_lock_unlock(&_unfairLock);
}
@end
