//
//  LYUService.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/6/21.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYUNetworkConfig.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LYUServiceProtocol <NSObject>
@optional
- (NSString *)testEnvironmentBaseUrl;
- (NSString *)developEnvironmentBaseUrl;
- (NSString *)releaseEnvironmentBaseUrl;

@end

@interface LYUService : NSObject<LYUServiceProtocol>
@property (nonatomic, assign) LYUServiceType type;
@property (nonatomic, assign) LYUServiceEnvironment environment;

+ (LYUService *)defaultService;
+ (LYUService *)serviceWithType:(LYUServiceType)type;
- (NSString *)baseUrl;



@end

NS_ASSUME_NONNULL_END
