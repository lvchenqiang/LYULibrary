//
//  UIView+UIKit.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/5/19.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "UIView+UIKit.h"

@implementation UIView (UIKit)

+ (instancetype(^)(void))initInstance
{
    return ^{
        return [[self alloc] init];
    };
}
- (UIView * (^)(CGRect ))lyu_frame{
    return ^(CGRect  frame){
        self.frame = frame;
        return self;
    };
}

- (UIView * (^)(CGRect ))lyu_bounds{
    return ^(CGRect  bounds){
        self.bounds = bounds;
        return self;
    };
}

- (UIView * (^)(CGPoint ))lyu_center{
    return ^(CGPoint  center){
        self.center = center;
        return self;
    };
}



- (UIView *(^)(CGFloat x))lyu_x
{
    return ^(CGFloat x)
    {
        CGRect frame = self.frame;
        frame.origin.x = x;
        self.frame = frame;
        return self;
    };
    
}

- (UIView *(^)(CGFloat y))lyu_y
{
    return ^(CGFloat y)
    {
        CGRect frame = self.frame;
        frame.origin.y = y;
        self.frame = frame;
        return self;
    };
}

- (UIView *(^)(CGFloat width))lyu_width
{
    return ^(CGFloat width)
    {
        CGRect frame = self.frame;
        frame.size.width = width;
        self.frame = frame;
        return self;
    };
}


- (UIView *(^)(CGFloat height))lyu_height
{
    return ^(CGFloat height)
    {
        CGRect frame = self.frame;
        frame.size.height = height;
        self.frame = frame;
        return self;
    };
}




- (UIView * (^)(BOOL ))lyu_hidden{
    return ^(BOOL  hidden){
        self.hidden = hidden;
        return self;
    };
}

- (UIView * (^)(CGFloat ))lyu_alpha{
    return ^(CGFloat  alpha){
        self.alpha = alpha;
        return self;
    };
}

- (UIView * (^)(BOOL ))lyu_masksToBounds{
    return ^(BOOL  masksToBounds){
        self.layer.masksToBounds = masksToBounds;
        return self;
    };
}


- (UIView * (^)(CGFloat ))lyu_cornerRadius{
    return ^(CGFloat  cornerRadius){
        self.layer.cornerRadius = cornerRadius;
        return self;
    };
}



- (UIView * (^)(CGFloat ))lyu_borderWidth{
    return ^(CGFloat  borderWidth){
        self.layer.borderWidth = borderWidth;
        return self;
    };
}

- (UIView * (^)(UIColor * ))lyu_borderColor{
    return ^(UIColor*  borderColor){
        self.layer.borderColor = borderColor.CGColor;
        return self;
    };
}

- (UIView *(^)(UIColor *))lyu_backgroundColor{
    return ^(UIColor * backgroundColor){
        self.backgroundColor = backgroundColor;
        return self;
    };
}

- (UIView *(^)(UIView *view))lyu_addSubView
{
    return ^(UIView *view)
    {
        [self addSubview:view];
        return self;
    };
}


@end
