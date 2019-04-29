//
//  NSObject+LYUKVO.m
//  LYUKit
//
//  Created by 吕陈强 on 2019/4/29.
//  Copyright © 2019 吕陈强. All rights reserved.
//

#import "NSObject+LYUKVO.h"

#import <objc/message.h>

static NSString *const kLYUKVOPrefix = @"LYUKVONotifying_";
static NSString *const kLYUKVOAssiociateKey = @"kLYUKVO_AssiociateKey";


@implementation NSObject (LYUKVO)
- (void)lyu_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(LYUKeyValueObservingOptions)options context:(nullable void *)context handBlock:(LYUKVOBlock)handBlock
{
    // 1: 验证是否存在setter方法 : 不让实例进来
    [self judgeSetterMethodFromKeyPath:keyPath];
    // 2: 动态生成子类
    Class newClass = [self createChildClassWithKeyPath:keyPath];
    // 3: isa的指向 :LYUKVONotifying_LGPerson
    object_setClass(self, newClass);
    // 4: 保存KVO的信息 + 多信息 -
    // 集合 --> add map
   LYUKVOInfo *info = [[LYUKVOInfo alloc] initWithObserver:observer forKeyPath:keyPath options:options handBlock:handBlock];
    
    NSMutableArray *infoArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kLYUKVOAssiociateKey));
    if (!infoArray) {
        // 数组 -> 成员 强引用
        // self (VC)-> person ISA -> 数组 -> info -/weak/-> self(VC) ?
        // self.person ->LYUKVO -> self // 内存问题
        infoArray = [NSMutableArray arrayWithCapacity:1];
        objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kLYUKVOAssiociateKey), infoArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    // hash -- self --> array -> 强引用-- info
    [infoArray addObject:info];
    
}




- (void)lg_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    
    //
    
    NSMutableArray *infoArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kLYUKVOAssiociateKey));
    // self
    [infoArray enumerateObjectsUsingBlock:^(LYUKVOInfo *info , NSUInteger idx, BOOL * _Nonnull stop) {
        
        // ViewController name
        //LYUVC     name
        if ([info.keyPath isEqualToString:keyPath] && (observer == info.observer)) {
            [infoArray removeObject:info];
            *stop = YES;
        }
    }];
    
    // 如果关联数组没有关联KVO信息 -- 清空
    if (infoArray.count == 0) {
        objc_removeAssociatedObjects(infoArray);
    }
    // 指回给父类
    Class superClass = [self class]; //LYUPerson
    object_setClass(self, superClass);
    
}

#pragma mark - 验证是否存在setter方法
- (void)judgeSetterMethodFromKeyPath:(NSString *)keyPath{
    Class superClass    = object_getClass(self);
    SEL setterSeletor   = NSSelectorFromString(setterForGetter(keyPath));
    Method setterMethod = class_getInstanceMethod(superClass, setterSeletor);
    if (!setterMethod) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"老铁没有当前%@的setter",keyPath] userInfo:nil];
    }
}

#pragma mark -
- (Class)createChildClassWithKeyPath:(NSString *)keyPath{
    
    NSString *oldClassName = NSStringFromClass([self class]);
    NSString *newClassName = [NSString stringWithFormat:@"%@%@",kLYUKVOPrefix,oldClassName];
    Class newClass = NSClassFromString(newClassName);
    // 防止重复创建生成新类
    if (newClass) return newClass;
    /**
     * 如果内存不存在,创建生成
     * 参数一: 父类
     * 参数二: 新类的名字
     * 参数三: 新类的开辟的额外空间
     */
    // 2.1 : 申请类
    newClass = objc_allocateClassPair([self class], newClassName.UTF8String, 0);
    // 2.2 : 注册类
    objc_registerClassPair(newClass);
    // 2.3.1 : 添加class : class的指向是LGPerson
    SEL classSEL = NSSelectorFromString(@"class");
    Method classMethod = class_getInstanceMethod([self class], classSEL);
    const char *classTypes = method_getTypeEncoding(classMethod);
    class_addMethod(newClass, classSEL, (IMP)lyu_class, classTypes);
    // 2.3.2 : 添加setter
    SEL setterSEL = NSSelectorFromString(setterForGetter(keyPath));
    Method setterMethod = class_getInstanceMethod([self class], setterSEL);
    const char *setterTypes = method_getTypeEncoding(setterMethod);
    class_addMethod(newClass, setterSEL, (IMP)lyu_setter, setterTypes);
    
    // 2.3.3 : 添加dealloc -- 为什么系统给KVO添加dealloc
    SEL deallocSEL = NSSelectorFromString(@"dealloc");
    Method deallocMethod = class_getInstanceMethod([self class], deallocSEL);
    const char *deallocTypes = method_getTypeEncoding(deallocMethod);
    class_addMethod(newClass, deallocSEL, (IMP)lyu_dealloc, deallocTypes);
    return newClass;
}

static void lyu_dealloc(id self,SEL _cmd){
    // 指回给父类
    Class superClass = [self class]; //LYUPerson
    object_setClass(self, superClass);
}

static void lyu_setter(id self,SEL _cmd,id newValue){
    NSLog(@"来了:%@",newValue);
    
    NSString *keyPath = getterForSetter(NSStringFromSelector(_cmd));
    id oldValue       = [self valueForKey:keyPath];
    // 4: 消息转发 : 转发给父类
    // 改变父类的值 --- 可以强制类型转换
    
    void (*lyu_msgSendSuper)(void *,SEL , id) = (void *)objc_msgSendSuper;
    // void /* struct objc_super *super, SEL op, ... */
    struct objc_super superStruct = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self)),
    };
    //objc_msgSendSuper(&superStruct,_cmd,newValue)
    lyu_msgSendSuper(&superStruct,_cmd,newValue);
    
    // 既然观察到了,下一步不就是回调 -- 让我们的观察者调用
    // - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
    // 1: 拿到观察者
    // 2: 消息发送给观察者
    NSMutableArray *infoArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kLYUKVOAssiociateKey));
    
    for (LYUKVOInfo *info in infoArray) {
        if ([info.keyPath isEqualToString:keyPath]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // 枚举 -- 新值 + 旧值
                NSMutableDictionary<NSKeyValueChangeKey,id> *change = [NSMutableDictionary dictionaryWithCapacity:1];
                // 0x0001
                //&0x0001
                if (info.options &LYUKeyValueObservingOptionNew) {
                    [change setObject:newValue forKey:NSKeyValueChangeNewKey];
                }
                if (info.options &LYUKeyValueObservingOptionOld && oldValue) {
                    [change setObject:oldValue forKey:NSKeyValueChangeOldKey];
                }
                
                if (info.handBlock) {
                    info.handBlock(info.observer, keyPath, oldValue, newValue);
                }
            });
        }
    }
    
}

Class lyu_class(id self,SEL _cmd){
    return class_getSuperclass(object_getClass(self));
}

#pragma mark - 从get方法获取set方法的名称 key ===>>> setKey:
static NSString *setterForGetter(NSString *getter){
    
    if (getter.length <= 0) { return nil;}
    
    NSString *firstString = [[getter substringToIndex:1] uppercaseString];
    NSString *leaveString = [getter substringFromIndex:1];
    
    return [NSString stringWithFormat:@"set%@%@:",firstString,leaveString];
}

#pragma mark - 从set方法获取getter方法的名称 set<Key>:===> key
static NSString *getterForSetter(NSString *setter){
    
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) { return nil;}
    
    NSRange range = NSMakeRange(3, setter.length-4);
    NSString *getter = [setter substringWithRange:range];
    NSString *firstString = [[getter substringToIndex:1] lowercaseString];
    return  [getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstString];
}


@end
