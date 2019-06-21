//
//  LYUNetworkClient.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/6/21.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "LYUNetworkClient.h"
#import "AFNetworking.h"
#import "LYUURLRequestGenerator.h"


@interface LYUNetworkClient ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSURLSessionTask *> *dispathTable;
@property (nonatomic, assign) NSInteger totalTaskCount;
@property (nonatomic, assign) NSInteger errorTaskCount;

@end

static dispatch_semaphore_t lock;

@implementation LYUNetworkClient

+ (instancetype)sharedInstance {
    
    static LYUNetworkClient *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        lock = dispatch_semaphore_create(1);
        sharedInstance = [[super allocWithZone:NULL] init];
    });
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (instancetype)init {
    if (self = [super init]) {
        
        self.dispathTable = [NSMutableDictionary dictionary];
        
        self.sessionManager = [AFHTTPSessionManager manager];
        self.sessionManager.securityPolicy.validatesDomainName = NO;
        self.sessionManager.securityPolicy.allowInvalidCertificates = YES;
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        NSMutableSet *acceptableContentTypes = [NSMutableSet setWithSet:self.sessionManager.responseSerializer.acceptableContentTypes];
        [acceptableContentTypes addObject:@"text/html"];
        [acceptableContentTypes addObject:@"text/plain"];
        self.sessionManager.responseSerializer.acceptableContentTypes = [acceptableContentTypes copy];
        
        // 添加观察 主动切换  因为需求
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceivedSwitchSeriveNotification:) name:@"didReceivedSwitchSeriveNotification" object:nil];
    }
    return self;
}


#pragma mark - Interface

- (NSURLSessionDataTask *)dataTaskWithUrlPath:(NSString *)urlPath requestType:(LYUNetworkRequestType)requestType params:(NSDictionary *)params header:(NSDictionary *)header completionHandler:(LYUCompletionHandle)completionHandler {
    
    NSString *method = (requestType == LYUNetworkRequestTypeGET ? @"GET" : @"POST");
    
    // 根据请求任务 拿到request
    NSMutableURLRequest *request = [[LYUURLRequestGenerator sharedInstance] generateRequestWithUrlPath:urlPath method:method params:params header:header];
    
    // 根据request 拿到task
    __block NSNumber *taskIdentifier;
    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request
                                                           uploadProgress:nil
                                                         downloadProgress:nil
                                                        completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                                            
                                                            self.totalTaskCount += 1;
                                                            
                                                            dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
                                                            [self.dispathTable removeObjectForKey:taskIdentifier];
                                                            dispatch_semaphore_signal(lock);
                                                            
                                                            [self checkSeriveWithTaskError:error];
                                                            
                                                            !completionHandler ?: completionHandler(response, responseObject, error);
                                                            
                                                        }];
    
    taskIdentifier = @(task.taskIdentifier);
    return task;
}

- (NSNumber *)dispatchTaskWithUrlPath:(NSString *)urlPath requestType:(LYUNetworkRequestType)requestType params:(NSDictionary *)params header:(NSDictionary *)header completionHandler:(LYUCompletionHandle)completionHandler {
    
    return [self dispatchTask:[self dataTaskWithUrlPath:urlPath
                                            requestType:requestType
                                                 params:params
                                                 header:header
                                      completionHandler:completionHandler]];
}

// 通过task 拿到此次的taskIdentifier 用来取消啊
- (NSNumber *)dispatchTask:(NSURLSessionDataTask *)task {
    if (task == nil) { return @-1;}
    
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    [self.dispathTable setObject:task forKey:@(task.taskIdentifier)];
    dispatch_semaphore_signal(lock);
    
    [task resume];
    return @(task.taskIdentifier);
}

- (NSNumber *)uploadDataWithUrlPath:(NSString *)urlPath params:(NSDictionary *)params contents:(NSArray<LYUUploadFile *> *)contents header:(NSDictionary *)header progressHandler:(void (^)(NSProgress *))progressHandler completionHandler:(LYUCompletionHandle)completionHandler {
    
    NSMutableURLRequest *request = [[LYUURLRequestGenerator sharedInstance] generateUploadRequestUrlPath:urlPath params:params contents:contents header:header];
    NSMutableArray *taskIdentifier = [NSMutableArray arrayWithObject:@(-1)];
    
    NSURLSessionDataTask *task = [self.sessionManager uploadTaskWithStreamedRequest:request progress:progressHandler completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        self.totalTaskCount += 1;
        
        dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
        [self.dispathTable removeObjectForKey:taskIdentifier.firstObject];
        dispatch_semaphore_signal(lock);
        
        [self checkSeriveWithTaskError:error];
        
        !completionHandler ?: completionHandler(response, responseObject, error);
    }];
    taskIdentifier[0] = @(task.taskIdentifier);
    return [self dispatchTask:task];
}

- (void)cancelAllTask {
    
    for (NSURLSessionTask *task in self.dispathTable.allValues) {
        [task cancel];
    }
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    [self.dispathTable removeAllObjects];
    dispatch_semaphore_signal(lock);
}

- (void)cancelTaskWithTaskIdentifier:(NSNumber *)taskIdentifier {
    
    [self.dispathTable[taskIdentifier] cancel];
    
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    [self.dispathTable removeObjectForKey:taskIdentifier];
    dispatch_semaphore_signal(lock);
}









- (void)didReceivedSwitchSeriveNotification:(NSNotification *)notif {
    
    dispatch_semaphore_wait(lock, DISPATCH_TIME_FOREVER);
    self.totalTaskCount = self.errorTaskCount = 0;
    dispatch_semaphore_signal(lock);
    [[LYUURLRequestGenerator sharedInstance] switchService:[notif.userInfo[@"service"] integerValue]];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// 切换服务器
- (void)checkSeriveWithTaskError:(NSError *)error {
    
    switch (error.code) {
        case NSURLErrorUnknown:
        case NSURLErrorTimedOut:
        case NSURLErrorCannotConnectToHost: {
            self.errorTaskCount += 1;
        }
        default:break;
    }
    //  错误率>10% 或者访问量>40
    if (self.totalTaskCount >= 40 && (self.errorTaskCount / self.totalTaskCount) == 0.1) {
        self.totalTaskCount = self.errorTaskCount = 0;
        [[LYUURLRequestGenerator sharedInstance] switchService:LYUService0];
    }
}

@end
