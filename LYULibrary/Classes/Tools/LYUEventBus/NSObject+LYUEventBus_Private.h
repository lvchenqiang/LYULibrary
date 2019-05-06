//
//  NSObject+LYUEventBus_Private.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/5/6.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYUDisposeBag.h"


NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LYUEventBus_Private)
/**
 释放池
 */
@property (strong, nonatomic, readonly) LYUDisposeBag * eb_disposeBag;

@end

NS_ASSUME_NONNULL_END
