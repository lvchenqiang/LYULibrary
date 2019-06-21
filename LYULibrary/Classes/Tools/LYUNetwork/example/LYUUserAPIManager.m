//
//  LYUUserAPIManager.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/6/21.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "LYUUserAPIManager.h"

@implementation LYUUserAPIManager

/** TODO: 获取验证码 */
- (RACSignal *)getVerifyCodeSignalWithPhoneNumber:(NSString *)phoneNumber {
    return arc4random() % 2 ? [RACSignal error:LYUError(LYUDefaultErrorNotice, 999)] : [RACSignal return:@YES];
}

/** TODO: 注册 */
- (RACSignal *)registerSignalWithAccount:(NSString *)account password:(NSString *)password verifyCode:(NSString *)verifyCode {
    return arc4random() % 2 ? [RACSignal error:LYUError(LYUDefaultErrorNotice, 999)] : [RACSignal return:@YES];
}



/** TODO: 最新列表数据 */
- (RACSignal *)homeListSignalWithPage:(int)page pageSize:(int)pageSize{
    LYUDataTaskConfiguration *config = [LYUDataTaskConfiguration new];
    config.urlPath = @"/postMethod/";
    config.requestType = LYUNetworkRequestTypePOST;
    config.requestParameters = @{@"page": @(page),
                                 @"username": [NSString stringWithFormat:@"%d",pageSize]};
    
    
    config.deserializePath = @"data";
    config.cacheValidTimeInterval = 100;
    config.deserializeClass = [UserModel class]; // 放你要处理的模型
    
    return [[LYUAPIManager new] dataSignalWithConfig:config];
}
@end
