//
//  LYUBacktraceLogger.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/3/30.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYUBacktraceLogger : NSObject
+ (NSString *)lyu_backtraceOfAllThread;
+ (NSString *)lyu_backtraceOfMainThread;
+ (NSString *)lyu_backtraceOfCurrentThread;
+ (NSString *)lyu_backtraceOfNSThread:(NSThread *)thread;

+ (void)lyu_logMain;
+ (void)lyu_logCurrent;
+ (void)lyu_logAllThread;
@end

NS_ASSUME_NONNULL_END
