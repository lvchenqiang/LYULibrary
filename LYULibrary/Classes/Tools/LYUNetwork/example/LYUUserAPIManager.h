//
//  LYUUserAPIManager.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/6/21.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "LYUAPIManager+RAC.h"



@interface UserModel : NSObject
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@end

@implementation UserModel

@end

@interface LYUUserAPIManager : NSObject

/** TODO: 获取验证码 */
- (RACSignal *)getVerifyCodeSignalWithPhoneNumber:(NSString *)phoneNumber;

/** TODO: 注册 */
- (RACSignal *)registerSignalWithAccount:(NSString *)account password:(NSString *)password verifyCode:(NSString *)verifyCode;

@end

