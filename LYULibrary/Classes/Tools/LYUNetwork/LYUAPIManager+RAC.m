//
//  LYUAPIManager+RAC.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/6/21.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "LYUAPIManager+RAC.h"

@implementation LYUAPIManager (RAC)


- (RACSignal *)dataSignalWithConfig:(LYUDataTaskConfiguration *)config {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSNumber *taskIdentifier = [self dispatchDataTaskWithConfiguration:config completionHandler:^(NSError *error, id result) {
            if (error) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:result];
                [subscriber sendCompleted];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            [self cancelTask:taskIdentifier];
        }];
    }].deliverOnMainThread;
}

- (RACSignal *)uploadSignalWithConfig:(LYUUploadTaskConfiguration *)config {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSNumber *taskIdentifier = [self dispatchUploadTaskWithConfiguration:config progressHandler:^(CGFloat progress) {
            [subscriber sendNext:RACTuplePack(@(progress), nil)];
        } completionHandler:^(NSError *error, id result) {
            
            if (error) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:RACTuplePack(@1, result)];
                [subscriber sendCompleted];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            [self cancelTask:taskIdentifier];
        }];
    }].deliverOnMainThread;
}


@end
