//
//  UIView+Task.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/4/9.
//  Copyright © 2019 Micah. All rights reserved.
//

#import "UIView+Task.h"
#import <objc/runtime.h>
#import "LYUTaskManager.h"




@implementation UIView (Task)


+ (void)load
{
    
    
    // hook uiview
    
    SEL orginSelector = @selector(didMoveToSuperview);
    SEL swizzledSelector = @selector(didMoveToSuperview_lyu_p);
    
    Method orginMethod = class_getInstanceMethod([UIView class], orginSelector);
    Method swizzledMethod = class_getInstanceMethod([UIView class], swizzledSelector);
    
    BOOL success = class_addMethod([UIView class], orginSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if(success){
        class_replaceMethod([UIView class], swizzledSelector, method_getImplementation(orginMethod),  method_getTypeEncoding(orginMethod));
    }else{
        method_exchangeImplementations(orginMethod, swizzledMethod);
    }
    
    // hook
    SEL orginSelector1 = @selector(removeFromSuperview);
    SEL swizzledSelector1 = @selector(removeFromSuperview_lyu_p);
    
    
    Method orginMethod1 = class_getInstanceMethod([UIView class], orginSelector1);
    Method swizzledMethod1 = class_getInstanceMethod([UIView class], swizzledSelector1);
    
    BOOL success1 = class_addMethod([UIView class], orginSelector1, method_getImplementation(swizzledMethod1), method_getTypeEncoding(swizzledMethod1));
    
    if(success1){
        class_replaceMethod([UIView class], swizzledSelector1, method_getImplementation(orginMethod1),  method_getTypeEncoding(orginMethod1));
    }else{
        method_exchangeImplementations(orginMethod1, swizzledMethod1);
    }
    
}


// MARK:hock  methods
- (void)didMoveToSuperview_lyu_p{
    [self didMoveToSuperview_lyu_p];
    
}

- (void)removeFromSuperview_lyu_p{
    [self removeFromSuperview_lyu_p];
    if(self.tag == LYUTaskManager.LYUTaskGlobalIdentifier){
        [[LYUTaskManager sharedManager] startTasks:true];
    }
    
}


/// 绑定关联属性
- (void)setTaskBlock:(UIViewTaskBlock)taskBlock
{
    objc_setAssociatedObject(self, @selector(taskBlock), taskBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIViewTaskBlock)taskBlock
{
    return objc_getAssociatedObject(self, _cmd);
}
@end
