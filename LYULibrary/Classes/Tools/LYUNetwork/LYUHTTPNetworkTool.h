//
//  LYUHTTPNetworkTool.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/6/21.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYUHTTPNetworkTool : NSObject
+ (NSString *)lyu_md5WithData:(NSData *)data;

+ (NSString *)lyu_md5String:(NSString *)string;

+ (BOOL)isNetworkReachable;
@end

NS_ASSUME_NONNULL_END
