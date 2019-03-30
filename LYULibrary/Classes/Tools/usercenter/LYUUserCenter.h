//
//  LYUUserCenter.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/3/29.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYUUserCenter : NSObject



- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)obj forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END


