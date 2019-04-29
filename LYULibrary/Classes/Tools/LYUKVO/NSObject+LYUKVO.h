//
//  NSObject+LYUKVO.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/4/29.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYUKVOInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LYUKVO)
- (void)lyu_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(LYUKeyValueObservingOptions)options context:(nullable void *)context handBlock:(LYUKVOBlock)handBlock;
@end

NS_ASSUME_NONNULL_END
