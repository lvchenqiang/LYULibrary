//
//  UIButton+UIKit.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/5/19.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "UIButton+UIKit.h"

@implementation UIButton (UIKit)

//button初始化方法一般使用它自己的枚举类型初始化
+ (UIButton *(^)(UIButtonType buttonType))lyu_initWithType
{
    return ^(UIButtonType buttonType)
    {
        return [UIButton buttonWithType:buttonType];
    };
}

- (UIButton *(^)(id target, SEL sel, UIControlEvents event))lyu_addTarget
{
    return ^(id target, SEL sel, UIControlEvents event)
    {
        [self addTarget:target action:sel forControlEvents:event];
        return self;
    };
    
}

- (UIButton *(^)(NSString *text, UIControlState state))lyu_title
{
    return ^(NSString *text, UIControlState state)
    {
        [self setTitle:text forState:state];
        return self;
    };
}

- (UIButton *(^)(UIColor *color, UIControlState state))lyu_titleColor
{
    return ^(UIColor *color, UIControlState state)
    {
        [self setTitleColor:color forState:state];
        return self;
    };
}

- (UIButton *(^)(UIImage *img, UIControlState state))lyu_backgroundImage
{
    return ^(UIImage *img, UIControlState state)
    {
        [self setImage:img forState:state];
        return self;
    };
}

- (UIButton *(^)(UIFont *font))lyu_titleFont
{
    return ^(UIFont *font)
    {
        self.titleLabel.font = font;
        return self;
    };
}

- (UIButton *(^)(NSString *text, UIColor *color, UIFont *font, UIControlState state))lyu_titleAndTitleColor
{
    return ^(NSString *text, UIColor *color, UIFont *font, UIControlState state)
    {
        self.titleLabel.font = font;
        [self setTitle:text forState:state];
        [self setTitleColor:color forState:state];
        return self;
    };
}

@end
