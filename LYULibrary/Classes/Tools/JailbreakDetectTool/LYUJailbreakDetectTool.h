//
//  LYUJailbreakDetectTool.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/4/23.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYUJailbreakDetectTool : NSObject
/**
 * 检查当前设备是否已经越狱。
 */
+ (BOOL)detectCurrentDeviceIsJailbroken;

@end

NS_ASSUME_NONNULL_END
