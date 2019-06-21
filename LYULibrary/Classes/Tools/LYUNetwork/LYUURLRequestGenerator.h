//
//  LYUURLRequestGenerator.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/6/21.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LYUUploadFile.h"
#import "LYUService.h"


@interface LYUURLRequestGenerator : NSObject

+ (instancetype)sharedInstance;

/**
 普通网络请求
 
 @param urlPath 请求地址
 @param method 请求方式
 @param params 请求参数
 @param header 请求头
 @return request信息
 */
- (NSMutableURLRequest *)generateRequestWithUrlPath:(NSString *)urlPath
                                             method:(NSString *)method
                                             params:(NSDictionary *)params
                                             header:(NSDictionary *)header;


/**
 上传文件
 
 @param urlPath 请求地址
 @param params 请求参数
 @param header 请求头
 @return request信息
 */
- (NSMutableURLRequest *)generateUploadRequestUrlPath:(NSString *)urlPath
                                               params:(NSDictionary *)params
                                             contents:(NSArray<LYUUploadFile *> *)contents
                                               header:(NSDictionary *)header;


- (void)switchService:(LYUServiceType)type;

@end

