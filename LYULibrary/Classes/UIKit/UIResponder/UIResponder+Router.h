//
//  UIResponder+Router.h
//  EllaBooks
//
//  Created by 吕陈强 on 2018/5/2.
//  Copyright © 2018年 Diandu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Router)
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;
@end
