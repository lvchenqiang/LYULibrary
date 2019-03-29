//
//  LYUPermenantThread.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/3/29.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LYUPermenantThreadTask)(void);

@interface LYUPermenantThread : NSObject

/**
 开启线程
 */
//- (void)run;

/**
 在当前子线程执行一个任务
 */
- (void)executeTask:(LYUPermenantThreadTask)task;

/**
 结束线程
 */
- (void)stop;

@end

