//
//  LYUAPIManager.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/6/21.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "LYUAPIManager.h"
#import "LYUNetworkClient.h"
#import "LYUNetworkCacheManager.h"
#import "LYUHTTPNetworkTool.h"
#import "YYModel.h"



@implementation LYURequestConfiguration

- (instancetype)init {
    if (self = [super init]) {
        self.requestType = LYUNetworkRequestTypeGET;
    }
    return self;
}

@end

@implementation LYUTaskConfiguration
@end

@implementation LYUDataTaskConfiguration
@end

@implementation LYUUploadTaskConfiguration
@end


@interface LYUAPIManager ()
@property (nonatomic, strong) NSMutableArray<NSNumber *> *loadingTaskIdentifies;

@end

@implementation LYUAPIManager

- (instancetype)init {
    if (self = [super init]) {
        
        self.loadingTaskIdentifies = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    [self cancelAllTask];
}

- (void)cancelAllTask {
    
    for (NSNumber *taskIdentifier in self.loadingTaskIdentifies) {
        [[LYUNetworkClient sharedInstance] cancelTaskWithTaskIdentifier:taskIdentifier];
    }
    [self.loadingTaskIdentifies removeAllObjects];
}

- (void)cancelTask:(NSNumber *)taskIdentifier {
    
    [[LYUNetworkClient sharedInstance] cancelTaskWithTaskIdentifier:taskIdentifier];
    [self.loadingTaskIdentifies removeObject:taskIdentifier];
}



- (NSURLSessionDataTask *)dataTaskWithConfiguration:(LYUDataTaskConfiguration *)config completionHandler:(LYUNetworkTaskCompletionHander)completionHandler {
    
    return [[LYUNetworkClient sharedInstance] dataTaskWithUrlPath:config.urlPath requestType:config.requestType params:config.requestParameters header:config.requestHeader completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        !completionHandler ?: completionHandler([self formatError:error], responseObject);
    }];
}

- (NSNumber *)dispatchDataTaskWithConfiguration:(LYUDataTaskConfiguration *)config completionHandler:(LYUNetworkTaskCompletionHander)completionHandler{
    
    NSString *cacheKey;
    if (config.cacheValidTimeInterval > 0) {
        NSMutableString *mString = [NSMutableString stringWithString:config.urlPath];
        NSMutableArray *requestParameterKeys = [config.requestParameters.allKeys mutableCopy];
        if (requestParameterKeys.count > 1) {
            [requestParameterKeys sortedArrayUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString * _Nonnull obj2) {
                return [obj1 compare:obj2];
            }];
        }
        
        [requestParameterKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            [mString appendFormat:@"&%@=%@",key, config.requestParameters[key]];
        }];
        
        cacheKey = [LYUHTTPNetworkTool lyu_md5String:[mString copy]];
        
        LYUNetworkCache *cache = [[LYUNetworkCacheManager sharedManager] objcetForKey:cacheKey];
        
        if (!cache.isValid) {
            [[LYUNetworkCacheManager sharedManager] removeObejectForKey:cacheKey];
        } else {
            NSLog(@"走cachen内存咯");
            completionHandler ? completionHandler(nil, cache.data) : nil;
            return @-1;
        }
    }
    
    NSMutableArray *taskIdentifier = [NSMutableArray arrayWithObject:@-1];
    taskIdentifier[0] = [[LYUNetworkClient sharedInstance] dispatchTaskWithUrlPath:config.urlPath requestType:config.requestType params:config.requestParameters header:config.requestHeader completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        id result = responseObject;
        NSError *formatError = [self formatError:error];
        if (formatError != nil) {/** 通用错误格式化 */
            
            int code = [result[@"code"] intValue];
            if (code != LYUNetworkTaskSuccess) {
                formatError = LYUError(result[@"msg"] ?: LYUDefaultErrorNotice, code);
            }
        }
        
        if (formatError == nil && config.deserializeClass != nil) {/** 通用json解析 */
            
            NSDictionary *json = responseObject;
            
            LYUNetworkCache *cache = [LYUNetworkCache cacheWithData:responseObject validTimeInterval:config.cacheValidTimeInterval];
            [[LYUNetworkCacheManager sharedManager] setObjcet:cache forKey:cacheKey];
            
            if (config.deserializePath.length > 0) {
                json = [json valueForKeyPath:config.deserializePath];
            }
            if ([json isKindOfClass:[NSDictionary class]]) {
                
                if (json.count > 0) {
                    result = [config.deserializeClass yy_modelWithJSON:json];
                } else {
                    formatError = LYUError(LYUNoDataErrorNotice, LYUNetworkTaskErrorNoData);
                }
            } else if ([json isKindOfClass:[NSArray class]]) {
                
                result = [NSArray yy_modelArrayWithClass:config.deserializeClass json:json];
                if ([result count] == 0) {
                    
                    NSInteger page = [config.requestParameters[@"page"] integerValue];
                    if (page == 0) {
                        formatError = LYUError(LYUNoDataErrorNotice, LYUNetworkTaskErrorNoData);
                    } else {
                        formatError = LYUError(LYUNoMoreDataErrorNotice, LYUNetworkTaskErrorNoMoreData);
                    }
                }
            }
        }
        
        !completionHandler ?: completionHandler(formatError, result);
    }];
    [self.loadingTaskIdentifies addObject:taskIdentifier.firstObject];
    return taskIdentifier.firstObject;
}

- (NSNumber *)dispatchUploadTaskWithConfiguration:(LYUUploadTaskConfiguration *)config progressHandler:(LYUNetworkTaskProgressHandler)progressHandler completionHandler:(LYUNetworkTaskCompletionHander)completionHandler {
    
    NSMutableArray *taskIdentifier = [NSMutableArray arrayWithObject:@-1];
    taskIdentifier[0] = [[LYUNetworkClient sharedInstance] uploadDataWithUrlPath:config.urlPath params:config.requestParameters contents:config.uploadContents header:config.requestHeader progressHandler:^(NSProgress *progress) {
        
        progressHandler ? progressHandler(progress.completedUnitCount * 1.0 / progress.totalUnitCount) : nil;
    } completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSError *formatError = [self formatError:error];
        if (formatError == nil) {
            
            int code = [responseObject[@"code"] intValue];
            if (code != LYUNetworkTaskSuccess) {
                formatError = LYUError(responseObject[@"msg"] ?: LYUDefaultErrorNotice, code);
            }
        }
        !completionHandler ?: completionHandler(formatError, responseObject);
    }];
    [self.loadingTaskIdentifies addObject:taskIdentifier.firstObject];
    return taskIdentifier.firstObject;
}

#pragma mark - Utils

- (NSError *)formatError:(NSError *)error {
    
    if (error != nil) {
        switch (error.code) {
            case NSURLErrorTimedOut: return LYUError(LYUTimeoutErrorNotice, LYUNetworkTaskErrorTimeOut);
            case NSURLErrorCancelled: return LYUError(LYUDefaultErrorNotice, LYUNetworkTaskErrorCanceled);
                
            case NSURLErrorCannotFindHost:
            case NSURLErrorCannotConnectToHost:
            case NSURLErrorNotConnectedToInternet: {
                return LYUError(LYUNetworkErrorNotice, LYUNetworkTaskErrorCannotConnectedToInternet);
            }
                
            default: return LYUError(LYUDefaultErrorNotice, LYUNetworkTaskErrorDefault);
        }
    }
    return error;
}







@end
