//
//  LYUEventBusCollection.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/5/6.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "LYUEventBusCollection.h"
#include <pthread.h>

@class _LYUEventBusLinkNode;

# pragma mark  _LYUEventBusLinkNode class
@interface _LYUEventBusLinkNode : NSObject
@property (weak, nonatomic) _LYUEventBusLinkNode * previous;

@property (weak, nonatomic) _LYUEventBusLinkNode * next;

@property (strong, nonatomic) id value;

@property (copy, nonatomic) NSString * uniqueId;
@end


@implementation _LYUEventBusLinkNode

- (instancetype)initWithValue:(id)value uniqueId:(NSString *)uniqueId{
    if (self = [super init]) {
        _value = value;
        _uniqueId = uniqueId;
    }
    return self;
}

@end

# pragma mark  _LYUEventBusLinkList class
@interface _LYUEventBusLinkList : NSObject

@property (assign, nonatomic, readonly) BOOL isEmpty;

@property (strong, nonatomic) _LYUEventBusLinkNode * head;

@property (strong, nonatomic) _LYUEventBusLinkNode * tail;

@property (strong, nonatomic) NSMutableDictionary * registeredNodeTable;

@end


@implementation _LYUEventBusLinkList

- (instancetype)initWithNode:(_LYUEventBusLinkNode *)node{
    if (self = [super init]) {
        _head = node;
        _tail = node;
        _registeredNodeTable = [NSMutableDictionary new];
        [_registeredNodeTable setObject:node forKey:node.uniqueId];
    }
    return self;
}

- (BOOL)isEmpty{
    return _head == nil;
}

/**
 删除一个节点
 */
- (void)removeNodeForId:(NSString *)uniqueId{
    //不存在
    if (![_registeredNodeTable objectForKey:uniqueId]) {
        return;
    }
    _LYUEventBusLinkNode * node = [_registeredNodeTable objectForKey:uniqueId];
    if (node == _head) {
        _head = _head.next;
    }
    if (node == _tail) {
        _tail = _tail.previous;
    }
    _LYUEventBusLinkNode * previousNode = node.previous;
    _LYUEventBusLinkNode * nextNode = node.next;
    node.next = nil;
    node.previous = nil;
    previousNode.next = nextNode;
    nextNode.previous = previousNode;
}

- (void)appendNode:(_LYUEventBusLinkNode *)node{
    if (_head == nil) {
        _head = node;
        _tail = node;
        return;
    }
    _LYUEventBusLinkNode * oldNode = [_registeredNodeTable objectForKey:node.uniqueId];
    if (oldNode) {
        [self replaceNode:oldNode withNode:node];
        return;
    }
    _tail.next = node;
    node.previous = _tail;
    _tail = node;
    [_registeredNodeTable setObject:node forKey:node.uniqueId];
}

- (void)replaceNode:(_LYUEventBusLinkNode *)old withNode:(_LYUEventBusLinkNode *)update{
    update.next = old.next;
    update.previous = old.previous;
    old.previous.next = update;
    old.next.previous = update;
    if ([[old uniqueId] isEqualToString:_head.uniqueId]) {
        _head = update;
    }
    if ([old.uniqueId isEqualToString:_tail.uniqueId]) {
        _tail = update;
    }
    [_registeredNodeTable setObject:update forKey:update.uniqueId];
}

- (NSArray *)toArray{
    NSMutableArray * array = [[NSMutableArray alloc] init];
    _LYUEventBusLinkNode * pointer = _head;
    while (pointer != nil) {
        if (pointer.value) {
            [array addObject:pointer.value];
        }
        pointer = pointer.next;
    }
    return [[NSArray alloc] initWithArray:array];
}

- (NSString *)debugDescription
{
    return [NSString stringWithFormat:@"%@",[self toArray]];
}
@end


@interface LYUEventBusCollection()
{
    pthread_mutex_t  _accessLock;
}

@property (strong, nonatomic) NSMutableDictionary<NSString *,_LYUEventBusLinkList *> * linkListTable;//记录key->链表的头

@end

@implementation LYUEventBusCollection

- (instancetype)init{
    if (self = [super init]) {
        _linkListTable = [[NSMutableDictionary alloc] init];
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

- (id)lockAndFetch:(id(^)(void))block{
    id result;
    @try{
        pthread_mutex_lock(&_accessLock);
        result = block();
    }@finally{
        pthread_mutex_unlock(&_accessLock);
    }
    return result;
}



- (void)addObject:(id<LYUEventBusContainerValue>)object forKey:(NSString *)key{
    NSString * nodeUniqueKey = [object valueUniqueId];
    [self lockAndDo:^{
        _LYUEventBusLinkList * linkList = [self.linkListTable objectForKey:key];
        _LYUEventBusLinkNode * updateNode = [[_LYUEventBusLinkNode alloc] initWithValue:object
                                                                             uniqueId:nodeUniqueKey];
        if (!linkList) {
            linkList = [[_LYUEventBusLinkList alloc] initWithNode:updateNode];
            [self.linkListTable setObject:linkList forKey:key];
        }else{
            [linkList appendNode:updateNode];
        }
    }];
}

- (BOOL)removeUniqueId:(NSString *)uniqueId ofKey:(NSString *)key{
    NSNumber * result = [self lockAndFetch:^id{
        _LYUEventBusLinkList * linkList = [self.linkListTable objectForKey:key];
        [linkList removeNodeForId:uniqueId];
        if (linkList.isEmpty) {
            [self.linkListTable removeObjectForKey:key];
        }
        return @(linkList.isEmpty);
    }];
    return result.boolValue;
}

/**
 返回一组值
 */
- (NSArray *)objectsForKey:(NSString *)key{
    NSArray * arrary = [self lockAndFetch:^id{
        _LYUEventBusLinkList * linkList = [self.linkListTable objectForKey:key];
        return linkList.toArray;
    }];
    return arrary;
}

- (NSString *)description
{
    NSMutableString * desc = [NSMutableString string];
    [_linkListTable enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, _LYUEventBusLinkList * _Nonnull obj, BOOL * _Nonnull stop) {
        [desc appendString:[NSString stringWithFormat:@"%@:%@\n",key,[obj toArray]]];
    }];
    return [desc copy];
}

@end
