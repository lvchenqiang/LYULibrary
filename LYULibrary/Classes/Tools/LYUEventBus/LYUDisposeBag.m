//
//  LYUDisposeBag.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/5/6.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "LYUDisposeBag.h"

@interface LYUDisposeBag ()
@property (strong, nonatomic) NSMutableArray<id<LYUEventToken>> * tokens;

@end

@implementation LYUDisposeBag

- (NSMutableArray<id<LYUEventToken>> *)tokens{
    if (!_tokens) {
        _tokens = [[NSMutableArray alloc] init];
    }
    return _tokens;
}

- (void)addToken:(id<LYUEventToken>)token{
    @synchronized(self) {
        [self.tokens addObject:token];
    }
}

- (void)dealloc{
    @synchronized(self) {
        for (id<LYUEventToken> token in self.tokens) {
            if ([token respondsToSelector:@selector(dispose)]) {
                [token dispose];
            }
        }
    }
}

@end
