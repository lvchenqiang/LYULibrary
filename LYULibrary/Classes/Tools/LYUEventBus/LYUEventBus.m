//
//  LYUEventBus.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/4/29.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "LYUEventBus.h"
#import "LYUEventBusCollection.h"


#import <pthread.h>
#import <objc/runtime.h>

#import "NSString+LYUEvent.h"
#import "NSNotification+LYUEvent.h"
#import "NSObject+LYUEventBus_Private.h"


static inline NSString * __generateUnqiueKey(Class<LYUEvent> cls,NSString * eventType){
    Class targetClass = [cls respondsToSelector:@selector(eventClass)] ? [cls eventClass] : cls;
    if (eventType) {
        return [NSString stringWithFormat:@"%@_of_%@",eventType,NSStringFromClass(targetClass)];
    }else{
        return NSStringFromClass(targetClass);
    }
}

/**
 内存中保存的监听者
 */
@interface LYUEventSubscriberMaker()

- (instancetype)initWithEventBus:(LYUEventBus *)eventBus
                      eventClass:(Class)eventClass;

@property (strong, nonatomic) Class eventClass;

@property (strong, nonatomic) NSObject * lifeTimeTracker;

@property (strong, nonatomic) dispatch_queue_t queue;

// 存储监听事件的的类型
@property (strong, nonatomic) NSMutableArray * eventSubTypes;

@property (strong, nonatomic) LYUEventBus * eventBus;

@property (copy, nonatomic) void(^hander)(__kindof NSObject *);

@end


/**
 保存的监听者信息
 */
@interface _LYUEventSubscriber: NSObject<LYUEventBusContainerValue>

@property (strong, nonatomic) Class eventClass;

@property (copy, nonatomic) void (^handler)(__kindof NSObject *);

@property (strong, nonatomic) dispatch_queue_t queue;

@property (copy, nonatomic) NSString * uniqueId;

@end

@implementation _LYUEventSubscriber

- (NSString *)valueUniqueId{
    return self.uniqueId;
}

@end





/**
 返回可以取消的token
 */
@interface _LYUEventToken: NSObject<LYUEventToken>

@property (copy, nonatomic) NSString * uniqueId;

@property (copy, nonatomic) void(^onDispose)(NSString * uniqueId);

@property (assign, nonatomic) BOOL isDisposed;

@end

@implementation _LYUEventToken

- (instancetype)initWithKey:(NSString *)uniqueId{
    if (self = [super init]) {
        _uniqueId = uniqueId;
        _isDisposed = NO;
    }
    return self;
}

- (void)dispose{
    @synchronized(self){
        if (_isDisposed) {
            return;
        }
        _isDisposed = YES;
    }
    if (self.onDispose) {
        self.onDispose(self.uniqueId);
    }
}
@end

/**
 组合token
 */
@interface _LYUComposeToken: NSObject <LYUEventToken>

- (instancetype)initWithTokens:(NSArray<_LYUEventToken *> *)tokens;

@property (assign, nonatomic) BOOL isDisposed;

@property (strong, nonatomic) NSArray<_LYUEventToken *> * tokens;

@end

@implementation _LYUComposeToken

- (instancetype)initWithTokens:(NSArray<_LYUEventToken *> *)tokens{
    if (self = [super init]) {
        _tokens = tokens;
        _isDisposed = NO;
    }
    return self;
}

- (void)dispose{
    @synchronized(self){
        if (_isDisposed) {
            return;
        }
        _isDisposed = YES;
    }
    for (_LYUEventToken * token in self.tokens) {
        [token dispose];
    }
}

@end




@interface LYUEventBus ()
{
     pthread_mutex_t  _accessLock;
}
@property (copy, nonatomic) NSString * prefix;

@property (strong, nonatomic) LYUEventBusCollection * collection;

@property (strong, nonatomic) dispatch_queue_t publishQueue;

@property (strong, nonatomic) NSMutableDictionary * notificationTracker;

@end

@implementation LYUEventBus



# pragma mark  public methods

- (void)dispatch:(id<LYUEvent>)event
{
    if (!event) {
        return;
    }
    NSString * eventSubType = [event respondsToSelector:@selector(eventSubType)] ? [event eventSubType] : nil;
    if (eventSubType) {
        //二级事件
        NSString * key = __generateUnqiueKey(event.class, eventSubType);
        [self _publishKey:key event:event];
    }
    
    //一级事件
    NSString * key = __generateUnqiueKey(event.class, nil);
    [self _publishKey:key event:event];
}

- (void)dispatchOnMain:(id<LYUEvent>)event{
    if ([NSThread isMainThread]) {
        [self dispatch:event];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dispatch:event];
        });
    }
}

- (void)dispatchOnBusQueue:(id<LYUEvent>)event{
    dispatch_async(self.publishQueue, ^{
        [self dispatch:event];
    });
}

# pragma mark  private methods

- (void)_publishKey:(NSString *)eventKey event:(NSObject *)event{
    NSString * groupId = [self.prefix stringByAppendingString:eventKey];
    NSArray * subscribers = [self.collection objectsForKey:groupId];
    if (!subscribers || subscribers.count == 0) {
        return;
    }
    for (_LYUEventSubscriber * subscriber in subscribers) {
        if (subscriber.queue) { //异步分发
            dispatch_async(subscriber.queue, ^{
                if (subscriber.handler) {
                    subscriber.handler(event);
                }
            });
        }else{ //同步分发
            if (subscriber.handler) {
                subscriber.handler(event);
            }
        }
        
    }
}


- (id<LYUEventToken>)_createNewSubscriber:(LYUEventSubscriberMaker *)maker{
    if (!maker.hander) {
        return nil;
    }
    if (maker.eventSubTypes.count == 0) {//一级事件
        _LYUEventToken * token = [self _addSubscriberWithMaker:maker eventType:nil];
        return token;
    }
    NSMutableArray * tokens = [[NSMutableArray alloc] init];
    for (NSString * eventType in maker.eventSubTypes) {
        _LYUEventToken * token = [self _addSubscriberWithMaker:maker eventType:eventType];
        [tokens addObject:token];
    }
    _LYUComposeToken * token = [[_LYUComposeToken alloc] initWithTokens:tokens];
    return token;
}


- (_LYUEventToken *)_addSubscriberWithMaker:(LYUEventSubscriberMaker *)maker eventType:(NSString *)eventType{
    __weak typeof(self) weakSelf = self;
    NSString * eventKey = __generateUnqiueKey(maker.eventClass, eventType);
    NSString * groupId = [self.prefix stringByAppendingString:eventKey];
    NSString * uniqueId = [groupId stringByAppendingString:@([NSDate date].timeIntervalSince1970).stringValue];
    _LYUEventToken * token = [[_LYUEventToken alloc] initWithKey:uniqueId];
    BOOL isCFNotifiction = (maker.eventClass == [NSNotification class]);
    if (eventType && isCFNotifiction) {
        [self _addNotificationObserverIfNeeded:eventType];
    }
    token.onDispose = ^(NSString *uniqueId) {
        __strong typeof(self) strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        BOOL empty = [strongSelf.collection removeUniqueId:uniqueId ofKey:groupId];
        if (empty && isCFNotifiction) {
            [strongSelf _removeNotificationObserver:eventType];
        }
    };
    //创建监听者
    _LYUEventSubscriber * subscriber = [[_LYUEventSubscriber alloc] init];
    subscriber.queue = maker.queue;
    subscriber.handler = maker.hander;
    subscriber.uniqueId = uniqueId;
    if (maker.lifeTimeTracker) {
        [maker.lifeTimeTracker.eb_disposeBag addToken:token];
    }
    [self.collection addObject:subscriber forKey:groupId];
    return token;
}

- (void)_addNotificationObserverIfNeeded:(NSString *)name{
    if (!name) { return; }
    [self lockAndDo:^{
        if ([self.notificationTracker objectForKey:name]) {
            return;
        }
        [self.notificationTracker setObject:@(1) forKey:name];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:name object:nil];
    }];
}

- (void)_removeNotificationObserver:(NSString *)name{
    if (!name) { return; }
    [self lockAndDo:^{
        [self.notificationTracker removeObjectForKey:name];
        @try{
            [[NSNotificationCenter defaultCenter] removeObserver:self name:name object:nil];
        }@catch(NSException * exception){
        }
    }];
}

- (void)receiveNotification:(NSNotification *)notificaion{
    [self dispatch:notificaion];
}


+ (instancetype)shared{
    static LYUEventBus * _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LYUEventBus alloc] init];
    });
    return _instance;
}

- (instancetype)init{
    if (self = [super init]) {
        _prefix = @([[NSDate date] timeIntervalSince1970]).stringValue;
        _collection = [[LYUEventBusCollection alloc] init];
        _publishQueue = dispatch_queue_create("com.eventbus.publish.queue", DISPATCH_QUEUE_SERIAL);
        _notificationTracker = [[NSMutableDictionary alloc] init];
        
        // 初始化属性
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
        // 初始化锁
        pthread_mutex_init(&(_accessLock), &attr);
        // 销毁属性
        pthread_mutexattr_destroy(&attr);
        
        
    }
    return self;
}

- (void)lockAndDo:(void(^)(void))block{
    @try{
        pthread_mutex_lock(&_accessLock);
        block();
    }@finally{
        pthread_mutex_unlock(&_accessLock);
    }
}


/// 属性
- (LYUEventSubscriberMaker<id> *(^)(Class eventClass))on{
    return ^LYUEventSubscriberMaker *(Class eventClass){
        return [[LYUEventSubscriberMaker alloc] initWithEventBus:self
                                                     eventClass:eventClass];
    };
}

/// 方法
- (LYUEventSubscriberMaker<id> *)on:(Class)eventClass{
    return [[LYUEventSubscriberMaker alloc] initWithEventBus:self eventClass:eventClass];
}


@end



@implementation LYUEventSubscriberMaker

- (instancetype)initWithEventBus:(LYUEventBus *)eventBus
                      eventClass:(Class)eventClass{
    if (self = [super init]) {
        _eventBus = eventBus;
        _eventClass = eventClass;
        _queue = nil;
    }
    return self;
}
# pragma mark  public methods
- (id<LYUEventToken>)next:(LYUEventNextBlock)hander{
    return self.next(hander);
}

- (LYUEventSubscriberMaker *)atQueue:(dispatch_queue_t)queue{
    return self.atQueue(queue);
}

- (LYUEventSubscriberMaker *)freeWith:(id)object{
    return self.freeWith(object);
}

- (LYUEventSubscriberMaker *)ofSubType:(NSString *)eventType{
    return self.ofSubType(eventType);
}


#pragma mark - getter

- (NSMutableArray *)eventSubTypes{
    if (!_eventSubTypes) {
        _eventSubTypes = [[NSMutableArray alloc] init];
    }
    return _eventSubTypes;
}

- (id<LYUEventToken>(^)(void(^)(id event)))next{
    return ^id<LYUEventToken>(void(^hander)(__kindof NSObject * event)){
        self.hander = hander;
        return [self.eventBus _createNewSubscriber:self];
    };
}

- (LYUEventSubscriberMaker<id> *(^)(id))freeWith{
    return ^LYUEventSubscriberMaker *(id lifeTimeTracker){
        self.lifeTimeTracker = lifeTimeTracker;
        return self;
    };
}

- (LYUEventSubscriberMaker<id> *(^)(dispatch_queue_t))atQueue{
    return ^LYUEventSubscriberMaker *(dispatch_queue_t queue){
        self.queue = queue;
        return self;
    };
}

- (LYUEventSubscriberMaker<id> *(^)(NSString *))ofSubType{
    return ^LYUEventSubscriberMaker *(NSString * eventType){
        if (!eventType) {
            return self;
        }
        @synchronized(self) {
            [self.eventSubTypes addObject:eventType];
        }
        return self;
    };
}

@end
