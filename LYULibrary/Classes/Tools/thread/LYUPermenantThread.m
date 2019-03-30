//
//  LYUPermenantThread.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/3/29.
//  Copyright © 2019 吕陈强. All rights reserved.
//


#import "LYUPermenantThread.h"

/** LYUThread **/
@interface LYUThread : NSThread
@end
@implementation LYUThread
- (void)dealloc
{
    NSLog(@"%s", __func__);
}
@end

/** LYUPermenantThread **/
@interface LYUPermenantThread()
@property (strong, nonatomic) LYUThread *innerThread;
@end

@implementation LYUPermenantThread
#pragma mark - public methods
- (instancetype)init
{
    if (self = [super init]) {
        self.innerThread = [[LYUThread alloc] initWithBlock:^{
//            NSLog(@"begin----");
            
            // 创建上下文（要初始化一下结构体）
            CFRunLoopSourceContext context = {0};
            
            // 创建source
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
            
            // 往Runloop中添加source
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            
            // 销毁source
            CFRelease(source);
            
            // 启动
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
            
            //            while (weakSelf && !weakSelf.isStopped) {
            //                // 第3个参数：returnAfterSourceHandled，设置为true，代表执行完source后就会退出当前loop
            //                CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, true);
            //            }
            
//            NSLog(@"end----");
        }];
        
        [self.innerThread start];
    }
    return self;
}

//- (void)run
//{
//    if (!self.innerThread) return;
//
//    [self.innerThread start];
//}

- (void)executeTask:(LYUPermenantThreadTask)task
{
    if (!self.innerThread || !task) return;
    
    [self performSelector:@selector(__executeTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
}

- (void)stop
{
    if (!self.innerThread) return;
    
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    
    [self stop];
}

#pragma mark - private methods
- (void)__stop
{
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

- (void)__executeTask:(LYUPermenantThreadTask)task
{
    task();
}

@end

