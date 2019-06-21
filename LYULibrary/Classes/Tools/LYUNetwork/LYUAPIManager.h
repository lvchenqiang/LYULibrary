//
//  LYUAPIManager.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/6/21.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LYUNetworkConfig.h"
#import "LYUUploadFile.h"


#pragma mark - KCAPIConfiguration

typedef void(^LYUNetworkTaskProgressHandler)(CGFloat progress);

@interface LYURequestConfiguration : NSObject

@property (nonatomic, copy) NSString *urlPath;
@property (nonatomic, strong) NSDictionary *requestParameters;

@property (nonatomic, strong) NSDictionary *requestHeader;
@property (nonatomic, assign) LYUNetworkRequestType requestType;
@end

@interface LYUTaskConfiguration : LYURequestConfiguration

@property (nonatomic, strong) Class deserializeClass;
@property (nonatomic, copy) NSString *deserializePath;

@end

@interface LYUDataTaskConfiguration : LYUTaskConfiguration

@property (nonatomic, assign) NSTimeInterval cacheValidTimeInterval;

@end

@interface LYUUploadTaskConfiguration : LYUTaskConfiguration

@property (nonatomic, strong) NSArray<LYUUploadFile *> * uploadContents;

@end

@interface LYUAPIManager : NSObject
- (void)cancelAllTask;
- (void)cancelTask:(NSNumber *)taskIdentifier;

- (NSURLSessionDataTask *)dataTaskWithConfiguration:(LYUDataTaskConfiguration *)config completionHandler:(LYUNetworkTaskCompletionHander)completionHandler;

- (NSNumber *)dispatchDataTaskWithConfiguration:(LYUDataTaskConfiguration *)config completionHandler:(LYUNetworkTaskCompletionHander)completionHandler;

- (NSNumber *)dispatchUploadTaskWithConfiguration:(LYUUploadTaskConfiguration *)config progressHandler:(LYUNetworkTaskProgressHandler)progressHandler completionHandler:(LYUNetworkTaskCompletionHander)completionHandler;

@end
