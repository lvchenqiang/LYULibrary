//
//  LYURecursiveMutexLock.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/3/30.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "LYURecursiveMutexLock.h"
#import <pthread.h>

@interface LYURecursiveMutexLock()
@property (assign, nonatomic) pthread_mutex_t mutex;
@end

@implementation LYURecursiveMutexLock

- (instancetype)init
{
    if(self = [super init]){
        // 递归锁：允许同一个线程对一把锁进行重复加锁
        
        // 初始化属性
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        // 初始化锁
        pthread_mutex_init(&(_mutex), &attr);
        // 销毁属性
        pthread_mutexattr_destroy(&attr);
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

- (void)dealloc{
    pthread_mutex_destroy(&_mutex);
}
@end
