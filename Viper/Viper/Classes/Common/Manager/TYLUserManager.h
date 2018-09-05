//
//  TYLUserManager.h
//  Nirvana
//
//  Created by tianyulong on 2017/9/17.
//  Copyright © 2017年 finupgroup. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UserInfoCallBack)(NSDictionary *userInfo, NSError *error, NSString *errorMsg);

/*
    管理用户的信息
    1.登录状态
    2.用户基本信息管理(手机号、姓名等)
 */

@interface TYLUserManager : NSObject

/**
 判断用户当前状态是否已经登录

 @return YES:已经登录, NO:未登录
 */
+ (BOOL)isLogin;

/**
 用户是否已经进行实名认证

 @return YES:已经认证
 */
+ (BOOL)isRealNameAuth;

/**
 用户名(加密后的密文)

 @return 用户名称, eg:cs6BvDrmMW8Qk6KKqGpHdA==
 */
+ (NSString *)userName;

/**
 用于显示的用户名
 
 @return 用户名称, eg:*欣
 */
+ (NSString *)userNameMask;

/**
 手机号码(加密后的密文)

 @return 手机号码, eg:fHysD0aUFFowPpXe1wpnSg==
 */
+ (NSString *)mobile;

/**
 用于显示的手机号码
 
 @return 手机号码, eg:139****8888
 */
+ (NSString *)mobileMask;

/**
 身份证号码(加密后的密文)

 @return 身份证:hRR7df1uH05g6F4qGii7nUpKJngILyfGBMMEEqfAPCw=
 */
+ (NSString *)idNo;

/**
 用于显示的身份中号码

 @return 身份证号:610528********7551
 */
+ (NSString *)idNoMask;

+ (NSString *)mail;

/**
 资产集市客户ID是否有效

 @return YES:有效
 */
+ (BOOL)validateCoreCustomerId;

+ (void)fetchUserInfomationSucceed:(UserInfoCallBack)callback;



/**
 保存用户userVO 校验实名状态

 @param data UserVO
 */
+ (void)saveUserInfo:(NSDictionary *)data;
/**
 清除所有的用户信息
 */
+ (void)clear;

@end
