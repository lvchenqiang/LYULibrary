//
//  LYUNetworkCacheManager.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/6/21.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "LYUNetworkCacheManager.h"

#define ValidTimeInterval 60*60

@interface LYUNetworkCache ()

@property (strong, nonatomic) id data;
@property (nonatomic) NSTimeInterval cacheTime;
@property (nonatomic) NSUInteger validTimeInterval;

@end

@implementation LYUNetworkCache

+ (instancetype)cacheWithData:(id)data {
    return [self cacheWithData:data validTimeInterval:ValidTimeInterval];
}

+ (instancetype)cacheWithData:(id)data validTimeInterval:(NSUInteger)interterval {
    
    LYUNetworkCache *cache = [LYUNetworkCache new];
    cache.data = data;
    cache.cacheTime = [[NSDate date] timeIntervalSince1970];
    cache.validTimeInterval = interterval > 0 ? interterval : ValidTimeInterval;
    return cache;
}

- (BOOL)isValid {
    if (self.data) {
        return [[NSDate date] timeIntervalSince1970] - self.cacheTime < self.validTimeInterval;
    }
    return NO;
}

@end


#pragma mark - LYUNetworkCacheManager

@interface LYUNetworkCacheManager ()
@property (strong, nonatomic) NSCache *cache;
@end



@implementation LYUNetworkCacheManager

+ (instancetype)sharedManager {
    static LYUNetworkCacheManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedManager = [[super allocWithZone:NULL] init];
        [sharedManager configuration];
    });
    return sharedManager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedManager];
}

- (void)configuration {
    
    self.cache = [NSCache new];
    self.cache.totalCostLimit = 1024 * 1024 * 20;
}

#pragma mark - Interface

- (void)setObjcet:(LYUNetworkCache *)object forKey:(id)key {
    [self.cache setObject:object forKey:key];
}

- (void)removeObejectForKey:(id)key {
    [self.cache removeObjectForKey:key];
}

- (LYUNetworkCache *)objcetForKey:(id)key {
    
    return [self.cache objectForKey:key];
}


@end
