//
//  LYUService.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/6/21.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "LYUService.h"

@interface LYUServiceX : LYUService
@end

@interface LYUServiceY : LYUService
@end

@interface LYUServiceZ : LYUService
@end



@implementation LYUService

+ (LYUService *)defaultService {
    return [self serviceWithType:LYUService0];
}

+ (LYUService *)serviceWithType:(LYUServiceType)type {
    
    LYUService *service;
    switch (type) {
        case LYUService0: service = [LYUServiceX new];  break;
        case LYUService1: service = [LYUServiceY new];  break;
        case LYUService2: service = [LYUServiceZ new];  break;
    }
    service.type = type;
    service.environment = BulidServiceEnvironment;
    return service;
}

- (NSString *)baseUrl {
    
    switch (self.environment) {
        case LYUServiceEnvironmentTest: return [self testEnvironmentBaseUrl];
        case LYUServiceEnvironmentDevelop: return [self developEnvironmentBaseUrl];
        case LYUServiceEnvironmentRelease: return [self releaseEnvironmentBaseUrl];
    }
}


@end


#pragma mark - LYUServiceX

@implementation LYUServiceX

- (NSString *)testEnvironmentBaseUrl {
    return @"http://127.0.0.1:8080";
}

- (NSString *)developEnvironmentBaseUrl {
    return @"http://127.0.0.1:12345";
}

- (NSString *)releaseEnvironmentBaseUrl {
    return @"https://api.weibo.com/2";
}

@end


#pragma mark - LYUServiceY
@implementation LYUServiceY

- (NSString *)testEnvironmentBaseUrl {
    return @"testEnvironmentBaseUrl_Y";
}

- (NSString *)developEnvironmentBaseUrl {
    return @"developEnvironmentBaseUrl_Y";
}

- (NSString *)releaseEnvironmentBaseUrl {
    return @"releaseEnvironmentBaseUrl_Y";
}

@end


#pragma mark - LYUServiceZ

@implementation LYUServiceZ

- (NSString *)testEnvironmentBaseUrl {
    return @"testEnvironmentBaseUrl_Z";
}

- (NSString *)developEnvironmentBaseUrl {
    return @"developEnvironmentBaseUrl_Z";
}

- (NSString *)releaseEnvironmentBaseUrl {
    return @"releaseEnvironmentBaseUrl_Z";
}
@end

