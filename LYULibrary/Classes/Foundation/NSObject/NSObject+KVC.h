//
//  NSObject+KVC.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/4/26.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (KVC)

- (void)lyu_setValue:(nullable id)value forKey:(NSString *)key;

- (nullable id)lyu_valueForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
