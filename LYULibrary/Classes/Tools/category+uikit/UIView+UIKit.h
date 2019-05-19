//
//  UIView+UIKit.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/5/19.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (UIKit)


+ (instancetype(^)(void))initInstance;

- (UIView * (^)(CGRect ))lyu_frame;

- (UIView * (^)(CGRect ))lyu_bounds;

- (UIView * (^)(CGPoint ))lyu_center;

- (UIView *(^)(CGFloat x))lyu_x;

- (UIView *(^)(CGFloat y))lyu_y;

- (UIView *(^)(CGFloat width))lyu_width;

- (UIView *(^)(CGFloat height))lyu_height;

- (UIView * (^)(BOOL ))lyu_hidden;

- (UIView * (^)(CGFloat ))lyu_alpha;

- (UIView * (^)(BOOL ))lyu_masksToBounds;

- (UIView * (^)(CGFloat ))lyu_cornerRadius;

- (UIView * (^)(CGFloat ))lyu_borderWidth;

- (UIView * (^)(UIColor * ))lyu_borderColor;

- (UIView *(^)(UIColor *))lyu_backgroundColor;

- (UIView *(^)(UIView *view))lyu_addSubView;

@end

NS_ASSUME_NONNULL_END
