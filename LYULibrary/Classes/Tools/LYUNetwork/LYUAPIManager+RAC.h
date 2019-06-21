//
//  LYUAPIManager+RAC.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/6/21.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "LYUAPIManager.h"
#import "ReactiveObjC.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYUAPIManager (RAC)
- (RACSignal *)dataSignalWithConfig:(LYUDataTaskConfiguration *)config;
- (RACSignal *)uploadSignalWithConfig:(LYUUploadTaskConfiguration *)config;

@end

NS_ASSUME_NONNULL_END
