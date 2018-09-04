//
//  TYLBaseViewController.h
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import "TYLViperViewController.h"

#import "TYLViewControllerStyleProtocol.h"
#import "TYLViewControllerBusinessProtocol.h"

@interface TYLBaseViewController : TYLViperViewController <TYLViewControllerStyleProtocol, TYLViewControllerBusinessProtocol>

/**
 页面自适应 -主要针对键盘弹出与消失
 */
- (void)customRAC;

/**
 *  网络加载提示
 *  status: 交互状态  为PBLoadStatus枚举类型
 *  msg   : 提示文字
 */
- (void)showLoadStatuts:(UILoadStatus)status text:(NSString *)msg;

- (void)showLoadStatuts:(UILoadStatus)status text:(NSString *)msg completed:(void(^)(UILoadStatus loadStatus))complete;





/**
 添加导航条左边按钮
 
 @param image 按钮图标
 @param selector 事件
 @param target 事件目标
 */
- (void)leftBarButtomItemWithImage:(NSString*)image
                          selector:(SEL)selector
                            target:(id)target;

/**
 添加导航条右边按钮
 
 @param image 按钮图标
 @param selector 事件
 @param target 事件目标
 */
- (void)rightBarButtomItemWithImage:(NSString*)image
                           selector:(SEL)selector
                             target:(id)target;

/**
 添加导航栏左边标题
 
 @param title 按钮标题
 @param selector 事件
 @param target 事件目标
 */
- (void)leftBarButtomItemWithTitle:(NSString*)title
                          selector:(SEL)selector
                            target:(id)target;

/**
 添加导航栏右边标题
 
 @param title 按钮标题
 @param selector 事件
 @param target 事件目标
 */
- (void)rightBarButtomItemWithTitle:(NSString*)title
                           selector:(SEL)selector
                             target:(id)target;




@end
