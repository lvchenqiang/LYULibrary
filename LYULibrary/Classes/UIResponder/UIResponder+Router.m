//
//  UIResponder+Router.m
//  EllaBooks
//
//  Created by 吕陈强 on 2018/5/2.
//  Copyright © 2018年 Diandu. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)


- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
//    NSInvocation *invocation = self.eventStrategy[eventName];
//    [invocation setArgument:&userInfo atIndex:2];
//    [invocation invoke];
}

//- (NSDictionary <NSString *, NSInvocation *> *)eventStrategy
//{
//    if (_eventStrategy == nil) {
//        _eventStrategy = @{
//                           kBLGoodsDetailTicketEvent:[self createInvocationWithSelector:@selector(ticketEvent:)],
//                           kBLGoodsDetailPromotionEvent:[self createInvocationWithSelector:@selector(promotionEvent:)],
//                           kBLGoodsDetailScoreEvent:[self createInvocationWithSelector:@selector(scoreEvent:)],
//                           kBLGoodsDetailTargetAddressEvent:[self createInvocationWithSelector:@selector(targetAddressEvent:)],
//                           kBLGoodsDetailServiceEvent:[self createInvocationWithSelector:@selector(serviceEvent:)],
//                           kBLGoodsDetailSKUSelectionEvent:[self createInvocationWithSelector:@selector(skuSelectionEvent:)],
//                           };
//    }
//    return _eventStrategy;
//}


//- (NSInvocation *)createInvocationWithSelector:(SEL)sel{
//    NSMethodSignature * sign = [[self class] instanceMethodSignatureForSelector:sel];
//    NSInvocation * invocatin = [NSInvocation invocationWithMethodSignature:sign];
//    return invocatin;
//}

@end
