//
//  UIControl+Touch.m
//  Category
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 qingxunLv. All rights reserved.
//

#import "UIControl+Touch.h"
#import <objc/runtime.h>
@interface UIControl ()
/**bool 类型   设置是否执行点UI方法*/
@property (nonatomic, assign) BOOL isIgnoreEvent;
@end
@implementation UIControl (Touch)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selA = @selector(sendAction:to:forEvent:);
        SEL selB = @selector(mySendAction:to:forEvent:);
        Method methodA =   class_getInstanceMethod(self,selA);
        Method methodB = class_getInstanceMethod(self, selB);
        BOOL isAdd = class_addMethod(self, selA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
        if (isAdd) {
            class_replaceMethod(self, selB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
        }else{
            method_exchangeImplementations(methodA, methodB);
        }
    });
}
- (NSTimeInterval)timeInterval
{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}
- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    objc_setAssociatedObject(self, @selector(timeInterval), @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}
- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if ([NSStringFromClass(self.class) isEqualToString:@"UIButton"]) {
        if (self.isIgnoreEvent == 0) {
            self.timeInterval =self.timeInterval ==0 ?defaultInterval:self.timeInterval;
        };
        if (self.isIgnoreEvent) return;
        if (self.timeInterval > 0)
        {
            self.isIgnoreEvent = YES;
            
            [self performSelector:@selector(setIsIgnoreEvent:) withObject:NULL afterDelay:self.timeInterval];
        }
        
    }
    [self mySendAction:action to:target forEvent:event];
    
}
- (void)setIsIgnoreEvent:(BOOL)isIgnoreEvent{
  
    objc_setAssociatedObject(self, @selector(isIgnoreEvent), @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
   
}
- (BOOL)isIgnoreEvent{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)changeIsIgnoreEvent:(NSString *)isIgnoreEvent {
    objc_setAssociatedObject(self, @selector(isIgnoreEvent), @([isIgnoreEvent boolValue]), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
