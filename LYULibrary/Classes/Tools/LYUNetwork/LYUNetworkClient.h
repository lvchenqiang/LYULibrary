//
//  LYUNetworkClient.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/6/21.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LYUNetworkConfig.h"
#import "LYUUploadFile.h"


typedef void(^LYUCompletionHandle)(NSURLResponse *response,id responseObject,NSError *error);

@interface LYUNetworkClient : NSObject


+ (instancetype)sharedInstance;

- (NSURLSessionDataTask *)dataTaskWithUrlPath:(NSString *)urlPath
                                  requestType:(LYUNetworkRequestType)requestType
                                       params:(NSDictionary *)params
                                       header:(NSDictionary *)header
                            completionHandler:(LYUCompletionHandle)completionHandler;

- (NSNumber *)uploadDataWithUrlPath:(NSString *)urlPath
                             params:(NSDictionary *)params
                           contents:(NSArray<LYUUploadFile *> *)contents
                             header:(NSDictionary *)header
                    progressHandler:(void(^)(NSProgress *))progressHandler
                  completionHandler:(LYUCompletionHandle)completionHandler;

- (NSNumber *)dispatchTask:(NSURLSessionTask *)task;

- (NSNumber *)dispatchTaskWithUrlPath:(NSString *)urlPath
                          requestType:(LYUNetworkRequestType)requestType
                               params:(NSDictionary *)params
                               header:(NSDictionary *)header
                    completionHandler:(LYUCompletionHandle)completionHandler;

- (void)cancelAllTask;
- (void)cancelTaskWithTaskIdentifier:(NSNumber *)taskIdentifier;


@end

