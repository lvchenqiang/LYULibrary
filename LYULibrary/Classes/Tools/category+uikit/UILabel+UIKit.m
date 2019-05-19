//
//  UILabel+UIKit.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/5/19.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "UILabel+UIKit.h"

@implementation UILabel (UIKit)


+ (UILabel * _Nonnull (^)(void))initLab
{
    return ^{
        return [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    };
}

- (UILabel *(^)(NSString *text))lyu_text
{
    return ^(NSString * text){
        self.text = text;
        return self;
    };
}

- (UILabel *(^)(UIColor *))lyu_textColor
{
    return ^(UIColor * textColor){
        self.textColor = textColor;
        return self;
    };
}



- (UILabel *(^)(UIFont *))lyu_textFont{
    return ^(UIFont * font){
        self.font = font;
        return self;
    };
}


- (UILabel *(^)(NSTextAlignment textAlignment))lyu_textAlignment{
    return ^(NSTextAlignment textAlignment){
        self.textAlignment = textAlignment;
        return self;
    };
}






@end
