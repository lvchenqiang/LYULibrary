//
//  LYULockProtocol.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/3/30.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LYULockProtocol <NSObject>
- (void)lock;
-(void)unlock;
@end

NS_ASSUME_NONNULL_END
