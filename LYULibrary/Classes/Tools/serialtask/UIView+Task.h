//
//  UIView+Task.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/4/9.
//  Copyright © 2019 Micah. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^UIViewTaskBlock)(UIView *);

@interface UIView (Task)

@property (nonatomic, copy) UIViewTaskBlock taskBlock;


@end

NS_ASSUME_NONNULL_END
