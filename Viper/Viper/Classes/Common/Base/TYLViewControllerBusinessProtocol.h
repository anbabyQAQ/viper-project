//
//  TYLViewControllerBusinessProtocol.h
//  Nirvana
//
//  Created by xinglei on 18/09/2017.
//  Copyright © 2017 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>

// 登录页返回的处理方式
typedef NS_ENUM(NSUInteger, TYLViewControllerLogBackStyle) {
    TYLViewControllerLogBackStyleTop,          // 顶层(默认)
    TYLViewControllerLogBackStyleLast,         // 最后一层
    TYLViewControllerLogBackStylePrev          // 上一层(最后一层的前一层)
};

@protocol TYLViewControllerBusinessProtocol <NSObject>

@optional
// 监听登录状态
- (BOOL)listenLoginStatus;

// 登录状态更新
- (void)loginStatusChanged;

// 监听多点登录
- (BOOL)listenMultiogin;

// 多点登录
- (void)multiLoggedIn;

// 需要登录
- (BOOL)needLogin;

// 已登录
- (BOOL)hasLoggedIn;

// 登录页返回的处理方式
- (TYLViewControllerLogBackStyle)logBackStyle;


@end
