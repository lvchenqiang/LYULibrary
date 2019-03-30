//
//  LYURecursiveMutexLock.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/3/30.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYULockProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYURecursiveMutexLock : NSObject<LYULockProtocol>

- (void)lock;
- (void)unlock;

@end

NS_ASSUME_NONNULL_END
