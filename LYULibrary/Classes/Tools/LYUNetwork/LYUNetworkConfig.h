//
//  LYUNetworkConfig.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/6/21.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#ifndef LYUNetworkConfig_h
#define LYUNetworkConfig_h


#import <UIKit/UIKit.h>

#define ServiceCount 3

#define BulidService LYUService0
#define BulidServiceEnvironment LYUServiceEnvironmentTest
#define RequestTimeoutInterval 8



typedef NS_ENUM(NSUInteger, LYUServiceType) {
    LYUService0,
    LYUService1,
    LYUService2,
};


typedef NS_ENUM(NSUInteger, LYUServiceEnvironment) {
    LYUServiceEnvironmentTest,
    LYUServiceEnvironmentDevelop,
    LYUServiceEnvironmentRelease,
};


typedef NS_ENUM(NSUInteger, LYUNetworkRequestType) {
    LYUNetworkRequestTypeGET,
    LYUNetworkRequestTypePOST,
};




typedef NS_ENUM(NSUInteger, LYUNetworkTaskError) {
    LYUNetworkTaskSuccess = 1,
    LYUNetworkTaskErrorTimeOut = 101,
    LYUNetworkTaskErrorCannotConnectedToInternet = 102,
    LYUNetworkTaskErrorCanceled = 103,
    LYUNetworkTaskErrorDefault = 104,
    LYUNetworkTaskErrorNoData = 105,
    LYUNetworkTaskErrorNoMoreData = 106
};



static NSError *LYUError(NSString *domain, NSInteger code) {
    return [NSError errorWithDomain:domain code:code userInfo:nil];
}

static NSString *LYUNoDataErrorNotice = @"这里什么也没有~";
static NSString *LYUNetworkErrorNotice = @"当前网络差, 请检查网络设置~";
static NSString *LYUTimeoutErrorNotice = @"请求超时了~";
static NSString *LYUDefaultErrorNotice = @"请求失败了~";
static NSString *LYUNoMoreDataErrorNotice = @"没有更多了~";

typedef void(^LYUNetworkTaskCompletionHander)(NSError *error,NSDictionary *result);





#endif /* LYUNetworkConfig_h */
