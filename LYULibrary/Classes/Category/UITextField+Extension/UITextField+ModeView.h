//
//  UITextField+ModeView.h
//  EllaBooks
//
//  Created by 吕陈强 on 2018/5/28.
//  Copyright © 2018年 Diandu. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UITextField (ModeView)

- (void)addBothTextFiledModeTypeWithLeftSpace:(CGFloat)leftSpace RightSpace:(CGFloat)rightSpace;
- (void)addLeftTextFiledModeWithSpace:(CGFloat)space;
- (void)addRightTextFiledModeWithSpace:(CGFloat)space;

@end
