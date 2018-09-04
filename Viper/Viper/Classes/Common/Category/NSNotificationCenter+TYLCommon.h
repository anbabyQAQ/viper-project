//
//  NSNotificationCenter+TYLCommon.h
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (TYLCommon)

// 登录状态改变
- (void)onLoginStatusChange:(void (^)(void))notiBlock;
- (void)loginStatusChange;

// 多点登录
- (void)onMultilogin:(void (^)(void))notiBlock;
- (void)multilogin;

@end
