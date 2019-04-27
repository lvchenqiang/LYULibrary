//
//  RLUncaughtExceptionHandler.h
//  Category
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 qingxunLv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface RLUncaughtExceptionHandler : NSObject
{
    BOOL dismissed;
}
void HandleException(NSException *exception);
void SignalHandler(int signal);
void InstallUncaughtExceptionHandler(void);

@end
