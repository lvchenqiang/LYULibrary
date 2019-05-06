//
//  LYUEventTypes.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/5/6.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>
# pragma mark  LYUEvent---protocol

@protocol LYUEvent <NSObject>

@optional
/**
 事件的名称
 
 @note: 有些类在运行时是子类，用这个强制返回父类
 */
+ (Class)eventClass;

/**
 事件的二级类型
 */
- (NSString *)eventSubType;

@end


# pragma mark  LYUEventToken ----protocol
@protocol LYUEventToken <NSObject>

/**
 释放当前的监听
 */
- (void)dispose;

@end


@interface LYUEventSubscriberMaker<Value> : NSObject

typedef void (^LYUEventNextBlock)(Value event) NS_SWIFT_UNAVAILABLE("");

/**
 事件触发的回调
 */
- (id<LYUEventToken>)next:(LYUEventNextBlock)hander;

/**
 监听的队列，设置了监听队列后，副作用事件的监听会变成异步
 */
- (LYUEventSubscriberMaker<Value> *)atQueue:(dispatch_queue_t)queue;

/**
 在对象释放的时候，释放监听
 */
- (LYUEventSubscriberMaker<Value> *)freeWith:(id)object;

/**
 二级事件，这个操作符可以多次使用
 
 举个例子：[LYUEventBus shared].on(LYUEvent.class).ofSubType(@"Login").ofSubType(@"Logout")
 
 表示同时监听LYUEvent下面的id为Login和Logout事件
 */
- (LYUEventSubscriberMaker<Value> *)ofSubType:(NSString *)subType;


@property (readonly, nonatomic) LYUEventSubscriberMaker<Value> *(^atQueue)(dispatch_queue_t);

@property (readonly, nonatomic) LYUEventSubscriberMaker<Value> *(^ofSubType)(NSString *);

@property (readonly, nonatomic) LYUEventSubscriberMaker<Value> *(^freeWith)(id);


@end
