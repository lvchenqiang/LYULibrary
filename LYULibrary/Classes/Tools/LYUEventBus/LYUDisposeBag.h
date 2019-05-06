//
//  LYUDisposeBag.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/5/6.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYUEventTypes.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYUDisposeBag : NSObject
/**
 增加一个需要释放的token
 */
- (void)addToken:(id<LYUEventToken>)token;
@end

NS_ASSUME_NONNULL_END
