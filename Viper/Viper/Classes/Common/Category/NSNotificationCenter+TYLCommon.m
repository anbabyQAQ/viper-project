//
//  NSNotificationCenter+TYLCommon.m
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "NSNotificationCenter+TYLCommon.h"


NSString *const kTYLNotificationLoginStatusChange = @"NPNotificationLoginStatusChange";
NSString *const kTYLNotificationMultilogin = @"NPNotificationMultilogin";

@implementation NSNotificationCenter (TYLCommon)

// 登录状态改变
- (void)onLoginStatusChange:(void (^)(void))notiBlock {
    [[NSNotificationCenter defaultCenter] addObserverForName:kTYLNotificationLoginStatusChange object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if (notiBlock) {
            notiBlock();
        }
    }];
}
- (void)loginStatusChange {
    [[NSNotificationCenter defaultCenter] postNotificationName:kTYLNotificationLoginStatusChange object:nil];
}

// 多点登录
- (void)onMultilogin:(void (^)(void))notiBlock {
    [[NSNotificationCenter defaultCenter] addObserverForName:kTYLNotificationMultilogin object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        if (notiBlock) {
            notiBlock();
        }
    }];
}
- (void)multilogin {
    [[NSNotificationCenter defaultCenter] postNotificationName:kTYLNotificationMultilogin object:nil];
}

@end
