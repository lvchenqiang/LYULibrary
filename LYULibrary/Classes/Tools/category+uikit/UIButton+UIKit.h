//
//  UIButton+UIKit.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/5/19.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+UIKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (UIKit)

+ (UIButton *(^)(UIButtonType buttonType))lyu_initWithType;

- (UIButton *(^)(id target, SEL sel, UIControlEvents event))lyu_addTarget;

- (UIButton *(^)(NSString *text, UIControlState state))lyu_title;

- (UIButton *(^)(UIColor *color, UIControlState state))lyu_titleColor;

- (UIButton *(^)(UIFont *font))lyu_titleFont;

- (UIButton *(^)(NSString *text, UIColor *color, UIFont *font, UIControlState state))lyu_titleAndTitleColor;


@end

NS_ASSUME_NONNULL_END
