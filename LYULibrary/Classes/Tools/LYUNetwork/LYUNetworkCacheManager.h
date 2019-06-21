//
//  LYUNetworkCacheManager.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/6/21.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYUNetworkCache : NSObject
+ (instancetype)cacheWithData:(id)data;
+ (instancetype)cacheWithData:(id)data validTimeInterval:(NSUInteger)interterval;

- (id)data;
- (BOOL)isValid;
@end


@interface LYUNetworkCacheManager : NSObject
+ (instancetype)sharedManager;
- (void)removeObejectForKey:(id)key;
- (void)setObjcet:(LYUNetworkCache *)object forKey:(id)key;
- (LYUNetworkCache *)objcetForKey:(id)key;
@end

NS_ASSUME_NONNULL_END
