//
//  TYLViperProtocol.h
//  Viper
//
//  Created by tianyulong on 2018/9/4.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TYLViperProtocol <NSObject>


/**
 获取展示器类名
 
 @return 展示器类名
 */
- (NSString *)presenterClassName;

/**
 获取交互器类名
 
 @return 交互器类名
 */
- (NSString *)interactorClassName;

/**
 获取路由类名
 
 @return 路由类名
 */
- (NSString *)wireframeClassName;


@end
