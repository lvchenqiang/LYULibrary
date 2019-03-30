//
//  LYULockManager.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/3/30.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "LYULockManager.h"
#import "LYULockProtocol.h"


#import "LYUOSUnfairLock.h"
#import "LYUMutexLock.h" /// 互斥锁
#import "LYURecursiveMutexLock.h" ///递归锁
#import "LYUConditionLock.h" /// 条件锁
#import "LYUSpinLock.h" /// 自旋锁
@interface LYULockManager()

@property (nonatomic, strong) id<LYULockProtocol> locker;

@end

@implementation LYULockManager

- (instancetype)init
{
    if(self = [super init]){
        self.locker =  [[LYUMutexLock alloc] init];
    }
    return self;
}

- (void)executeTask:(LYULockTask)task
{
    [self executeTask:task lockType:LYULockTypeMutex];
}

- (void)executeTask:(LYULockTask)task lockType:(LYULockType)type
{
    switch (type) {
            case LYULockTypeOs_Unfair_Lock:
            if(@available(iOS 10.0, *)){
                if(!_locker || [self.locker isMemberOfClass:[LYUOSUnfairLock class]] ){
                    self.locker = nil;
                    self.locker = [[LYUOSUnfairLock alloc] init];
                }
            }
          
            break;
            
            case LYULockTypeMutex:
            if(!_locker || [self.locker isMemberOfClass:[LYUMutexLock class]] ){
                self.locker = nil;
                self.locker = [[LYUMutexLock alloc] init];
            }
            break;
            
            case LYULockTypeRecursiveMutex:
            if(!_locker || [self.locker isMemberOfClass:[LYURecursiveMutexLock class]] ){
                self.locker = nil;
                self.locker = [[LYURecursiveMutexLock alloc] init];
            }
            break;
            
            case LYULockTypeCondition:
            if(!_locker || [self.locker isMemberOfClass:[LYUConditionLock class]] ){
                self.locker = nil;
                self.locker = [[LYUConditionLock alloc] init];
            }
            break;
           
            case LYULockTypeSpin:
            if(!_locker || [self.locker isMemberOfClass:[LYUSpinLock class]] ){
                self.locker = nil;
                self.locker = [[LYUSpinLock alloc] init];
            }
            break;
    }
    
    [self.locker lock];
    [self.locker unlock];
    
}

@end
