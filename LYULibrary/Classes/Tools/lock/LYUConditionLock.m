//
//  LYUConditionLock.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/3/30.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "LYUConditionLock.h"
#import <pthread.h>
@interface LYUConditionLock()
@property (assign, nonatomic) pthread_mutex_t mutex;
@property (assign, nonatomic) pthread_cond_t cond;

@end

@implementation LYUConditionLock

- (instancetype)init
{
    if(self = [super init]){
        // 初始化属性
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        // 初始化锁
        pthread_mutex_init(&_mutex, &attr);
        // 销毁属性
        pthread_mutexattr_destroy(&attr);
        
        // 初始化条件
        pthread_cond_init(&_cond, NULL);
    }
    return self;
}

- (void)lock
{
     pthread_mutex_lock(&_mutex);
}
- (void)unlock
{
     pthread_mutex_unlock(&_mutex);
}

- (void)wait
{
    // 等待
    pthread_cond_wait(&_cond, &_mutex);
}


//- (void)wait:(NSTimeInterval)timeout{
//    mach_timespec_t ts =
//     pthread_cond_timedwait_relative_np(&_cond, &_mutex, &ts)
//}
- (void)signal
{
    // 信号
    pthread_cond_signal(&_cond);
    // 广播
    //    pthread_cond_broadcast(&_cond);
    
}

- (void)dealloc
{
    pthread_mutex_destroy(&_mutex);
    pthread_cond_destroy(&_cond);
}
@end
