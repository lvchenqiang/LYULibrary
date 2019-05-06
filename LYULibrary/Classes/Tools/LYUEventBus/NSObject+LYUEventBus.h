//
//  NSObject+LYUEventBus.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/5/6.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYUEventTypes.h"

@class LYUEventBus;

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LYUEventBus)

/**
 在EventBus单例shared上监听指定类型的事件，并且跟随self一起取消监听
 */
- (LYUEventSubscriberMaker *)subscribeSharedBus:(Class)eventClass;

/**
 在EventBus单例子监听指定字符串事件
 */
- (LYUEventSubscriberMaker<NSString *> *)subscribeSharedBusOfName:(NSString *)eventName;

/**
 在bus上监听指定类型的事件，并且跟随self一起取消监听
 */
- (LYUEventSubscriberMaker *)subscribe:(Class)eventClass on:(LYUEventBus *)bus;

/**
 在bus上监听指定字符串时间
 */
- (LYUEventSubscriberMaker<NSString *> *)subscribeName:(NSString *)eventName on:(LYUEventBus *)bus;

@end

NS_ASSUME_NONNULL_END
