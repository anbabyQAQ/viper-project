//
//  TYLViewControllerStyleProtocol.h
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TYLNavBarHiddenAnimation) {
    eTYLNavBarHiddenAnimationAutomatic,   // 自动动画
    eTYLNavBarHiddenAnimationNone         // 无动画
};

@protocol TYLViewControllerStyleProtocol <NSObject>

@optional
// 标题
- (NSString *)preferredNavBarTitle;

// 标题图片(navBarTitle为空时有效)
- (NSString *)preferredNavBarTitleImageName;

// 返回按钮是否隐藏
- (BOOL)preferredNavBarBackHidden;

// 导航栏是否隐藏
- (BOOL)preferredNavBarHidden;

// 导航栏隐藏及显示的动画(默认设置为自动)
- (TYLNavBarHiddenAnimation)preferredNavBarHiddenAnimation;

// 刷新导航栏样式
- (void)refreshNavBarStyle;

@end
