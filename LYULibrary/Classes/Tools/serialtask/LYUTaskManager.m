//
//  LYUTaskManager.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/4/4.
//  Copyright © 2019 Micah. All rights reserved.
//

#import "LYUTaskManager.h"
#import <pthread.h>
#import "LYUTask.h"
#import "UIView+Task.h"

@interface LYUTaskManager ()
/*
 lock
 */
@property (assign, nonatomic) pthread_mutex_t mutex;
/*
 * callback
 */
@property (nonatomic, strong) NSMutableArray *tasks;



@end

dispatch_semaphore_t semaphore_p;

@implementation LYUTaskManager

static LYUTaskManager * _sharedManager = nil;



/// 添加task
- (void)addTask:(LYUTaskBlock)task
{
    [[LYUTaskManager sharedManager] addTask:task key:[LYUTaskManager sharedManager].tasks.count+1];
}


/// 添加task
- (void)addTask:(LYUTaskBlock)task key:(NSInteger )taskIdentifier{
    [[LYUTaskManager sharedManager] addTask:task key:taskIdentifier async:false];
}


- (void)addTask:(LYUTaskBlock)task async:(BOOL)async
{
     [[LYUTaskManager sharedManager] addTask:task key:[LYUTaskManager sharedManager].tasks.count+1 async:async];
}


- (void)addTask:(LYUTaskBlock)task key:(NSInteger)taskIdentifier async:(BOOL)async
{
    
    LYUTask * taskSource = [[LYUTask alloc] initWithTask:task TaskIdentifier:taskIdentifier];
    taskSource.async = async;
    pthread_mutex_lock(&_mutex);
    NSLog(@"加锁 addTask ---%@", [NSThread currentThread]);
    [self.tasks addObject:taskSource];
    pthread_mutex_unlock(&_mutex);
    NSLog(@"解锁 addTask ");
    [self checkTask_p]; // 检查并启动任务
    
}

/// 移除task
- (void)removeTaskForId:(NSInteger )taskIdentifier
{
  
    pthread_mutex_lock(&_mutex);
    NSLog(@"加锁  removeTaskForId");
    NSLog(@"%@",[LYUTaskManager sharedManager].tasks);
    for(int i =0; i< [LYUTaskManager sharedManager].tasks.count; i++)
    {
        LYUTask * task = [LYUTaskManager sharedManager].tasks[i];
        if(task.taskIdentifier == taskIdentifier){
            [[LYUTaskManager sharedManager].tasks removeObjectAtIndex:i];
            break;
        }
    }
    pthread_mutex_unlock(&_mutex);
     NSLog(@"解锁  removeTaskForId");
}

/// 检测任务
- (void)checkTask_p{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    dispatch_semaphore_wait(semaphore_p, DISPATCH_TIME_FOREVER);
    
    if([LYUTaskManager sharedManager].tasks.count){ /// 当前任务队列存在任务
        bool taskRun = true; /// 任务是否可以执行
        LYUTask * currentTask = nil;
//        pthread_mutex_lock(&_mutex);
         NSLog(@"加锁  checkTask_p");
        currentTask = [LYUTaskManager sharedManager].tasks.firstObject;
//        pthread_mutex_unlock(&_mutex);
         NSLog(@"解锁 checkTask_p");
        
        if(currentTask.status == LYUTaskStatusExecuting){
             dispatch_semaphore_signal(semaphore_p);
            return;
        }
        if([LYUTaskManager sharedManager].taskExecuting){
            taskRun = [LYUTaskManager sharedManager].taskExecuting(currentTask.taskIdentifier);
        }
       
        
        
        if(currentTask && taskRun){ /// 任务存在
            
            
            NSLog(@"currentTask:%@",currentTask);
            
                NSLog(@"任务执行准备");
                /// 线程休眠
                if(currentTask.async){
                    
                }
                
                if(currentTask.status == LYUTaskStatusDefault){
                     currentTask.taskBlock();
                    if(currentTask.async){
                        currentTask.status = LYUTaskStatusExecuting;
                    }else{
                        currentTask.status = LYUTaskStatusComplete;
                    }
                    
                }
               
                if((currentTask.async && currentTask.status == LYUTaskStatusComplete)){ /// 异步等待主动标识完成
                    [self removeTask:currentTask];
                    [[LYUTaskManager sharedManager] checkTask_p];
                    /// 或者外界主动触发
                }else if(currentTask.async == false){ /// 同步即刻执行下一个任务
                    [self removeTask:currentTask];
                    [[LYUTaskManager sharedManager] checkTask_p];
                }
                
                /// 唤醒线程
                if(currentTask.async){
                   
                }
                 NSLog(@"任务执行结束");
           
            
        }
        
       
   
        
    }else{
       
    }
    
 dispatch_semaphore_signal(semaphore_p);
        
         });
    
}




/// 启动任务
- (void)startTasks:(BOOL)async
{
    NSLog(@"%@",self.tasks);
    /// 检查任务的执行
    if(async){
        LYUTask * currentTask = nil;
        pthread_mutex_lock(&_mutex);
        NSLog(@"加锁  checkTask_p");
        currentTask = [LYUTaskManager sharedManager].tasks.firstObject;
        pthread_mutex_unlock(&_mutex);
        currentTask.status =  LYUTaskStatusComplete;
        [[LYUTaskManager sharedManager] checkTask_p];
    }else{
        [[LYUTaskManager sharedManager] checkTask_p];
    }
   
}

- (void)removeTasks
{
    pthread_mutex_lock(&_mutex);
     NSLog(@"加锁 removeTasks");
    [[LYUTaskManager sharedManager].tasks removeAllObjects];
    pthread_mutex_unlock(&_mutex);
     NSLog(@"解锁 removeTasks");
}

- (void)removeTask:(LYUTask *)task{
    /// 移除已执行的任务
    [[LYUTaskManager sharedManager] removeTaskForId:task.taskIdentifier];
    NSLog(@"任务执行结束");
}

///暂停所有的任务
- (void)stopTasks
{
    /// 临时方案
    [LYUTaskManager sharedManager].taskExecuting = ^BOOL(NSInteger taskIdentifier) {
        return false;
    };
}

// MARK:getter/lifecycle
- (NSMutableArray *)tasks
{
    if(_tasks == nil){
        _tasks = [NSMutableArray new];
    }
    return _tasks;
}


+ (NSInteger)LYUTaskGlobalIdentifier
{
    return 0x19999;
}

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[super allocWithZone:NULL] init];
    });
    
    return _sharedManager;
}



// 防止外部调用alloc 或者 new
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [LYUTaskManager sharedManager];
}

// 防止外部调用copy
- (id)copyWithZone:(nullable NSZone *)zone {
    return [LYUTaskManager sharedManager];
}

// 防止外部调用mutableCopy
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [LYUTaskManager sharedManager];
}

- (instancetype)init
{
    if(self = [super init ]){
        
        // 初始化属性
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        // 初始化锁
        pthread_mutex_init(&(_mutex), &attr);
        // 销毁属性
        pthread_mutexattr_destroy(&attr);
        NSLog(@"初始化锁");
        semaphore_p = dispatch_semaphore_create(1);
    }
    return self;
}


- (void)dealloc{
    pthread_mutex_destroy(&_mutex);
    [self removeTasks];
}



@end
