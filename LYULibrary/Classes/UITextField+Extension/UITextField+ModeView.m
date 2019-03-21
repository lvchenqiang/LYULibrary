//
//  UITextField+ModeView.m
//  EllaBooks
//
//  Created by 吕陈强 on 2018/5/28.
//  Copyright © 2018年 Diandu. All rights reserved.
//

#import "UITextField+ModeView.h"

@implementation UITextField (ModeView)

- (void)addBothTextFiledModeTypeWithLeftSpace:(CGFloat)leftSpace RightSpace:(CGFloat)rightSpace{
    [self addLeftTextFiledModeWithSpace:leftSpace];
    [self addRightTextFiledModeWithSpace:rightSpace];

}

- (void)addLeftTextFiledModeWithSpace:(CGFloat)space{
    self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, space, self.frame.size.height)];
    self.leftViewMode = UITextFieldViewModeAlways;
}
- (void)addRightTextFiledModeWithSpace:(CGFloat)space{
    self.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, space, self.frame.size.height)];
    self.rightViewMode = UITextFieldViewModeAlways;
}
@end
