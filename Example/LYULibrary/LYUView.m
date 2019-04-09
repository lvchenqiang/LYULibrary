//
//  LYUView.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/4/9.
//  Copyright © 2019 Micah. All rights reserved.
//

#import "LYUView.h"

@implementation LYUView

- (void)didMoveToSuperview
{
    NSLog(@"------didMoveToSuperview--%@",self);
}


- (void)removeFromSuperview
{
    [super removeFromSuperview];
    NSLog(@"------removeFromSuperview---%@",self);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeFromSuperview];
}



- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 30)];
        lab.text = [NSString stringWithFormat:@"%d",arc4random_uniform(256)];
        lab.textColor = [UIColor whiteColor];
        [self addSubview:lab];
    }
    return self;
}



@end
