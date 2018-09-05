//
//  TYLTracking.h
//  Viper
//
//  Created by tianyulong on 2018/9/5.
//  Copyright © 2018年 tianyulong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYLTracking : NSObject

dSINGLETON_FOR_CLASS_HEADER(TYLTracking)

- (void)trackModel:(id)model;

/**
 跟踪埋点的属性信息（自动埋点）
 
 @param info 属性信息
 */
+ (void)trackProperties:(NSDictionary *)info;


/**
 提交埋点信息到埋点服务器
 */
- (void)flush;

/**
 提交埋点信息到埋点服务器，带有回调
 
 @param handler 回调处理
 */
- (void)flushWithCompletion:(void (^)(void))handler;


- (void)flushH5Records:(NSArray *)jsonObjs completion:(void (^)(BOOL success, NSError *error))handler;


@end
