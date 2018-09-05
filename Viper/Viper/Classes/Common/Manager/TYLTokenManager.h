//
//  NPTokenManager.h
//  Nirvana
//
//  Created by puhui on 2017/9/12.
//  Copyright © 2017年 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 token状态
 
 - eNPTokenStateNoValidate:       token无效，不存在，或者为空
 - eNPTokenStateValidate:         token有效
 - eNPTokenStateNeedRefresh:      token需要刷新
 - eNPTokenStateExpired:          tokn已经过期
 */
typedef NS_ENUM(NSUInteger, NPTokenState) {
    eNPTokenStateNoValidate,
    eNPTokenStateValidate,
    eNPTokenStateNeedRefresh,
    eNPTokenStateExpired
};

typedef void(^NPValidTokenCallBack)(NSString *token, NPTokenState state);

@interface TYLTokenManager : NSObject

/**
 当前使用的token是否已经超过过期token的过期时间KExpiredTokenExpiredTime，如果过期，需要用户重新登录
 
 @retrun YES:过期 NO:未过期
 */
+ (BOOL)isExpired;

/**
 存储token信息，包括:
    token
    过期时间
    过期token
    过期token的过期时间
 */
+ (void)save:(NSDictionary *)tokenInfo;


/**
 存储md5Uid信息，对uid进行md5之后的字符串

 @param md5Uid md5Uid
 */
+ (void)saveMd5Uid:(NSString *)md5Uid;

/**
 是否需要到服务器获取一个新的token,只有当前时间介于“token过期时间”和“过期token的过期时间”之间时，才需要进行token的更新
 
 @return YES:需要更新， NO: 不需要更新
 */
+ (BOOL)needRefreshToken;

/**
 清除本地存储的所有token相关信息:包括token、过期token、过期时间、过期token的过期时间
 */
+ (void)clear;

/**
 当前token

 @return token
 */
+ (NSString *)token;


/**
 返回当前的md5Uid

 @return md5Uid
 */
+ (NSString *)md5Uid;

/**
 过期token

 @return token
 */
+ (NSString *)expiredToken;


/**
 token的过期时间

 @return NSNumber
 */
+ (NSNumber *)expiredTime;

/**
 过期token的过期时间

 @return NSNumber
 */
+ (NSNumber *)expiredTokenExpiredTime;

/**
 Convenient Method

 @param flag 是否需要校验token, YES:需要校验
 @param callback 获取token后，执行的回调操作;
    eg: 1.获取到有效token后，执行数据请求操作
        2.获取的token是过期的，在回调中执行登录
 */
+ (void)needVerifytoken:(BOOL)flag handleBusiness:(NPValidTokenCallBack)callback;

@end
