//
//  LYUMutexLock.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/3/30.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "LYUMutexLock.h"
#import <pthread.h>
@interface LYUMutexLock ()
@property (assign, nonatomic) pthread_mutex_t mutex;
@end

@implementation LYUMutexLock

- (instancetype)init
{
    if(self = [super init ]){
        pthread_mutex_init(&_mutex, nil);
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
