//
//  UITextField+Extension.m
//  EllaBooks
//
//  Created by 吕陈强 on 2018/3/29.
//  Copyright © 2018年 Diandu. All rights reserved.
//

#import "UITextField+Extension.h"
#import <objc/runtime.h>

static const char * Placeholder_Color = "placeholder_color" ;
static const char * Placeholder_Font = "placeholder_font" ;

@implementation UITextField (Extension)

-(void)setPlaceholder_font:(UIFont *)placeholder_font{
    objc_setAssociatedObject(self, Placeholder_Font, placeholder_font, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setValue:placeholder_font forKeyPath:@"_placeholderLabel.font"];
}
- (UIFont *)placeholder_font{
    return objc_getAssociatedObject(self, Placeholder_Font);
}

-(void)setPlaceholder_color:(UIColor *)placeholder_color{
    objc_setAssociatedObject(self, Placeholder_Color, placeholder_color, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self setValue:placeholder_color forKeyPath:@"_placeholderLabel.textColor"];
}
-(UIColor *)placeholder_color{
    return objc_getAssociatedObject(self,Placeholder_Color);
}

@end
