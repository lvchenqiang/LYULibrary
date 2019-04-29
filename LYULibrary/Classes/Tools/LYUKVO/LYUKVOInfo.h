//
//  LYUKVOInfo.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/4/29.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_OPTIONS(NSUInteger,LYUKeyValueObservingOptions) {
   LYUKeyValueObservingOptionNew = 0x01,
   LYUKeyValueObservingOptionOld = 0x02,
};

typedef void(^LYUKVOBlock)(NSObject *observer,NSString *keyPath,id oldValue ,id newValue);


NS_ASSUME_NONNULL_BEGIN

@interface LYUKVOInfo : NSObject

@property (nonatomic, weak) NSObject *observer;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, assign)LYUKeyValueObservingOptions options;
@property (nonatomic, copy) LYUKVOBlock handBlock;


- (instancetype)initWithObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(LYUKeyValueObservingOptions)options handBlock:(LYUKVOBlock)handBlock;
@end

NS_ASSUME_NONNULL_END
