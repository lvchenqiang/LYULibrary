//
//  LYUConditionLock.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/3/30.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYULockProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYUConditionLock : NSObject<LYULockProtocol>
- (void)lock;  // 加锁
- (void)unlock; ///解锁
- (void)wait; ///等待(相当于放过此处的加锁) 允许下个执行可以拿到锁
- (void)signal;///唤醒等待
@end

NS_ASSUME_NONNULL_END
