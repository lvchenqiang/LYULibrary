//
//  NSObject+KVC.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/4/26.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "NSObject+KVC.h"
#import <objc/runtime.h>
@implementation NSObject (KVC)

- (void)lyu_setValue:(nullable id)value forKey:(NSString *)key
{
    NSError  *error;
    BOOL validate = [self validateValue:&value forKey:key error:&error];
    NSArray *arr = [self getIvarListName];
    if (validate) {
        if ([arr containsObject:key]) {
            [self setValue:value forKey:key];
        }else{
            NSLog(@"%@ 不存在变量",key);
        }
    }
    
}

- (nullable id)lyu_valueForKey:(NSString *)key
{
    if (key == nil || key.length == 0) {
        NSLog(@"key为nil或者空值");
        return nil;
    }
    NSArray *arr = [self getIvarListName];
    if ([arr containsObject:key]) {
        return [self valueForKey:key];
    }else{
        NSLog(@"%@ 不存在变量",key);
    }
    return nil;
}



- (BOOL)validateValue:(inout id  _Nullable __autoreleasing *)ioValue forKey:(NSString *)inKey error:(out NSError * _Nullable __autoreleasing *)outError{
    
    if (*ioValue == nil || inKey == nil || inKey.length == 0) {
        NSLog(@"value 可能为nil  或者key为nil或者空值");
        return NO;
    }
    return YES;
}

- (NSMutableArray *)getIvarListName{
    
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:1];
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i<count; i++) {
        Ivar ivar = ivars[i];
        const char *ivarNameChar = ivar_getName(ivar);
        NSString *ivarName = [NSString stringWithUTF8String:ivarNameChar];
        NSLog(@"ivarName == %@",ivarName);
        [mArray addObject:ivarName];
    }
    free(ivars);
    return mArray;
}

@end
