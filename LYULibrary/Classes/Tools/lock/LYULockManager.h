//
//  LYULockManager.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/3/30.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LYULockType) {
    LYULockTypeOs_Unfair_Lock, /// default 低级锁  互斥锁(等待即休眠)
    LYULockTypeMutex, /// 互斥锁(等待即休眠)
    LYULockTypeRecursiveMutex, // 递归锁 允许同一个线程对一把锁进行重复加锁
    LYULockTypeCondition,  //条件锁 基于互斥锁实现
    LYULockTypeSpin,  //  仿自旋锁 (实现并不是自旋锁) 自旋锁:等待即死等 一直消耗cpu资源适合轻量级操作
 };

typedef void (^LYULockTask)(void);
@interface LYULockManager : NSObject

/**
 在当前线程执行一个任务
 */
- (void)executeTask:(LYULockTask)task;

/**
 在当前子线程执行一个任务
 */
- (void)executeTask:(LYULockTask)task lockType:(LYULockType)type;

@end

NS_ASSUME_NONNULL_END
