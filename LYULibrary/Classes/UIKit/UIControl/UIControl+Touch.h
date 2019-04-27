//
//  UIControl+Touch.h
//  Category
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 qingxunLv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (Touch)
#define defaultInterval 2  //默认时间间隔
/**设置点击时间间隔*/
@property (nonatomic, assign) NSTimeInterval timeInterval;
@end
