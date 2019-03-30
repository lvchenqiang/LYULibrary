//
//  LYUUserCenter.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/3/29.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "LYUUserCenter.h"
@interface LYUUserCenter()
{
    // 定义一个并发队列
    dispatch_queue_t concurrent_queue;
    
    // 用户数据中心, 可能多个线程需要数据访问
    NSMutableDictionary *userCenterDic;
}

@end

@implementation LYUUserCenter

- (id)init
{
    self = [super init];
    if (self) {
        // 通过宏定义 DISPATCH_QUEUE_CONCURRENT 创建一个并发队列
        concurrent_queue = dispatch_queue_create("read_write_queue", DISPATCH_QUEUE_CONCURRENT);
        // 创建数据容器
        userCenterDic = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (id)objectForKey:(NSString *)key
{
    __block id obj = nil;
    // 同步读取指定数据
    dispatch_sync(concurrent_queue, ^{
        obj = [self->userCenterDic objectForKey:key];
    });
    
    return obj;
}

- (void)setObject:(id)obj forKey:(NSString *)key
{
    // 异步栅栏调用设置数据
    dispatch_barrier_async(concurrent_queue, ^{
        [self->userCenterDic setObject:obj forKey:key];
    });
}


@end
