//
//  TYLBaseViewProtocol.h
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TYLBaseViewProtocol <TYLViewProtocol>

/**
 网络加载loading视图
 
 @param status UILoadStatus
 @param msg 提示文案
 */
- (void)showLoadStatuts:(UILoadStatus)status text:(NSString *)msg;

- (void)showLoadStatuts:(UILoadStatus)status text:(NSString *)msg completed:(void(^)(UILoadStatus loadStatus))complete;

@end
