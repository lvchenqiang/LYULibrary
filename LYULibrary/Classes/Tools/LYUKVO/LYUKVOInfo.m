//
//  LYUKVOInfo.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/4/29.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "LYUKVOInfo.h"

@implementation LYUKVOInfo
- (instancetype)initWithObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(LYUKeyValueObservingOptions)options handBlock:(LYUKVOBlock)handBlock;
{
    if (self = [super init]) {
        self.observer = observer;
        self.keyPath  = keyPath;
        self.options  = options;
        self.handBlock= handBlock;
    }
    return self;
}

- (void)dealloc{
    NSLog(@"%@",self.observer);
    NSLog(@"LGKVOInfo 走了");
}
@end
