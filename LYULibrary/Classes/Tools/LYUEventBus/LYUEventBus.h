//
//  LYUEventBus.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/4/29.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYUEventTypes.h"
#import "NSString+LYUEvent.h"


NS_ASSUME_NONNULL_BEGIN


@class LYUEventSubscriberMaker;


@interface LYUEventBus <EventType> : NSObject
/**
 单例
 */
@property (class,readonly) LYUEventBus * shared;


/**
 注册监听事件,点语法
 
 如果需要监听系统的通知，请监听NSNotification这个类，如果要监听通用的事件，请监听QTJsonEvent
 */
@property (readonly, nonatomic) LYUEventSubscriberMaker<EventType> *(^on)(Class eventClass);


/**
 注册监听事件
 
 如果需要监听系统的通知，请监听NSNotification这个类，如果要监听通用的事件，请监听QTJsonEvent
 */
- (LYUEventSubscriberMaker<EventType> *)on:(Class)eventClass;


/**
 发布Event,等待event执行结束
 */
- (void)dispatch:(id<LYUEvent>)event;

/**
 异步到eventbus内部queue上dispath
 */
- (void)dispatchOnBusQueue:(id<LYUEvent>)event;

/**
 异步到主线程dispatch
 */
- (void)dispatchOnMain:(id<LYUEvent>)event;


@end

NS_ASSUME_NONNULL_END
