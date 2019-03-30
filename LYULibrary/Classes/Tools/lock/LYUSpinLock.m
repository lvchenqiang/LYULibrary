//
//  LYUSpinLock.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/3/30.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "LYUSpinLock.h"
#import "LYUMutexLock.h"
#import "LYUOSUnfairLock.h"

@interface LYUSpinLock ()

@property (nonatomic, strong) id<LYULockProtocol> locker;

@end

@implementation LYUSpinLock

- (instancetype)init
{
    if(self = [super init]){
        if (@available(iOS 10.0, macOS 10.12, watchOS 3.0, tvOS 10.0, *)) {
            // 版本适配
            self.locker = [[LYUOSUnfairLock alloc] init];
            
        }else{
            self.locker = [[LYUMutexLock alloc] init];
        }
    }
    return self;
}

- (void)lock
{
    [self.locker lock];
}

- (void)unlock
{
    [self.locker unlock];
}


@end
