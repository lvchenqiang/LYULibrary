//
//  LYUTask.h
//  LYUKit
//
//  Created by 吕陈强 on 2019/4/4.
//  Copyright © 2019 Micah. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger,LYUTaskStatus){
    LYUTaskStatusDefault,
    LYUTaskStatusReady,
    LYUTaskStatusExecuting,
    LYUTaskStatusComplete
};



@interface LYUTask : NSObject

@property (readonly, assign, nonatomic) NSUInteger  taskIdentifier;    /* an identifier for this task */
@property (assign, nonatomic) LYUTaskStatus status; // status for this task
@property (nullable, copy) NSDate *earliestBeginDate; // status for this date
@property (nonatomic, copy, readonly) void (^taskBlock) (void);
@property (nonatomic, assign) BOOL async; /// 异步

-(instancetype)initWithTask:(nullable void(^)(void))task TaskIdentifier:(NSInteger)taskIdentifier;

@end

NS_ASSUME_NONNULL_END
