//
//  UIView+BlockGesture.h
//  OCThirdLib
//
//  Created by 吕陈强 on 2018/3/9.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^GestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);
@interface UIView (BlockGesture)

/**
 *  @brief  添加tap手势
 *
 *  @param block 代码块
 */
- (void)addTapActionWithBlock:(GestureActionBlock)block;
/**
 *  @brief  添加长按手势
 *
 *  @param block 代码块
 */
- (void)addLongPressActionWithBlock:(GestureActionBlock)block;
@end
