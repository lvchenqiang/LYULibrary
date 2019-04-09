//
//  LYUViewController.m
//  LYULibrary
//
//  Created by lvchenqiang on 03/21/2019.
//  Copyright (c) 2019 lvchenqiang. All rights reserved.
//

#import "LYUViewController.h"
//#import "LYUClassInfo.h"
#import "LYUTaskManager.h"
#import "LYUView.h"

//设置随机的颜色
#define LRRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]



@interface LYUViewController ()

@end

@implementation LYUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    /// 添加任务
    for (int i = 0; i < 6; i++){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [[LYUTaskManager sharedManager] addTask:^{
                
                LYUView * vvv = [[LYUView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                
                vvv.tag = LYUTaskManager.LYUTaskGlobalIdentifier;
                vvv.backgroundColor = LRRandomColor;
                vvv.alpha = 0.5;
                [self.view addSubview:vvv];
            } async:true];
            
        });
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
