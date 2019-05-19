//
//  UILabel+UIKit.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/5/19.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (UIKit)

+ (UILabel * (^)(void))initLab;

- (UILabel *(^)(UIColor *))lyu_textColor;

- (UILabel *(^)(NSString *text))lyu_text;

- (UILabel *(^)(UIFont *))lyu_textFont;

- (UILabel *(^)(NSTextAlignment textAlignment))lyu_textAlignment;




@end

NS_ASSUME_NONNULL_END
