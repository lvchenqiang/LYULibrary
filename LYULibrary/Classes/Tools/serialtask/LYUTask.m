//
//  LYUTask.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/4/4.
//  Copyright © 2019 Micah. All rights reserved.
//

#import "LYUTask.h"

@interface LYUTask ()

@property (nonatomic, assign) NSUInteger  taskIdentifier;    /* an identifier for this task */
@property (nonatomic, copy) void (^taskBlock) (void);
@end

@implementation LYUTask


-(instancetype)initWithTask:(nullable void(^)(void))task TaskIdentifier:(NSInteger)taskIdentifier
{
    if(self = [super init]){
       _taskIdentifier = taskIdentifier;
        _taskBlock = task;
        _status = LYUTaskStatusDefault;
        
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"staus:%ld  taskIdentifier:%lu",(long)_status,(unsigned long)_taskIdentifier];
}
@end
