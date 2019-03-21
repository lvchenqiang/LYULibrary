//
//  UIView+BlockGesture.m
//  OCThirdLib
//
//  Created by 吕陈强 on 2018/3/9.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

#import "UIView+BlockGesture.h"
#import <objc/runtime.h>

static const char * kActionHandlerTapBlockKey = "kActionHandlerTapBlockKey";
static const char * kActionHandlerTapGestureKey = "kActionHandlerTapGestureKey";
static const char * kActionHandlerLongPressBlockKey = "kActionHandlerLongPressBlockKey";
static const char * kActionHandlerLongPressGestureKey = "kActionHandlerLongPressGestureKey";

@implementation UIView (BlockGesture)


- (void)addTapActionWithBlock:(GestureActionBlock)block
{
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, kActionHandlerTapGestureKey);
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}
- (void)handleActionForTapGesture:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        GestureActionBlock block = objc_getAssociatedObject(self, kActionHandlerTapBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}
- (void)addLongPressActionWithBlock:(GestureActionBlock)block
{
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, kActionHandlerLongPressGestureKey);
    if (!gesture)
    {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, kActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, kActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}
- (void)handleActionForLongPressGesture:(UITapGestureRecognizer*)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan){
        GestureActionBlock block = objc_getAssociatedObject(self, kActionHandlerLongPressBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
    
}

@end
