//
//  LYUTaskManager.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/4/4.
//  Copyright © 2019 Micah. All rights reserved.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN


typedef BOOL(^TaskExecuting)(NSInteger );

typedef void(^LYUTaskBlock)(void);


@interface LYUTaskManager : NSObject
/**
 * 标识全局
 */
@property(class, nonatomic, assign, readonly) NSInteger LYUTaskGlobalIdentifier;


/**
 * 当前任务是否可以执行 可以则执行 不可以则等待
 */
@property (nonatomic, copy) TaskExecuting taskExecuting;

/*
 * callback
 */
@property (nonatomic, strong, readonly) NSMutableArray *tasks;

/**
 * 单例方法.
 */
+ (instancetype)sharedManager;



/**
 添加任务

 @param task 任务
 @param async 标识任务是否是异步执行回调结果
 */
- (void)addTask:(LYUTaskBlock)task  async:(BOOL)async;



/**
  添加任务

 @param task 任务
 @param taskIdentifier 标识任务id
 @param async 标识任务是否是异步执行回调结果
 */
- (void)addTask:(LYUTaskBlock)task key:(NSInteger )taskIdentifier  async:(BOOL)async;


/**
 添加任务

 @param task 任务  默认为同步返回执行结果
 */
- (void)addTask:(LYUTaskBlock)task;


/**
 添加任务

 @param task 任务
 @param taskIdentifier 标识任务id
 */
- (void)addTask:(LYUTaskBlock)task key:(NSInteger )taskIdentifier;



/// 移除task
- (void)removeTaskForId:(NSInteger )taskIdentifier;




/// 启动任务
- (void)startTasks:(BOOL)async;


///暂停任务的执行
- (void)stopTasks;

/// 移除当前的所有任务
- (void)removeTasks;


@end

NS_ASSUME_NONNULL_END
