//
//  LYUAppFluecyMonitor.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/3/30.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define SHAREDMONITOR [LYUAppFluecyMonitor sharedMonitor]

@interface LYUAppFluecyMonitor : NSObject
+ (instancetype)sharedMonitor;

- (void)startMonitoring;
- (void)stopMonitoring;

@end

NS_ASSUME_NONNULL_END
